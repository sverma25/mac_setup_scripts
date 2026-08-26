# 🧠 Mac Dev Setup — Sahil Verma

This setup script automates installation of my preferred tools on macOS.


## ⚙️ Overview

This script installs and configures:

- Xcode Command Line Tools
- Homebrew + essential utilities (`git`, `bat`, `fzf`, `htop`, etc.)
- Productivity tools (`iterm2`, `visual-studio-code`, `cursor`, `rectangle`, etc.)
- Shared VS Code and Cursor settings, keybindings, and extension manifests
- Developer setup (optional Zsh, dotfiles, and Python/Node environments)
- Handles error handling for failed brew installs


## 🚀 Usage

1. **Clone this repo (or save the script):**
   ```bash
   git clone git@github.com:sverma25/mac_setup_scripts.git
   cd mac_setup_scripts
   ```

2. **Make the script executable:**
   ```bash
   chmod +x setup_mac.sh
   ```

3. **Run the setup:**
   ```bash
   ./setup_mac.sh
   ```


## 🧭 Post-Setup Guide: When and What to Do

| **App / Step**               | **When / Why**                                                   | **What to Do**                                                                                         |
|------------------------------|------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| **iTerm2**                   | After first launch                                               | Open **Preferences → Profiles → Colors**, and choose a font like **MesloLGS NF** for Powerlevel10k icons. |
| **Chrome**                   | First launch                                                     | Sign in to sync bookmarks, extensions, and passwords.                                                  |
| **VS Code / Cursor**         | After install                                                    | Run `./sync_editors.sh bootstrap`, then reload both editor windows.                                     |
| **GitHub CLI (`gh`)**        | First time you run `gh auth login`                               | Run `gh auth login` and follow the prompts to authenticate with GitHub.                                |
| **ChatGPT app**              | On launch                                                        | Log in with your **OpenAI account**.                                                                   |
| **Spotify**                  | On launch                                                        | Sign in to your **Spotify account**.                                                                   |
| **Notion / Todoist / Granola** | On launch                                                      | Log in to sync your workspace.                                                                         |
| **Powerlevel10k prompt**     | First time the terminal restarts                                 | If prompted, choose **“Use existing ~/.p10k.zsh”** during Powerlevel10k setup.                         |


## 📁 Next Steps

- Drop your current `.zshrc` here so it can be integrated.
- Add any custom brew formulas or Mac App Store installs if needed.

## 🧩 Shared VS Code and Cursor configuration

The `editor/` directory is the source of truth for both editors:

- `settings.json` and `keybindings.json` are shared by symlinking both editors to these files.
- `extensions.vscode.txt` and `extensions.cursor.txt` stay separate because the two marketplaces do not offer identical extensions.
- MCP configuration and credentials are deliberately excluded.

Bootstrap or repair the links and restore extensions:

```bash
./sync_editors.sh bootstrap
```

After changing settings in either editor, the Git-tracked shared file changes immediately. Refresh the extension manifests before committing changes:

```bash
./sync_editors.sh snapshot cursor
./sync_editors.sh snapshot vscode
git diff
```

Other useful commands:

```bash
./sync_editors.sh link
./sync_editors.sh install-extensions
./sync_editors.sh status
```

Existing local settings are moved to a timestamped backup under
`~/.config-backups/editor-sync/` before the links are created.
