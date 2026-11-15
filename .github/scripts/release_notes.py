#!/usr/bin/env python3
"""Release-Notizen für GitHub-Releases bauen.

Aufbau (Markdown, Englisch wie der In-App-Changelog):
  1. optionaler Freitext aus dem Workflow-Feld „Was ist neu?“ (env NEU)
  2. alle Abschnitte aus assets/changelog/changelog.json
  3. geschlossene Issues seit dem letzten Release (JSON-Datei von `gh issue list`)

Aufruf: release_notes.py <changelog.json> <issues.json> <ausgabe.md>
"""
import json
import os
import sys


def main() -> None:
    changelog_path, issues_path, out_path = sys.argv[1:4]
    parts: list[str] = []

    neu = os.environ.get("NEU", "").strip()
    if neu:
        parts.append(neu)

    try:
        with open(changelog_path, encoding="utf-8") as f:
            changelog = json.load(f)
        for section in changelog.get("sections", []):
            title = str(section.get("title", "")).strip()
            items = [str(i).strip() for i in section.get("items", []) if str(i).strip()]
            if not items:
                continue
            block = [f"### {title}"] if title else []
            block += [f"- {i}" for i in items]
            parts.append("\n".join(block))
    except (OSError, ValueError) as e:
        # Kaputter Changelog darf das Release nicht verhindern – aber laut melden.
        print(f"::warning::changelog.json nicht lesbar: {e}")

    try:
        with open(issues_path, encoding="utf-8") as f:
            issues = json.load(f)
    except (OSError, ValueError):
        issues = []
    if issues:
        lines = ["### Closed issues"]
        for i in sorted(issues, key=lambda x: x.get("number", 0)):
            lines.append(f"- #{i.get('number')} {str(i.get('title', '')).strip()}")
        parts.append("\n".join(lines))

    text = "\n\n".join(parts).strip() or "Improvements and bug fixes."
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(text + "\n")
    print(text)


if __name__ == "__main__":
    main()
