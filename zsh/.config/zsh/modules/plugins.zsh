#!/usr/bin/env zsh

# ─── Plugin manager ────────────────────────────────────────────────
# zsh-plugin-load is adapted from zsh_unplugged by mattmc3
#   https://github.com/mattmc3/zsh_unplugged (Unlicense, public domain)
# Changes: clone_args and commitsha are reset per plugin, zsh-defer support removed.
# zsh-plugin-update and zsh-plugin-outdated are new, they use the spinner from spinner.zsh.
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# Clone a plugin from github (optionally pinned with owner/repo@sha), link its init file,
# add it to fpath and source it. Usage: zsh-plugin-load zsh-users/zsh-completions
function zsh-plugin-load {
  local plugin repo commitsha plugdir initfile initfiles clone_args
  for plugin in $@; do
    repo=$plugin commitsha=
    clone_args=(-q --depth 1 --recursive --shallow-submodules)
    if [[ $plugin == *@* ]]; then
      repo=${plugin%@*}
      commitsha=${plugin#*@}
      clone_args+=(--no-checkout)
    fi
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh

    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone $clone_args https://github.com/$repo $plugdir
      if [[ -n $commitsha ]]; then
        git -C $plugdir fetch -q origin $commitsha
        git -C $plugdir checkout -q $commitsha
      fi
    fi

    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file found '$repo'."; continue }
      ln -sf $initfiles[1] $initfile
    fi

    fpath+=$plugdir
    . $initfile
  done
}

# ─── Commands ──────────────────────────────────────────────────────
# Pull every cloned plugin. Pinned plugins (detached HEAD) are skipped.
# Restart the shell afterwards to load the new versions
function zsh-plugin-update {
  local plugdir
  zsh-spinner-start "Updating plugins..."
  {
    for plugdir in $ZPLUGINDIR/*(/N); do
      [[ -d $plugdir/.git ]] || continue
      if ! git -C $plugdir symbolic-ref -q HEAD >/dev/null; then
        echo "Skipping ${plugdir:t} (pinned)"
        continue
      fi
      # fileMode=false: the clones show permission-only changes, which would block a pull
      git -C $plugdir -c core.fileMode=false pull -q --ff-only --no-rebase --recurse-submodules
    done
  } always {
    zsh-spinner-stop
  }
  echo "Plugins updated. Restart zsh to load them"
}

# List every plugin with its current commit (hash and date) and whether its remote branch is ahead.
# Changes nothing. Pinned plugins (detached HEAD) are not checked. Run zsh-plugin-update to apply
function zsh-plugin-outdated {
  local plugdir branch remote local_sha info state
  local -i tty=0
  local -a rows
  [[ -t 1 ]] && tty=1
  zsh-spinner-start "Checking plugins..."
  {
    for plugdir in $ZPLUGINDIR/*(/N); do
      [[ -d $plugdir/.git ]] || continue
      info=$(git -C $plugdir log -1 --format=$'%h\t%cs' HEAD)
      if branch=$(git -C $plugdir symbolic-ref -q --short HEAD); then
        remote=$(git -C $plugdir ls-remote -q origin refs/heads/$branch 2>/dev/null)
        remote=${remote%%$'\t'*}
        local_sha=$(git -C $plugdir rev-parse HEAD)
        if [[ -z $remote ]]; then state="unknown"
        elif [[ $remote == $local_sha ]]; then state="up to date"
        else state="outdated  ->  ${remote[1,7]}"
        fi
      else
        state="pinned"
      fi
      rows+=("${plugdir:t}"$'\t'"$info"$'\t'"$state")
    done
  } always {
    zsh-spinner-stop
  }
  # Align the columns with column(1), then colour the status when printing to a terminal
  print -rl -- $'PLUGIN\tCOMMIT\tDATE\tSTATUS' $rows | column -t -s $'\t' | awk -v tty=$tty '
    NR == 1 && tty { print "\033[1m" $0 "\033[0m"; next }
    tty { sub(/up to date/, "\033[32m&\033[0m"); sub(/outdated/, "\033[33m&\033[0m"); sub(/pinned|unknown/, "\033[2m&\033[0m") }
    { print }'
}
