#!/usr/bin/env python3
"""Release-Notizen für GitHub-Releases bauen.

Aufbau (Markdown, Englisch wie der In-App-Changelog „What's new“):
  1. optionaler Freitext aus dem Workflow-Feld „Was ist neu?“ (env NEU)
  2. alle Abschnitte aus assets/changelog/changelog.json – sonst nichts.
Bewusst KEINE automatische Issue-Liste: Issues werden oft erst nach der
Beta-Testphase geschlossen und gehören dann zu einer älteren Version.

Aufruf: release_notes.py <changelog.json> <ausgabe.md>
"""
import json
import os
import sys


def main() -> None:
    changelog_path, out_path = sys.argv[1:3]
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

    text = "\n\n".join(parts).strip() or "Improvements and bug fixes."
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(text + "\n")
    print(text)


if __name__ == "__main__":
    main()
