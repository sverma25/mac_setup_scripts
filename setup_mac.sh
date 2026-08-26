#!/usr/bin/env bash
# ----------------------------------------------------------
# Mac Dev Setup Script — Sahil Verma
# ----------------------------------------------------------

# Fail fast and provide clear error messages
set -euo pipefail
trap 'echo "❌ Script failed at line $LINENO. Check the logs above for details."' ERR

echo "⚙️ Starting Mac setup..."
xcode-select --install 2>/dev/null

# ---------------------------------------------------------
# 1. Homebrew Setup
# ---------------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed"
fi

brew update && brew upgrade

# ---------------------------------------------------------
# 2. CLI Tools & Utilities
# ---------------------------------------------------------
echo "📦 Installing core CLI tools..."
brew install git gh fzf ripgrep bat exa tmux stats

# Optional helper tools
brew install nvm poetry

# ---------------------------------------------------------
# 3. Terminal Setup
# ---------------------------------------------------------
echo "💻 Installing iTerm2 and Zsh environment..."
brew install --cask iterm2

# Install Oh My Zsh if not already present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed"
fi

# Zsh plugins
brew install zsh-autosuggestions zsh-syntax-highlighting

# Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k..."
  git clone https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Copy Powerlevel10k config if available
if [ -f "./.p10k.zsh" ]; then
  cp ./.p10k.zsh ~/.p10k.zsh
fi

# Set up Zsh config
cat > ~/.zshrc << 'EOF'
# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# ---------------------------------------------------------
# 4. GUI Apps
# ---------------------------------------------------------
echo "🧰 Installing apps..."
brew install --cask \
  visual-studio-code \
  cursor \
  google-chrome \
  spotify \
  notion \
  todoist-app \
  chatgpt \
  raycast \
  rectangle \
  docker \
  granola

# ---------------------------------------------------------
# 5. Conda & Jupyter
# ---------------------------------------------------------
echo "🐍 Installing Miniconda..."
brew install --cask miniconda
eval "$(/opt/homebrew/Caskroom/miniconda/base/bin/conda shell.zsh hook)"
conda init zsh
conda install -y jupyterlab

# ---------------------------------------------------------
# 6. Git Configuration
# ---------------------------------------------------------
echo "🔧 Configuring Git..."
git config --global user.name "Sahil Verma"
git config --global user.email "tosahilverma@gmail.com"

# ---------------------------------------------------------
# 7. Shared editor configuration
# ---------------------------------------------------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/sync_editors.sh"

# ---------------------------------------------------------
# 8. Finalize
# ---------------------------------------------------------
echo "✨ Setup complete! Reloading Zsh..."
exec zsh
