__GIT_PROMPT_DIR=~/.bash

# Colors
# Reset
ResetColor="\[\033[0m\]"      # Text Reset

# Regular Colors
Red="\[\033[0;31m\]"
Green="\[\033[0;32m\]"
Gold="\[\033[0;33m\]"
BlueGray="\[\033[0;34m\]"
Magenta="\[\033[0;35m\]"
BlueGreen="\[\033[0;36m\]"
White="\[\033[0;37m\]"

# Vibrant colors
Orange="\[\033[1;31m\]"
Lime="\[\033[1;32m\]"
Yellow="\[\033[1;33m\]"
Blue="\[\033[1;34m\]"
Pink="\[\033[1;35m\]"
Cyan="\[\033[1;36m\]"
BrightWhite="\[\033[1;37m\]"


# Various variables you might want for your PS1 prompt instead
Time12a="\T "
PathShort="\w"

# Default values for the appearance of the prompt. Configure at will.
GIT_PROMPT_PREFIX="${White}["
GIT_PROMPT_SUFFIX="${White}]$ResetColor"
GIT_PROMPT_SEPARATOR="|"
GIT_PROMPT_BRANCH="${BlueGray}"
GIT_PROMPT_STAGED="${Orange}● "
GIT_PROMPT_CONFLICTS="${Red}✖ "
GIT_PROMPT_CHANGED="${Red}✚ "
GIT_PROMPT_REMOTE=" "
GIT_PROMPT_UNTRACKED="${Red},"
GIT_PROMPT_CLEAN="${Green}✔ "

PROMPT_START="\n$Time12a$ResetColor$Gold$PathShort$ResetColor"
PROMPT_END="\n$ResetColor$ "


function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS
    local gitstatus="${__GIT_PROMPT_DIR}/gitstatus.py"
    
    _GIT_STATUS=$(python $gitstatus)
    __CURRENT_GIT_STATUS=($_GIT_STATUS)
	GIT_BRANCH=${__CURRENT_GIT_STATUS[0]}
	GIT_REMOTE=${__CURRENT_GIT_STATUS[1]}
    if [[ "." == "$GIT_REMOTE" ]]; then
		unset GIT_REMOTE
	fi
	GIT_STAGED=${__CURRENT_GIT_STATUS[2]}
	GIT_CONFLICTS=${__CURRENT_GIT_STATUS[3]}
	GIT_CHANGED=${__CURRENT_GIT_STATUS[4]}
	GIT_UNTRACKED=${__CURRENT_GIT_STATUS[5]}
	GIT_CLEAN=${__CURRENT_GIT_STATUS[6]}
}

function setGitPrompt() {
	update_current_git_vars

	if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS=" $GIT_PROMPT_PREFIX$GIT_PROMPT_BRANCH$GIT_BRANCH$ResetColor"

	  if [ -n "$GIT_REMOTE" ]; then
		  STATUS="$STATUS$GIT_PROMPT_REMOTE$GIT_REMOTE$ResetColor"
	  fi

	  STATUS="$STATUS$GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_STAGED$GIT_STAGED$ResetColor"
	  fi

	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CONFLICTS$GIT_CONFLICTS$ResetColor"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CHANGED$GIT_CHANGED$ResetColor"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_UNTRACKED$GIT_UNTRACKED$ResetColor"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CLEAN"
	  fi
	  STATUS="$STATUS$ResetColor$GIT_PROMPT_SUFFIX"

	  PS1="$PROMPT_START$STATUS$PROMPT_END"
	else
	  PS1="$PROMPT_START$PROMPT_END"
	fi
}

PROMPT_COMMAND=setGitPrompt
