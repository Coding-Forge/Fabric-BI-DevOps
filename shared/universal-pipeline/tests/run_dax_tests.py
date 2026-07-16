"""
Metadata-driven DAX test runner for PBIP pipelines.

The runner validates PBIP model presence and reads a dax-tests.json catalog when
available. It emits JUnit XML for CI systems. Enabled catalog tests are validated
for metadata completeness; actual DAX query execution is represented as skipped
until an evaluator such as semantic-link-labs, XMLA, or Tabular Editor scripting
is wired in.
"""

from __future__ import annotations

import argparse
import json
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


SUPPORTED_ASSERTIONS = {
    "blank",
    "between",
    "equals",
    "equalsExpression",
    "greaterThan",
    "greaterThanOrEqual",
    "greaterThanOrEqualMeasure",
    "lessThan",
    "lessThanOrEqual",
    "notBlank",
}


@dataclass
class TestResult:
    name: str
    classname: str
    status: str
    message: str = ""


def _add_case(suite: ET.Element, result: TestResult) -> None:
    case = ET.SubElement(suite, "testcase", name=result.name, classname=result.classname)
    if result.status == "failure":
        ET.SubElement(case, "failure", message=result.message)
    elif result.status == "skipped":
        ET.SubElement(case, "skipped", message=result.message)


def _load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def _find_catalog(model_path: Path, tests_path: str | None) -> Path | None:
    if tests_path:
        explicit = Path(tests_path).resolve()
        if not explicit.exists():
            raise FileNotFoundError(f"DAX test catalog not found: {explicit}")
        return explicit

    script_root = Path(__file__).resolve().parents[1]
    candidates = [
        model_path / "dax-tests.json",
        model_path.parent / "dax-tests.json",
        Path.cwd() / "dax-tests.json",
        Path.cwd() / "shared" / "dax-tests.json",
        script_root / "dax-tests.json",
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate.resolve()
    return None


def _validate_catalog(catalog: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    if not isinstance(catalog.get("tests"), list):
        errors.append("Catalog must contain a tests array.")
    return errors


def _validate_test(test: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    test_id = str(test.get("id", "")).strip()
    assertion = test.get("assertion", {})
    assertion_type = assertion.get("type") if isinstance(assertion, dict) else None
    measure = test.get("measure", {})

    if not test_id:
        errors.append("Test is missing id.")
    if not str(test.get("name", "")).strip():
        errors.append(f"{test_id or 'Unnamed test'} is missing name.")
    if not isinstance(measure, dict) or not str(measure.get("name", "")).strip():
        errors.append(f"{test_id or 'Unnamed test'} is missing measure.name.")
    if not isinstance(assertion, dict):
        errors.append(f"{test_id or 'Unnamed test'} assertion must be an object.")
    elif assertion_type not in SUPPORTED_ASSERTIONS:
        errors.append(
            f"{test_id or 'Unnamed test'} has unsupported assertion type: {assertion_type}."
        )
    if not str(test.get("query", "")).strip():
        errors.append(f"{test_id or 'Unnamed test'} is missing query.")
    if test.get("requiresCustomization") is True and test.get("enabled") is True:
        errors.append(
            f"{test_id or 'Unnamed test'} is still marked requiresCustomization=true."
        )
    return errors


def _structure_results(model_path: Path) -> list[TestResult]:
    return [
        TestResult(
            name="ModelFolderExists",
            classname="DAXStructure",
            status="passed" if model_path.is_dir() else "failure",
            message=f"Model path does not exist: {model_path}",
        ),
        TestResult(
            name="DefinitionFileExists",
            classname="DAXStructure",
            status=(
                "passed"
                if (model_path / "definition.pbism").exists()
                or any(model_path.rglob("*.pbism"))
                else "failure"
            ),
            message=f"No definition.pbism found under {model_path}",
        ),
    ]


def _catalog_results(catalog_path: Path | None) -> list[TestResult]:
    if catalog_path is None:
        return [
            TestResult(
                name="DaxTestCatalogFound",
                classname="DAXCatalog",
                status="skipped",
                message="No dax-tests.json catalog found. Structure checks only.",
            )
        ]

    try:
        catalog = _load_json(catalog_path)
    except Exception as exc:
        return [
            TestResult(
                name="DaxTestCatalogValidJson",
                classname="DAXCatalog",
                status="failure",
                message=str(exc),
            )
        ]

    results = [
        TestResult(
            name="DaxTestCatalogFound",
            classname="DAXCatalog",
            status="passed",
            message=str(catalog_path),
        )
    ]

    catalog_errors = _validate_catalog(catalog)
    if catalog_errors:
        results.append(
            TestResult(
                name="DaxTestCatalogSchema",
                classname="DAXCatalog",
                status="failure",
                message="; ".join(catalog_errors),
            )
        )
        return results

    tests = catalog.get("tests", [])
    if not tests:
        results.append(
            TestResult(
                name="DaxTestCatalogHasTests",
                classname="DAXCatalog",
                status="skipped",
                message="Catalog contains no tests.",
            )
        )
        return results

    for index, test in enumerate(tests, start=1):
        test_id = str(test.get("id") or f"Test{index}").strip()
        enabled = test.get("enabled") is True
        metadata_errors = _validate_test(test)
        if metadata_errors and enabled:
            results.append(
                TestResult(
                    name=f"{test_id}.Metadata",
                    classname="DAXCatalog",
                    status="failure",
                    message="; ".join(metadata_errors),
                )
            )
            continue

        if metadata_errors:
            results.append(
                TestResult(
                    name=f"{test_id}.Metadata",
                    classname="DAXCatalog",
                    status="skipped",
                    message="Disabled test has metadata issues: " + "; ".join(metadata_errors),
                )
            )
            continue

        results.append(
            TestResult(
                name=f"{test_id}.Metadata",
                classname="DAXCatalog",
                status="passed",
            )
        )

        if enabled:
            results.append(
                TestResult(
                    name=f"{test_id}.Execution",
                    classname="DAXExecution",
                    status="skipped",
                    message=(
                        "DAX query execution is not configured yet. Metadata validated; "
                        "wire semantic-link-labs, XMLA, or Tabular Editor scripting to execute."
                    ),
                )
            )
        else:
            results.append(
                TestResult(
                    name=f"{test_id}.Execution",
                    classname="DAXExecution",
                    status="skipped",
                    message="Test is disabled in dax-tests.json.",
                )
            )

    return results


def run_tests(model_path: str, tests_path: str | None = None) -> bool:
    """Run PBIP DAX test metadata validation and write JUnit XML results."""
    model = Path(model_path).resolve()
    results_dir = Path("test-results")
    results_dir.mkdir(parents=True, exist_ok=True)

    try:
        catalog_path = _find_catalog(model, tests_path)
        results = [*_structure_results(model), *_catalog_results(catalog_path)]
    except Exception as exc:
        results = [
            TestResult(
                name="DaxTestCatalogDiscovery",
                classname="DAXCatalog",
                status="failure",
                message=str(exc),
            )
        ]

    failures = sum(1 for result in results if result.status == "failure")
    skipped = sum(1 for result in results if result.status == "skipped")

    suite = ET.Element(
        "testsuite",
        name="DAXTests",
        tests=str(len(results)),
        failures=str(failures),
        skipped=str(skipped),
        timestamp=datetime.now(timezone.utc).isoformat(),
    )
    for result in results:
        _add_case(suite, result)

    tree = ET.ElementTree(suite)
    tree.write(results_dir / "dax-test-results.xml", xml_declaration=True, encoding="utf-8")

    print(
        f"DAX test metadata validation complete: {len(results)} checks, "
        f"{failures} failures, {skipped} skipped."
    )
    return failures == 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-path", required=True)
    parser.add_argument(
        "--tests-path",
        help="Optional path to dax-tests.json. If omitted, common repo locations are checked.",
    )
    args = parser.parse_args()

    success = run_tests(args.model_path, args.tests_path)
    return 0 if success else 1


if __name__ == "__main__":
    raise SystemExit(main())
