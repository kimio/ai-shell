#!/bin/bash

check_valid_token() {
  local token_file="$1"
  local extracted_datetime=$(echo "$token_file" | sed -E 's/[^0-9]//g')
  local current_time=$(date +"%Y%m%d%H%M%S")
  if [ "$extracted_datetime" -gt "$current_time" ]; then
    return 0
  fi
  return 1
}

get_valid_token() {
  for token_file in ../config/google/access_token_*.txt; do
    if [ -f "$token_file" ]; then
      if check_valid_token "$token_file"; then
        cat "$token_file"
        return 1
      else
        rm -rf "$token_file"
      fi
    fi
  done
  return 0
}
