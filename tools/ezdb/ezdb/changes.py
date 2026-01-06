import re
from dataclasses import dataclass
from .paths import get_changelog_path

REGEX_CHANGE =  r"^Version\s+(?P<major>\d+)\.(?P<minor>\d+),.*?(?:\n+)(?:.*?\n)*?```sql\s*(?P<sql>.+?)\s*```"

@dataclass
class Change:
    major_version: int
    minor_version: int
    sql: str

def get_changes() -> list[Change]:
    with open(get_changelog_path(), "r") as file:
        changelog = file.read()
        changes = []

        for change_match in re.finditer(REGEX_CHANGE, changelog, re.MULTILINE | re.DOTALL):
            changes.append(Change(
                int(change_match.group("major")),
                int(change_match.group("minor")),
                change_match.group("sql")
            ))

        changes.sort(key = lambda change: (change.major_version, change.minor_version), reverse = True)

        return changes

def get_current_version():
    changes = get_changes()
    return (changes[0].major_version, changes[0].minor_version)
