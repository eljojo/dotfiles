# https://wiki.archlinux.org/index.php/SSH_keys#SSH_agents

if [[ "$SSH_AUTH_SOCK" == "" ]]; then
  if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-daemon
  fi
  if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-daemon)" > /dev/null
  fi
fi
