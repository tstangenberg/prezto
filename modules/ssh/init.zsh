#
# Provides for an easier use of SSH by setting up ssh-agent.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Return if requirements are not found.
if (( ! $+commands[ssh-agent] )) || [[ "$OSTYPE" == darwin* ]]; then
  return 1
fi

# Set the default path to the environment file.
_ssh_agent_env="$HOME/.ssh/environment-$HOST"

# Start ssh-agent if not started.
if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent | sed '/^echo /d' | tee "$_ssh_agent_env")"
else
  # Export environment variables.
  source "$_ssh_agent_env"
fi

# Load identities.
if ssh-add -l 2>&1 | grep 'The agent has no identities.'; then
  zstyle -a ':prezto:module:ssh:agent' identities '_ssh_agent_identities'
  if (( ${#identities} > 0 )); then
    ssh-add "$HOME/.ssh/${^_ssh_agent_identities[@]}"
  else
    ssh-add
  fi
fi

# Create a persistent SSH authentication socket location.
_ssh_agent_persistent_auth_sock="/tmp/ssh-agent-$USER-screen"
if [[ -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$_ssh_agent_persistent_auth_sock" ]]; then
  ln -sf "$SSH_AUTH_SOCK" "$_ssh_agent_persistent_auth_sock"
  export SSH_AUTH_SOCK="$_ssh_agent_persistent_auth_sock"
fi

# Clean up.
unset _ssh_agent_{env,identities,persistent_auth_sock}

