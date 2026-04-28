# setup_stuff

Personal scripts and config for bootstrapping fresh dev VMs.

## vm-setup.sh

Bootstraps a fresh Linux or macOS VM with my baseline dev tooling. Idempotent — safe to re-run.

### Installs

- **nvm** (Node Version Manager)
- **Node.js** (current LTS)
- **corepack** (latest, global) + **pnpm** enabled
- **Claude Code** (via `claude.ai/install.sh`)
- **Homebrew** (with `~/.bashrc` shellenv persistence)
- Via brew: `beads`, `neovim`, `awscli`, `rtk`, `schpet/tap/linear`

### Usage

One-liner on a fresh VM:

```bash
curl -fsSL https://raw.githubusercontent.com/mjn298/setup_stuff/main/vm-setup.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/mjn298/setup_stuff.git
cd setup_stuff
bash vm-setup.sh
```

After it completes, open a new shell (or `source ~/.bashrc`) so `brew`, `node`, and the brew-installed tools are on `PATH`.

### What's not covered

Anything that requires authentication or interactive prompts is intentionally left out:

- `gh auth login` / GitHub SSH keys
- `claude` login
- `aws configure` credentials
- `linear` CLI auth
- Personal dotfiles

Run those manually after the script finishes.
