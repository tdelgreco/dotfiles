# Path to the history file
HISTFILE=~/.zsh_history

# Maximum number of history entries to keep in memory
HISTSIZE=10000

# Maximum number of entries to save in the history file
SAVEHIST=5000

# History options
setopt appendhistory       # Append new commands to the history file
setopt incappendhistory    # Add commands to the history file immediately
setopt sharehistory        # Share history across multiple zsh sessions
setopt histignoredups      # Ignore duplicate entries
setopt histignorespace     # Don't save commands starting with a space
setopt histreduceblanks    # Remove unnecessary spaces in commands
setopt extendedhistory     # Save timestamps for each command