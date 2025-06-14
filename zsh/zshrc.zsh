# PlugIns
plugins=(
    git
    zsh-autosuggestions
    zsh-eza
    zsh-syntax-highlighting
)

# Tab completion
autoload -Uz compinit;compinit -i

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

# Directory containing the .zsh files
config_dir="$HOME/.config/zsh"

# Check if the directory exists
if [[ -d $config_dir ]]; then
    # Loop through all .zsh files in the directory
    for file in "$config_dir"/*.zsh; do
        # Check if the file exists and is not the current script being sourced
        if [[ -f $file && $file != "$0" ]]; then
            # Avoid sourcing the same file recursively
            if ! [[ "${sourced_files[*]}" =~ $file ]]; then
                sourced_files+=("$file")
                source "$file"
            fi
        fi
    done
else
    echo "Directory not found: $config_dir"
fi

# Source
source $HOME/.local/share/fzf/key-bindings.zsh
source $HOME/.local/share/fzf/completion.zsh
source <(fzf --zsh)

# Eval
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
