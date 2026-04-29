# homebrew-keybuddy

Homebrew tap for [keybuddy](https://github.com/frontmatters/keybuddy) — the macOS keychain manager that replaces your `.env` files, with an AI agent skill bundle.

## Install

```bash
brew tap frontmatters/keybuddy
brew install keybuddy
```

Then run the setup wizard:

```bash
keybuddy-setup
```

## What this tap provides

| Binary | Purpose |
|--------|---------|
| `secrets` | The CLI for credential operations (`secrets get/add/list/...`) |
| `keybuddy` | Symlink to `secrets` — same behavior, naming preference |
| `keybuddy-setup` | Interactive setup wizard (creates keychain tiers, installs agent skill) |

The sourceable bash function wrapper is installed at `$(brew --prefix)/opt/keybuddy/libexec/keybuddy.sh`. Add to your `~/.zshrc` or `~/.bashrc`:

```bash
source $(brew --prefix)/opt/keybuddy/libexec/keybuddy.sh
```

## Update

```bash
brew update
brew upgrade keybuddy
```

## Uninstall

```bash
brew uninstall keybuddy
brew untap frontmatters/keybuddy
```

Keychains created during setup are not removed automatically — see the main repo's [uninstall section](https://github.com/frontmatters/keybuddy#uninstall).

## License

MIT — same as the main project.
