# Contributing

1. Fork the repo and create a branch: `git checkout -b feature/my-change`.
2. Test on a disposable machine:
   ```bash
   sudo ./scripts/run_all.sh && sudo ./scripts/verify.sh
   sudo ./scripts/cleanup.sh
   ```
3. Lint: `shellcheck scripts/*.sh`.
4. Open a pull request using the template. CI must be green.

Commit style: short imperative subject, e.g. `Add tail -f demo to Part 2`.
