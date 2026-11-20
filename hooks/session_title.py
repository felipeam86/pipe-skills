import json
import os
import re
import subprocess
import sys
import urllib.request

SKILLS = ("implement", "assess", "review", "ship", "prd")
COMMAND = re.compile(r"^\s*/(?:pipe-skills:)?(" + "|".join(SKILLS) + r")(?:\s+(.*))?$", re.S)
GITHUB = re.compile(r"^(?:GH-|#)?(\d+)$", re.I)
LINEAR = re.compile(r"^[A-Z][A-Z0-9]*-\d+$", re.I)
PR_TITLE = re.compile(r"^([A-Z][A-Z0-9]*-\d+)[\s:-]+(.+)$")
TIMEOUT = 5


def argument(args):
    words = args.split()
    while words and words[0].lower() in ("update", "issue", "pr"):
        words.pop(0)
    return words[0].rstrip(",.:;") if words else ""


def gh(kind, number, cwd):
    out = subprocess.run(
        ["gh", kind, "view", number, "--json", "title", "--jq", ".title"],
        cwd=cwd, capture_output=True, text=True, timeout=TIMEOUT,
    )
    return out.stdout.strip() if out.returncode == 0 else None


def linear(identifier):
    key = os.environ.get("LINEAR_API_KEY")
    if not key:
        return None
    request = urllib.request.Request(
        "https://api.linear.app/graphql",
        data=json.dumps({
            "query": "query($id: String!) { issue(id: $id) { title } }",
            "variables": {"id": identifier},
        }).encode(),
        headers={"Authorization": key, "Content-Type": "application/json"},
    )
    with urllib.request.urlopen(request, timeout=TIMEOUT) as response:
        return json.load(response)["data"]["issue"]["title"]


def fetch(call, *args):
    try:
        return call(*args)
    except Exception:
        return None


def name(skill, token, cwd):
    github = GITHUB.match(token)
    if github:
        number = github.group(1)
        # review takes a pull request number; its title starts with the issue identifier.
        if skill == "review" and not token.upper().startswith("GH-"):
            title = fetch(gh, "pr", number, cwd)
            match = PR_TITLE.match(title or "")
            if match:
                return match.group(1), match.group(2)
            return f"#{number}", title
        return f"GH-{number}", fetch(gh, "issue", number, cwd)
    if LINEAR.match(token):
        return token.upper(), fetch(linear, token.upper())
    return None, None


def main():
    data = json.load(sys.stdin)
    command = COMMAND.match(data.get("prompt", ""))
    if not command:
        return
    skill = command.group(1)
    token = argument(command.group(2) or "")
    identifier, title = name(skill, token, data.get("cwd"))
    if not identifier:
        return
    session = f"/{skill} {identifier}" + (f" - {title}" if title else "")
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "sessionTitle": session}}))


if __name__ == "__main__":
    main()
