# Security Notice

This repository is an **educational lab**. Its scripts create users, change
passwords, and modify ownership on the machine they run on.

- Run them **only on a disposable VM, container, or CI runner** - never on a
  production or personal machine.
- Never commit real passwords. The scripts read `LAB_PASSWORD` from the
  environment; CI generates a random, masked value on every run.
- To report a problem, open a GitHub issue (no sensitive data please).
