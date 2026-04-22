import argparse
import json
import sys
from pathlib import Path


def _load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def _assert_exists(path: Path, errors: list[str], description: str) -> None:
    if not path.exists():
        errors.append(f"Missing {description}: {path}")


def validate_pbip_structure(root: Path) -> list[str]:
    errors: list[str] = []

    pbip_files = sorted(root.glob("*.pbip"))
    if not pbip_files:
        return [f"No .pbip file found under {root}. Place your PBIP project files (*.pbip, *.Report/, *.SemanticModel/) locally in the folder configured as pbipPath."]
    if len(pbip_files) > 1:
        return [
            "Expected exactly one .pbip file at the project root, found: "
            + ", ".join(str(path.name) for path in pbip_files)
        ]

    pbip_file = pbip_files[0]
    pbip_config = _load_json(pbip_file)

    artifacts = pbip_config.get("artifacts", [])
    if not artifacts:
        errors.append(f"No artifacts declared in {pbip_file.name}")
        return errors

    report_path_value = artifacts[0].get("report", {}).get("path")
    if not report_path_value:
        errors.append(f"No report path declared in {pbip_file.name}")
        return errors

    report_dir = (pbip_file.parent / report_path_value).resolve()
    _assert_exists(report_dir, errors, "report directory")
    report_definition = report_dir / "definition.pbir"
    report_json = report_dir / "definition" / "report.json"
    _assert_exists(report_definition, errors, "report definition file")
    _assert_exists(report_json, errors, "report metadata file")

    if report_definition.exists():
        report_config = _load_json(report_definition)
        semantic_model_path_value = (
            report_config.get("datasetReference", {})
            .get("byPath", {})
            .get("path")
        )
        if not semantic_model_path_value:
            errors.append(f"No datasetReference.byPath.path declared in {report_definition}")
        else:
            semantic_model_dir = (report_definition.parent / semantic_model_path_value).resolve()
            _assert_exists(semantic_model_dir, errors, "semantic model directory")
            _assert_exists(
                semantic_model_dir / "definition.pbism",
                errors,
                "semantic model definition file",
            )
            _assert_exists(
                semantic_model_dir / "definition" / "model.tmdl",
                errors,
                "semantic model model.tmdl file",
            )
            _assert_exists(
                semantic_model_dir / "definition" / "relationships.tmdl",
                errors,
                "semantic model relationships.tmdl file",
            )

    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pbip-path", required=True)
    args = parser.parse_args()

    root = Path(args.pbip_path).resolve()
    if not root.exists():
        print(f"PBIP path does not exist: {root}", file=sys.stderr)
        return 1

    errors = validate_pbip_structure(root)
    if errors:
        for error in errors:
            print(error, file=sys.stderr)
        return 1

    print(f"PBIP structure validation passed for {root}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
