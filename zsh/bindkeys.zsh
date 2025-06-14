# Activate Emacs Mode
bindkey -v

# Move the cursor to the beginning of the line: 'Pos1 key'
bindkey "^[[H" beginning-of-line

# Move the cursor to the end of the line: 'End key'
bindkey "^[[F" end-of-line

# Move the cursor left: 'Left Arrow key'
bindkey "^[[D" backward-char

# Move the cursor right: 'Right Arrow key'
bindkey "^[[C" forward-char

# Move the cursor word-wise left: 'Ctrl+Left Arrow'
bindkey "^[[1;5D" backward-word

# Move the cursor word-wise right: 'Ctrl+Right Arrow'
bindkey "^[[1;5C" forward-word

# Map Insert key (no default Zsh function, usually ignored)
bindkey "^[[2~" overwrite-mode

# Delete the character under the cursor: 'Delete key'
bindkey "^[[3~" delete-char

# autosuggest-accept: 'Ctrl+Space a'
# bindkey -s "\C-@a" autosuggest-accept

# Open lazygit: 'Ctrl+Space g'
bindkey -s '\C-@g' ' lazygit \n'

# Open vscodium: 'Ctrl+Space o'
# bindkey -s '\C-@o' ' zeditor .\n'
bindkey -s '\C-@o' ' vscodium .\n'

# Open yazi: 'Ctrl+Space e'
#bindkey -s '\C-@e' ' yazi .\n'
bindkey -s '^e' ' yazi .\n'

# Install package 'p i'
bindkey -s '^Pi' ' install-package .\n'

# Remove package 'p u'
bindkey -s '^Pu' ' uninstall-package .\n'

# List installed packages 'p l'
bindkey -s '^Pl' ' list-package .\n'

# Find installed packages 'p f'
bindkey -s '^Pf' ' find-package .\n'

# Install AUR package 'p y'
bindkey -s '^Yi' ' install-aurpackage .\n'

# Find AUR package 'p y'
bindkey -s '^Yf' ' find-aurpackage .\n'

# Reload zsh
bindkey -s '\C-@r' ' reload_zsh .\n'

# Open man: 'Alt+h'
bindkey -s '^[h' ' myManpage\n'

# Open tldr: 'Ctrl+h'
#bindkey -s '^h' ' myTldr\n'

# Open zoxide
bindkey -s '^z' ' zcd\n'

# Open micro editor
bindkey -s '^a' ' open-myFile\n'
