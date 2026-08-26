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
| **VS Code / Cursor**         | After install                                                    | Run `./sync_editors.sh`, then reload both editor windows.                                               |
| **GitHub CLI (`gh`)**        | First time you run `gh auth login`                               | Run `gh auth login` and follow the prompts to authenticate with GitHub.                                |
| **ChatGPT app**              | On launch                                                        | Log in with your **OpenAI account**.                                                                   |
| **Spotify**                  | On launch                                                        | Sign in to your **Spotify account**.                                                                   |
| **Notion / Todoist / Granola** | On launch                                                      | Log in to sync your workspace.                                                                         |
| **Powerlevel10k prompt**     | First time the terminal restarts                                 | If prompted, choose **“Use existing ~/.p10k.zsh”** during Powerlevel10k setup.                         |


## 📁 Next Steps

- Drop your current `.zshrc` here so it can be integrated.
- Add any custom brew formulas or Mac App Store installs if needed.

## 🧩 Shared VS Code and Cursor configuration

The `editor/` directory is a portable bundle for both editors:

- `settings.json` and `keybindings.json` are shared by symlinking both editors to these files.
- `extensions.vscode.txt` and `extensions.cursor.txt` stay separate because the two marketplaces do not offer identical extensions.
- MCP configuration and credentials are deliberately excluded.

On a new Mac, clone or download this repository, install VS Code and Cursor,
then run:

```bash
./sync_editors.sh
```

The script backs up existing settings under `~/.config-backups/editor-sync/`,
links both editors to the shared configuration, and restores each editor's
saved extensions. Because both editors use the same linked files, changing a
setting or keybinding in either one updates the Git-tracked copy immediately.
