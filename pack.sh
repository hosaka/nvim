#!/bin/bash

# get realpath to this bash script

PACK=$(realpath -s "$0")
PACK_PATH=$(dirname "$SCRIPT")

read -r -d '' USAGE << EOF
Usage: $0 [add|remove|update]

Commands:
add --name <name> --url <url> --branch <branch>
remove --name <name>
update\n
EOF

usage() {
  printf "$USAGE"
}

command=""

sm_name=""
sm_branch=""
sm_url=""
sm_path="pack/plugins/opt"

add () {
  read -p "Add $sm_name from $sm_url on branch $sm_branch to $sm_path/$sm_name? (y/N): " answer

  if [ "$answer" = "y" ]; then
    git submodule add --name "$sm_name" -b "$sm_branch" "$sm_url" "$sm_path/$sm_name"
  fi

  git add pack/
  exit $?
}

remove() {
  # unregister submodule
  git submodule deinit -f "$sm_path/$sm_name"

  # remove the submodule working tree
  git rm --cached "$sm_path/$sm_name"

  # remove submodule from .gitmodules
  git config -f .gitmodules --remove-section "submodule.$sm_name"

  # remoev submodule directory
  rm -r "$sm_path/$sm_name"

  # remove associated submodule directory in .git/modules
  git_dir=$(git rev-parse --git-dir)
  rm -rf "$git_dir/modules/$sm_path/$sm_name"

  git add pack/
  exit $?
}

update() {
  procs=$(nproc)
  git fetch --recurse-submodules --jobs=$procs

  # recursive call to update()
  git submodule --quiet foreach '$toplevel/pack.sh prompt'

  # add changed submodules
  git add pack/
  exit $?
}

prompt() {
  # echo $name
  # echo $sm_path
  # echo $sha1
  # echo $displaypath
  # echo $toplevel
  # abspath="$(git rev-parse --show-toplevel)"

  branch="$(git rev-parse --abbrev-ref --symbolic-full-name @{u})"
  num_changes="$(git rev-list --count HEAD..$branch)"
  current_sha1="$(git rev-parse --short HEAD)"
  upstream_sha1="$(git rev-parse --short $branch)"

  if [ $num_changes -ne 0 ]; then
    echo "Changes in $name (tracking branch: $branch):"

    git log --oneline --no-merges --date=relative --pretty='%C(auto)%h %C(auto)%s %C(dim)(%ad)' HEAD..$branch

    read -p "Do you want to update $name with $num_changes changes? (y/N): " answer

    if [ "$answer" = "y" ]; then
      git merge --quiet "$branch"
      echo "Updated $name to the latest version ($current_sha1 -> $upstream_sha1)"
    else
      echo "Skipped $name"
    fi
  else
    echo "No updates for $name ($current_sha1 == $upstream_sha1)"
  fi

  exit $?
}

options=$(getopt -o "" --long "name:,branch:,url:,path:" -n "$0" -- "$@")

if [ $? -ne 0 ]; then
  usage
fi

eval set -- "$options"

while [ "$1" != "" ]; do
  case "$1" in
    --name)
      shift
      sm_name="$1"
      ;;
    --branch)
      shift
      sm_branch="$1"
      ;;
    --url)
      shift
      sm_url="$1"
      ;;
    --path)
      shift
      sm_path="$1"
      ;;
    --)
      shift
      break
      ;;
    *)
      usage
      exit 1
      ;;
  esac
  shift
done

case "$1" in
  "add")
    if [ -z "$sm_name" ] || [ -z "$sm_url" ] || [ -z "$sm_branch" ]; then
      echo "Missing required arguments for 'add'"
      usage
      exit 1
    fi
    add
    ;;
  "remove")
    if [ -z "$sm_name" ]; then
      echo "Missing required arguments for 'remove'"
      usage
      exit 1
    fi
    remove
    ;;
  "update")
    update
    ;;
  "prompt")
    prompt
    ;;
  *)
    echo "Invalid command: $1" >&2
    usage
    exit 1
    ;;
esac


