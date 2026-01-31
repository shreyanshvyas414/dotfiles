# Interactive shells only
[[ -o interactive ]] || return

# Zsh completion dump location
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# Core config
source "$HOME/.zsh/options.zsh"
source "$HOME/.zsh/history.zsh"
source "$HOME/.zsh/paths.zsh"
source "$HOME/.zsh/aliases.zsh"
source "$HOME/.zsh/tools.zsh"

# Powerlevel10k
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Homebrew (must be last)
eval "$(/opt/homebrew/bin/brew shellenv)"

