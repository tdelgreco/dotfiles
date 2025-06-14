_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

# Modify config
function myIP () { wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1 | sed -e 's/^[[:space:]]*//'}
function reload_zsh () { source ~/.zshrc; }
function logoff () { i3-msg exit; }
function yy () { var=$(xclip -selection c -o); youtube-dl $var }
function calc () { echo "$@" | bc -l }

# pacman
function cleanup-package () { doas pacman -Rns $(pacman -Qdtq); }

function install-package() {
    # Check if 'pacman' is installed
    if ! command -v pacman &> /dev/null; then
        echo "Error: 'pacman' is not installed. Please install it first."
        return 1
    fi

    # Check if 'doas' is installed
    if ! command -v doas &> /dev/null; then
        echo "Error: 'doas' is not installed. Please install it first."
        return 1
    fi

    # Define the cache file
    local cache_file="$HOME/.install_package_cache"

    # Update the cache if it does not exist or is older than 1 day
    if [[ ! -f "$cache_file" ]] || [[ $(find "$cache_file" -mtime +1) ]]; then
        # Retrieve the package list from the synchronized repositories
        # 'pacman -Sl' lists packages with repository names, package names, and other details
        # We extract the package name (second column) here
        pacman -Sl | awk '{print $2}' | sort -u > "$cache_file"
    fi

    # Select packages using fzf
    local selected_packages
    selected_packages=$(cat "$cache_file" | \
        fzf --header="📦 Install Pacman Packages" \
            --multi \
            --height=40% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Select packages: " \
            --preview 'pacman -Si {}')

    # Check if any packages were selected
    if [[ -n "$selected_packages" ]]; then
        # Convert the selected packages into an array, only non-empty lines
        local packages_array=()
        while IFS= read -r pkg; do
            # Trim leading/trailing whitespace
            pkg=$(echo "$pkg" | xargs)
            # Add only non-empty packages
            if [[ -n "$pkg" ]]; then
                packages_array+=("$pkg")
            fi
        done <<< "$selected_packages"

        # Check if the array is not empty
        if [ ${#packages_array[@]} -gt 0 ]; then
            # List the selected packages for confirmation
            echo "Installing the following packages:\n"
            for pkg in "${packages_array[@]}"; do
                echo " - $pkg"
            done
            echo
            doas pacman -S "${packages_array[@]}"
        else
            echo "No valid packages selected."
        fi
    else
        echo "No packages selected."
    fi
}

function uninstall-package() {
    # Check if 'pacman' is installed
    if ! command -v pacman &> /dev/null; then
        echo "Error: 'pacman' is not installed. Please install it first."
        return 1
    fi

    # Check if 'doas' is installed
    if ! command -v doas &> /dev/null; then
        echo "Error: 'doas' is not installed. Please install it first."
        return 1
    fi

    # Retrieve the list of installed packages directly
    local installed_packages
    installed_packages=$(pacman -Qq | sort -u)

    # Check if there are any installed packages
    if [[ -z "$installed_packages" ]]; then
        echo "No packages are currently installed."
        return 0
    fi

    # Select packages using fzf
    local selected_packages
    selected_packages=$(echo "$installed_packages" | \
        fzf --header="🗑️ Remove Pacman Packages" \
            --multi \
            --height=40% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Select packages to remove: " \
            --preview 'pacman -Qi {}')

    # Check if any packages were selected
    if [[ -n "$selected_packages" ]]; then
        # Convert the selected packages into an array, ensuring no empty lines
        local packages_array=()
        while IFS= read -r pkg; do
            # Trim leading and trailing whitespace
            pkg=$(echo "$pkg" | xargs)
            # Add only non-empty packages to the array
            if [[ -n "$pkg" ]]; then
                packages_array+=("$pkg")
            fi
        done <<< "$selected_packages"

        # Check if the array is not empty
        if [ ${#packages_array[@]} -gt 0 ]; then
            # List the selected packages for removal
            echo -e "\nRemoving the following packages:\n"
            for pkg in "${packages_array[@]}"; do
                echo " - $pkg"
            done
            echo

            # Remove the selected packages; pacman will handle the confirmation
            doas pacman -Rns "${packages_array[@]}"
        else
            echo "No valid packages selected for removal."
        fi
    else
        echo "No packages selected."
    fi
}

function list-package() {
    # Check if 'pacman' is installed
    if ! command -v pacman &> /dev/null; then
        echo "Error: 'pacman' is not installed. Please install it first."
        return 1
    fi

    # Define the cache file
    local cache_file="$HOME/.list_package_cache"

    # Update the cache if it does not exist or is older than 1 day
    if [[ ! -f "$cache_file" ]] || [[ $(find "$cache_file" -mtime +1) ]]; then
        pacman -Qq | sort -u > "$cache_file"
    fi

    # Select the package using fzf
    local pkg
    pkg=$(cat "$cache_file" | \
        fzf --header="📦 Package List" \
            --height=40% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Select a package: " \
            --preview 'pacman -Qi {}' \
            --bind 'enter:execute(pacman -Qi {} | less -R)')

    # If a package is selected, display the package information with colors
    if [[ -n "$pkg" ]]; then
        pacman -Qi "$pkg" | less -R
    fi
}

function find-package() {
    # Check if 'pacman' is installed
    if ! command -v pacman &> /dev/null; then
        echo "Error: 'pacman' is not installed. Please install it first."
        return 1
    fi

    # Check if 'fzf' is installed
    if ! command -v fzf &> /dev/null; then
        echo "Error: 'fzf' is not installed. Please install it first."
        return 1
    fi

    # Use fzf to search and select a package directly
    local selected_package
    selected_package=$(pacman -Sl | awk '{print $2}' | cut -d '/' -f2 | sort -u | \
        fzf --header="🔍 Search Pacman Packages" \
            --height=40% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Search & Select: " \
            --preview 'pacman -Si {}' \
            --bind 'enter:execute(pacman -Si {} | less)' \
            --preview-window=right:60%:wrap)

    # If a package is selected, show package information
    if [[ -n "$selected_package" ]]; then
        pacman -Si "$selected_package" | less
    else
        echo "No package selected."
    fi
}

# yay
function install-aurpackage() {
    # Check if 'yay' is installed
    if ! command -v yay &> /dev/null; then
        echo "Error: 'yay' is not installed. Please install it first."
        return 1
    fi

    # Check if 'doas' is installed
    if ! command -v doas &> /dev/null; then
        echo "Error: 'doas' is not installed. Please install it first."
        return 1
    fi

    # Define the cache file
    local cache_file="$HOME/.install_aurpackage_cache"

    # Update the cache if it does not exist or is older than 1 day
    if [[ ! -f "$cache_file" ]] || [[ $(find "$cache_file" -mtime +1) ]]; then
        # Retrieve the list of available AUR packages using YAY
        yay -Sl | awk '{print $2}' | sort -u > "$cache_file"
    fi

    # Select packages using fzf
    local selected_packages
    selected_packages=$(cat "$cache_file" | \
        fzf --header="📦 Install YAY AUR Packages" \
            --multi \
            --height=70% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Select packages: " \
            --preview 'yay -Si {}')

    # Check if any packages were selected
    if [[ -n "$selected_packages" ]]; then
        # Convert the selected packages into an array, ignoring empty lines
        local packages_array=()
        while IFS= read -r pkg; do
            # Trim leading/trailing whitespace
            pkg=$(echo "$pkg" | xargs)
            # Add only non-empty packages
            if [[ -n "$pkg" ]]; then
                packages_array+=("$pkg")
            fi
        done <<< "$selected_packages"

        # Check if the array is not empty
        if [ ${#packages_array[@]} -gt 0 ]; then
            # List the selected packages for confirmation
            echo -e "The following packages will be installed:\n"
            for pkg in "${packages_array[@]}"; do
                echo " - $pkg"
            done
            echo
            doas yay -S "${packages_array[@]}"
        else
            echo "No valid packages selected."
        fi
    else
        echo "No packages selected."
    fi
}

function find-aurpackage() {
    # Check if 'yay' is installed
    if ! command -v yay &> /dev/null; then
        echo "Error: 'yay' is not installed. Please install it first."
        return 1
    fi

    # Check if 'fzf' is installed
    if ! command -v fzf &> /dev/null; then
        echo "Error: 'fzf' is not installed. Please install it first."
        return 1
    fi

    # Use fzf to search and select a package directly
    local selected_package
    selected_package=$(yay -Sla | awk '{print $2}' | cut -d '/' -f2 | sort -u | \
        fzf --header="🔍 Search YAY AUR Packages" \
            --height=70% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Search & Select: " \
            --preview 'yay -Si {}' \
            --bind 'enter:execute(yay -Si {} | less)' \
            --preview-window=right:60%:wrap)

    # If a package is selected, show package information
    if [[ -n "$selected_package" ]]; then
        yay -Si "$selected_package" | less
    else
        echo "No package selected."
    fi
}

# Misc
function myColormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

function pdf {
	mupdf $1 > /dev/null 2>&1
}

# Fuzzy Manpage
function myManpage() {
    if ! command -v man &> /dev/null; then
        echo "Error: 'man' is not installed or not in PATH."
        return 1
    fi

    # Define cache file.
    local cache_file="$HOME/.myManpage_apropos_cache"

    # Refresh the cache if it does not exist or is older than 1 day.
    if [[ ! -f "$cache_file" ]] || [[ $(find "$cache_file" -mtime +1) ]]; then
        apropos . | awk -F ' \\(' '{print $1}' | sort -u > "$cache_file"
    fi

    # Interactive selection with fzf using the cache.
    local cmd
    cmd=$(cat "$cache_file" | \
        fzf --header="📖 Manpages" \
            --height=40% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Select a manpage: " \
    )

    if [[ -n "$cmd" ]]; then
        man "$cmd"
    fi
}

# Fuzzy tldr
function myTldr() {
    if ! command -v tldr &> /dev/null; then
        echo "Error: 'tldr' is not installed. Please install it first."
        return 1
    fi

    # Define cache file.
    local cache_file="$HOME/.myTldr_apropos_cache"

    # Refresh the cache if it does not exist or is older than 1 day.
    if [[ ! -f "$cache_file" ]] || [[ $(find "$cache_file" -mtime +1) ]]; then
        apropos . | awk -F ' \\(' '{print $1}' | sort -u > "$cache_file"
    fi

    local cmd
    cmd=$(cat "$cache_file" | \
        fzf --header="📖 TLDR" \
            --height=40% \
            --layout=reverse \
            --border \
            --ansi \
            --prompt="Select a command : " \
    )

    if [[ -n "$cmd" ]]; then
        tldr "$cmd"
    fi
}

# zoxide change directory
function zcd () {
  local dir
  dir=$(zoxide query --interactive "$@") || return

  # Switch to the selected directory
  cd "$dir" || return
}

function open-myFile() {
  # Show only regular files, fzf with reverse layout and preview on the right
  local file
  file=$(/bin/ls -p | grep -v '/$' | fzf \
    --layout=reverse \
    --height=50% \
    --ansi \
    --border \
    --preview='bat --color=always --style=numbers --line-range :200 {}' \
    --preview-window='right:60%,border-left')

  # If a valid file is selected, open it in $EDITOR; otherwise, skip
  if [[ -n "$file" && -f "$file" ]]; then
    "$EDITOR" "$file"
  else
    echo "No valid file selected."
  fi
}
