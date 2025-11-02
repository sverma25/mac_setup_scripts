# 🧠 Mac Dev Setup — Sahil Verma

This setup script automates installation of my preferred tools on macOS.


## ⚙️ Overview

This script installs and configures:

- Xcode Command Line Tools
- Homebrew + essential utilities (`git`, `bat`, `fzf`, `htop`, etc.)
- Productivity tools (`iterm2`, `visual-studio-code`, `rectangle`, etc.)
- Developer setup (optional Zsh, dotfiles, and Python/Node environments)
- Handles error handling for failed brew installs


## 🚀 Usage

1. **Clone this repo (or save the script):**
   ```bash
   git clone https://github.com/sahilverma/mac-setup.git
   cd mac-setup
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
| **VSCode**                   | After install                                                    | Sign in with **GitHub or Microsoft** to sync settings and extensions.                                  |
| **GitHub CLI (`gh`)**        | First time you run `gh auth login`                               | Run `gh auth login` and follow the prompts to authenticate with GitHub.                                |
| **ChatGPT app**              | On launch                                                        | Log in with your **OpenAI account**.                                                                   |
| **Spotify**                  | On launch                                                        | Sign in to your **Spotify account**.                                                                   |
| **Notion / Todoist / Granola** | On launch                                                      | Log in to sync your workspace.                                                                         |
| **Powerlevel10k prompt**     | First time the terminal restarts                                 | If prompted, choose **“Use existing ~/.p10k.zsh”** during Powerlevel10k setup.                         |


## 📁 Next Steps

- Drop your current `.zshrc` here so it can be integrated.
- Add any custom brew formulas or Mac App Store installs if needed.
