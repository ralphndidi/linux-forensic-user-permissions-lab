# Linux Forensic User & Permissions Lab

[![Lab Validation](https://github.com/YOUR_USERNAME/linux-forensic-user-permissions-lab/actions/workflows/lab-validation.yml/badge.svg)](https://github.com/YOUR_USERNAME/linux-forensic-user-permissions-lab/actions/workflows/lab-validation.yml)
![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)
![Shell](https://img.shields.io/badge/shell-bash-4EAA25.svg)
![Platform](https://img.shields.io/badge/platform-Ubuntu%20%7C%20Debian-E95420.svg)

Hands-on Linux exercise covering **user management, log analysis with text-processing tools, and file permissions/ownership**, packaged as reproducible scripts with a **GitHub Actions workflow that runs and verifies the entire lab** on every push.

## What you practise

| Part | Topic | Tools |
|------|-------|-------|
| 1 | New user setup | `useradd`, `usermod`, `passwd`, `su`, `mkdir`, `echo`, `cat` |
| 2 | Log filtering & analysis | `grep`, pipes `\|`, redirection `> >>`, `less`, `head`, `tail`, `cat` |
| 3 | Permissions & ownership | `chmod`, `chown`, `sudo`, `ls -l` |
| 4 | User management | `useradd`, `usermod -aG`, `userdel -r` |

## Repository structure

```
.
├── .github/
│   ├── workflows/lab-validation.yml   # CI: lint + run lab + verify + upload evidence
│   ├── dependabot.yml
│   ├── ISSUE_TEMPLATE/bug_report.md
│   └── PULL_REQUEST_TEMPLATE.md
├── scripts/
│   ├── lib.sh                  # shared helpers
│   ├── 01_user_setup.sh        # Part 1.1-1.2
│   ├── 02_create_logs.sh       # Part 1.3 (20+ line mock log)
│   ├── 03_log_analysis.sh      # Part 2
│   ├── 04_permissions.sh       # Part 3
│   ├── 05_user_management.sh   # Part 4
│   ├── run_all.sh              # runs everything, saves evidence/
│   ├── verify.sh               # 19 automated checks
│   └── cleanup.sh              # removes lab users
├── docs/SUBMISSION_CHECKLIST.md
├── screenshots/                # put your terminal screenshots here
├── commands_used.txt           # SUBMISSION: exact commands
├── EXPLANATION.md              # SUBMISSION: grep / chown / usermod + lessons
├── CONTRIBUTING.md  SECURITY.md  LICENSE  .gitignore
└── README.md
```

## Quick start

> ⚠️ **Run only on a disposable VM/container.** The scripts create users and change passwords.

```bash
git clone https://github.com/YOUR_USERNAME/linux-forensic-user-permissions-lab.git
cd linux-forensic-user-permissions-lab
chmod +x scripts/*.sh

# Full automated run (set a password non-interactively, or omit to be prompted)
sudo LAB_PASSWORD='ChangeMe#123' ./scripts/run_all.sh
sudo ./scripts/verify.sh      # prints PASS/FAIL for every requirement
sudo ./scripts/cleanup.sh     # delete forensic01, guest1, guest2
```

Prefer typing the commands yourself? Follow [`commands_used.txt`](commands_used.txt) step by step.

## GitHub Actions workflow

`.github/workflows/lab-validation.yml` runs on push, pull request and manual dispatch:

1. **ShellCheck** lints every script.
2. **run-lab** (matrix: Ubuntu 22.04 and 24.04) executes Parts 1-4 with a random, masked password.
3. **verify.sh** asserts all requirements (user, sudo group, 20+ log lines, `600` perms, root ownership, *Permission denied*, guest2 deleted...).
4. Results appear in the **job summary**; logs and output files are uploaded as the `lab-evidence-*` **artifact**.
5. Lab users are cleaned up even if a step fails.

## Submission

Complete the [submission checklist](docs/SUBMISSION_CHECKLIST.md): `commands_used.txt`, screenshots, and `EXPLANATION.md`.

## License

[MIT](LICENSE)
