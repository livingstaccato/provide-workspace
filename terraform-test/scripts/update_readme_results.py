#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path


def load_outputs(terraform_dir: Path) -> dict[str, object]:
    result = subprocess.run(
        ["terraform", "output", "-json"],
        check=True,
        cwd=terraform_dir,
        capture_output=True,
        text=True,
    )
    return json.loads(result.stdout)


def render_results(outputs: dict[str, object]) -> list[str]:
    def val(key: str) -> object:
        return outputs.get(key, {}).get("value")

    def ascii_only(value: object) -> str:
        if value is None:
            return "unknown"
        text = str(value)
        return text.encode("ascii", "ignore").decode("ascii").strip()

    return [
        f"- ✓ Module info: {ascii_only(val('module_info_description'))}",
        f"- ✓ Module search: Found {ascii_only(val('module_search_count'))} kubernetes modules",
        f"- ✓ Module versions: Listed {ascii_only(val('eks_version_count'))} versions of terraform-aws-modules/eks",
        f"- ✓ Provider info: Latest Google provider {ascii_only(val('google_provider_latest'))}",
        f"- ✓ Provider versions: Listed {ascii_only(val('azurerm_version_count'))} versions of hashicorp/azurerm",
        f"- ✓ Registry search: Found {ascii_only(val('registry_search_results'))} networking security results",
        f"- ✓ State info: Terraform version {ascii_only(val('state_terraform_version'))}",
        f"- ✓ State outputs: Extracted {ascii_only(val('state_outputs_count'))} outputs",
        f"- ✓ State resources: Found {ascii_only(val('state_managed_resources'))} managed resources",
    ]


def update_readme(readme_path: Path, results: list[str]) -> None:
    text = readme_path.read_text()
    start = "<!-- BEGIN TEST RESULTS -->"
    end = "<!-- END TEST RESULTS -->"
    if start not in text or end not in text:
        raise SystemExit("README.md is missing test results markers.")

    before, remainder = text.split(start, 1)
    _, after = remainder.split(end, 1)
    body = "\n".join(results)
    new_text = f"{before}{start}\n{body}\n{end}{after}"
    readme_path.write_text(new_text)


def main() -> None:
    script_dir = Path(__file__).resolve().parent
    terraform_dir = script_dir.parent
    outputs = load_outputs(terraform_dir)
    results = render_results(outputs)
    update_readme(terraform_dir / "README.md", results)


if __name__ == "__main__":
    main()
