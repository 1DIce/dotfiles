#!/usr/bin/env bash

WIN_PROGRAMS="C:\\Program Files\\Eclipse Adoptium"

list() {
  find "/c/Program Files/Eclipse Adoptium" -mindepth 1 -maxdepth 1 -type d -name "jdk*"
}

select_jdk() {
  list | fzf
}

exec_in_cmd() {
    cmd.exe /c "$1"
}

set_jhome() {
  local jdk_base
  jdk_base=$(basename "$(select_jdk)")
  local jdk="$WIN_PROGRAMS\\$jdk_base"
  echo "Settings Java Home to \"$jdk\""
  setx -m JAVA_HOME "$jdk"
}

set_dev_vars() {
    exec_in_cmd "setx \"merlin_global_network_client_model_url_external\" http://localhost:4300"
    exec_in_cmd "setx \"merlin_model_use_development_features\" true"
    exec_in_cmd "setx \"MERLIN_EXPERIMENTAL_ENABLE_REMOTE_WORKSPACES\" true"
}

clear_dev_vars() {
    exec_in_cmd "reg delete \"HKCU\Environment\" /f /v \"merlin_global_network_client_model_url_external\""
    exec_in_cmd "reg delete \"HKCU\Environment\" /f /v \"merlin_model_use_development_features\""
    exec_in_cmd "reg delete \"HKCU\Environment\" /f /v \"MERLIN_EXPERIMENTAL_ENABLE_REMOTE_WORKSPACES\""
}

main() {
  local actions=(
    "list installed jdks"
    "set java home to jdk"
    "setup development environment variables"
    "clear development environment variables"
  )
  local action
  action=$(printf "%s\n" "${actions[@]}" | fzf)
  case $action in
    "list installed jdks")
      list
    ;;
    "set java home to jdk")
      set_jhome
    ;;
    "setup development environment variables")
      set_dev_vars
    ;;
    "clear development environment variables")
      clear_dev_vars
    ;;
  esac

}

main

