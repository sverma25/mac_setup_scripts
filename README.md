# Mac development setup

This repository provisions a new macOS development machine and keeps VS Code
and Cursor configuration reproducible. User-specific Git identity is supplied
at runtime and is never stored in the repository.

## What it configures

- Xcode Command Line Tools and Homebrew
- Command-line development utilities
- iTerm2, Oh My Zsh, Powerlevel10k, and Zsh plugins
- VS Code, Cursor, and other desktop applications
- Miniconda and JupyterLab
- Global Git name and email from environment variables
- Shared VS Code and Cursor settings, keybindings, and extensions

## Instructions for a setup agent

When asked to set up a Mac from this repository, perform these steps in order:

1. Confirm that the machine is running macOS and that the user understands the
   script installs applications and changes shell, Git, and editor configuration.
2. Obtain the Git author name and email that the user wants on new commits. Do
   not guess them, print them in logs, or write them into repository files.
3. Clone the repository and enter it:

   ```bash
   git clone https://github.com/sverma25/mac_setup_scripts.git
   cd mac_setup_scripts
   ```

4. Export the required values in the current shell, substituting the values
   provided by the user:

   ```bash
   export MAC_SETUP_GIT_NAME='<git author name>'
   export MAC_SETUP_GIT_EMAIL='<git author email>'
   ```

5. Review `setup_mac.sh` with the user if the machine already has customized
   shell or editor configuration. Then run:

   ```bash
   ./setup_mac.sh
   ```

6. Complete any interactive installers or sign-ins that require the user, then
   run the verification commands below. Report failures instead of silently
   skipping them.

The script validates both required environment variables before changing the
machine. They apply only to the current shell and are not persisted by this
repository.

## Manual usage

For a person running the setup directly, the minimal invocation is:

```bash
git clone https://github.com/sverma25/mac_setup_scripts.git
cd mac_setup_scripts
export MAC_SETUP_GIT_NAME='<git author name>'
export MAC_SETUP_GIT_EMAIL='<git author email>'
./setup_mac.sh
```

Use a GitHub-provided `noreply` address for `MAC_SETUP_GIT_EMAIL` if you do not
want a personal email address attached to public commits.

## Editor configuration

The `editor/` directory is a portable bundle for both editors:

- `settings.json` and `keybindings.json` are shared by symlinking both editors
  to these files.
- `extensions.vscode.txt` and `extensions.cursor.txt` stay separate because the
  two marketplaces do not offer identical extensions.
- MCP configuration and credentials are deliberately excluded.

To configure only the editors, run:

```bash
./sync_editors.sh
```

`sync_editors.sh` backs up existing settings under
`~/.config-backups/editor-sync/`, links both editors to the shared
configuration, and restores each editor's saved extensions. Because both
editors use the same linked files, changing a setting or keybinding in either
one updates the Git-tracked copy immediately. Keep the cloned repository at a
stable path so those links do not break.

## Verification

After the setup finishes, verify the automated portions:

```bash
brew --version
git config --global --get user.name
git config --global --get user.email
code --list-extensions
cursor --list-extensions
```

Then verify the remaining interactive setup:

- Reload VS Code and Cursor and confirm settings and keybindings are present.
- Open iTerm2 and confirm Powerlevel10k loads correctly.
- Authenticate GitHub CLI with `gh auth login` if needed.
- Sign in to applications whose data should sync.

Credentials, tokens, MCP configuration, and application session data must not
be committed to this repository.
