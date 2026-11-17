"""Replaces what identifies the Azure account in a run's output with placeholders, for transcripts/:
    python ep01_foundry_setup/first_call.py | python infra/redact.py > transcripts/s4e1-foundry-setup.txt"""
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def env():
    out = {}
    if (ROOT / ".env").exists():
        for line in (ROOT / ".env").read_text().splitlines():
            if "=" in line and not line.startswith("#"):
                k, v = line.split("=", 1)
                out[k.strip()] = v.strip()
    return out


def account():
    try:
        r = subprocess.run(["az", "account", "show", "--query", "[id, tenantId, user.name]", "-o", "tsv"],
                           capture_output=True, text=True, timeout=60)
        return r.stdout.split()
    except (OSError, subprocess.TimeoutExpired):
        return []


def main():
    text = sys.stdin.read()
    e = env()
    ids = account()
    for value, placeholder in zip(ids, ["<subscription-id>", "<tenant-id>", "<account>"]):
        text = text.replace(value, placeholder)
    if e.get("FOUNDRY_RESOURCE"):
        text = text.replace(e["FOUNDRY_RESOURCE"], "<resource>")
    text = re.sub(r"\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b", "<id>", text)
    sys.stdout.write(text)


if __name__ == "__main__":
    main()
