#!/usr/bin/env python3
"""
Fabric BI DevOps Accelerator — Local Dev Server

Replaces `python -m http.server 8000` with a server that also allows
browser tools to save JSON files back to the shared/ folder without a
manual download-and-move workflow.

Usage:
    cd C:\\Projects\\Fabric-BI-DevOps-Demo
    python shared/scripts/serve.py [port]   (default: 8000)

What the /api/save endpoint does:
    Tools POST JSON with {path, content} to http://localhost:8000/api/save
    The server validates the path and writes the file to disk.
    On success: {"ok": true, "path": "shared/Rules-Report.json"}
    On error:   {"ok": false, "error": "reason"}

Security guardrails (local dev only — do NOT expose to a network):
    - Binds to 127.0.0.1 only (localhost)
    - Path traversal blocked (target must be inside the repo root)
    - Writes restricted to: shared/ directory
    - Only .json, .yml, .yaml, .md extensions allowed
"""

import json
import os
import sys
import socket
import mimetypes
from http.server import HTTPServer, BaseHTTPRequestHandler
from pathlib import Path
from urllib.parse import urlparse, unquote

# Repo root — script lives at shared/scripts/serve.py so go two levels up
ROOT = Path(__file__).resolve().parent.parent.parent

# Only these top-level directories can be written to
ALLOWED_WRITE_DIRS = {"shared"}

# Only these file extensions are writable
ALLOWED_EXTENSIONS = {".json", ".yml", ".yaml", ".md"}


class FabricDevServer(BaseHTTPRequestHandler):
    """Static file server + /api/save write endpoint."""

    def do_GET(self):
        """Serve static files without truncation."""
        # Parse request path
        parsed = urlparse(self.path)
        path_component = unquote(parsed.path)
        if path_component.startswith("/"):
            path_component = path_component[1:]
        
        # Resolve file
        target = (ROOT / path_component).resolve()
        
        # Security: stay within ROOT
        try:
            target.relative_to(ROOT)
        except ValueError:
            self.send_error(403, "Forbidden")
            return
        
        # Handle directory by serving index.html
        if target.is_dir():
            target = target / "index.html"
        
        # Serve file if it exists
        if target.exists() and target.is_file():
            try:
                with open(target, "rb") as f:
                    content = f.read()
                
                # Determine MIME type
                ctype, _ = mimetypes.guess_type(str(target))
                if ctype is None:
                    ctype = "application/octet-stream"
                
                # Send response
                self.send_response(200)
                self.send_header("Content-Type", ctype)
                self.send_header("Content-Length", str(len(content)))
                self.send_header("Cache-Control", "max-age=0")
                self.end_headers()
                self.wfile.write(content)
            except Exception as e:
                self.send_error(500, f"Error: {e}")
        else:
            self.send_error(404, "File not found")

    def do_OPTIONS(self):
        """CORS preflight for fetch() calls from the browser."""
        self.send_response(204)
        self._cors()
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_POST(self):
        parsed = urlparse(self.path)
        if parsed.path == "/api/save":
            self._handle_save()
        else:
            self.send_error(404, "Not found")

    def _handle_save(self):
        try:
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length)
            data = json.loads(body)

            rel_path = data.get("path", "").strip().lstrip("/\\")
            content = data.get("content", "")

            if not rel_path:
                self._json_error(400, "Missing 'path' in request body")
                return

            # Resolve and validate target path
            target = (ROOT / rel_path).resolve()

            # 1. Block directory traversal
            try:
                target.relative_to(ROOT)
            except ValueError:
                self._json_error(403, "Path escapes the repository root")
                return

            # 2. Only allow writes inside permitted directories
            relative = target.relative_to(ROOT)
            top_dir = relative.parts[0] if relative.parts else ""
            if top_dir not in ALLOWED_WRITE_DIRS:
                allowed = ", ".join(sorted(ALLOWED_WRITE_DIRS))
                self._json_error(403, f"Write blocked. Allowed directories: {allowed}/")
                return

            # 3. Only allow specific file extensions
            if target.suffix.lower() not in ALLOWED_EXTENSIONS:
                allowed = ", ".join(sorted(ALLOWED_EXTENSIONS))
                self._json_error(403, f"File type not allowed. Allowed: {allowed}")
                return

            # Write the file (create intermediate dirs if needed)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content, encoding="utf-8")

            saved_rel = str(relative).replace("\\", "/")
            print(f"  SAVED  {saved_rel}")
            self._json_response(200, {"ok": True, "path": saved_rel})

        except json.JSONDecodeError:
            self._json_error(400, "Request body is not valid JSON")
        except PermissionError as exc:
            self._json_error(403, f"Permission denied: {exc}")
        except Exception as exc:
            self._json_error(500, f"Server error: {exc}")

    def _json_response(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self._cors()
        self.end_headers()
        self.wfile.write(body)

    def _json_error(self, status, message):
        print(f"  ERROR  {status} — {message}")
        self._json_response(status, {"ok": False, "error": message})

    def _cors(self):
        self.send_header("Access-Control-Allow-Origin", "http://localhost:8000")

    def log_message(self, fmt, *args):
        # Suppress successful GET noise; keep POST and errors visible
        if args and len(args) >= 2 and str(args[1]).startswith("2") and fmt.startswith('"%s"'):
            method = args[0].split()[0] if args[0] else ""
            if method == "GET":
                return
        super().log_message(fmt, *args)


def is_port_available(port: int) -> bool:
    """Check if a port is available on localhost."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex(("127.0.0.1", port))
        sock.close()
        return result != 0  # 0 means connection succeeded (port in use)
    except Exception:
        return False


def find_available_port(preferred: int = 8000, fallbacks: list = None) -> int:
    """Find an available port, trying preferred first then fallbacks."""
    if fallbacks is None:
        fallbacks = [8001, 8080, 9000]
    
    ports_to_try = [preferred] + fallbacks
    
    for port in ports_to_try:
        if is_port_available(port):
            return port
    
    # If all are taken, return the first fallback anyway (will fail with clear error)
    return ports_to_try[0]


def run(port: int = 8000) -> None:
    os.chdir(ROOT)
    server = HTTPServer(("127.0.0.1", port), FabricDevServer)
    print()
    print("  +=========================================================+")
    print("  |      Fabric BI DevOps Accelerator — Dev Server        |")
    print("  +=========================================================+")
    print()
    print(f"  Launchpad : http://localhost:{port}/tools/index.html")
    print(f"  Root      : {ROOT}")
    print(f"  Save API  : POST http://localhost:{port}/api/save")
    print()
    print("  Tools can now save JSON directly to shared/ folder.")
    print("  Use the 'Save to repo' button in any tool toolbar.")
    print()
    print("  Press Ctrl+C to stop.")
    print()
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n  Server stopped.")


if __name__ == "__main__":
    preferred_port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    port = find_available_port(preferred_port)
    
    if port != preferred_port:
        print(f"  Note: Port {preferred_port} is in use. Using port {port} instead.")
        print()
    
    run(port)
