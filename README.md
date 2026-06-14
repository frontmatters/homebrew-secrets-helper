# homebrew-secrets-helper

Homebrew tap for [secrets-helper](https://github.com/frontmatters/secrets-helper) — the macOS keychain manager that replaces your `.env` files, with an AI agent skill bundle.

## Install

```bash
brew tap frontmatters/secrets-helper
brew install secrets-helper
```

Then run the setup wizard:

```bash
secrets-helper-setup
```

## What this tap provides

| Binary | Purpose |
|--------|---------|
| `secrets` | The CLI for credential operations (`secrets get/add/list/...`) |
| `secrets-helper-setup` | Interactive setup wizard (creates keychain tiers, installs agent skill) |

The sourceable bash function wrapper is installed at `$(brew --prefix)/opt/secrets-helper/libexec/secrets-helper.sh`. Add to your `~/.zshrc` or `~/.bashrc`:

```bash
source $(brew --prefix)/opt/secrets-helper/libexec/secrets-helper.sh
```

Set `SECRETS_HELPER_QUIET=1` to suppress the load banner.

## Update

```bash
brew update
brew upgrade secrets-helper
```

## Uninstall

```bash
brew uninstall secrets-helper
brew untap frontmatters/secrets-helper
```

Keychains created during setup are not removed automatically — see the main repo's [uninstall section](https://github.com/frontmatters/secrets-helper#uninstall).

## License

MIT — same as the main project.
