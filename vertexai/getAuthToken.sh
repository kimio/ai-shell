#!/bin/bash

source validTokenExpiration.sh

get_credentials() {
  CREDENTIALS_FILE="../config/google/credentials.json"

  if [ ! -f "$CREDENTIALS_FILE" ]; then
    echo "$CREDENTIALS_FILE not found"
    exit 1
  fi
  CREDENTIALS=$(cat "$CREDENTIALS_FILE" | tr -d ' ')
  CLIENT_ID=$(echo "$CREDENTIALS"| grep -o '"client_id":"[^"]*"'|sed 's/"client_id":"\([^"]*\)"/\1/'| tr -d ' ')
  CLIENT_SECRET=$(echo "$CREDENTIALS"| grep -o '"client_secret":"[^"]*"'|sed 's/"client_secret":"\([^"]*\)"/\1/'| tr -d ' ')
  REFRESH_TOKEN=$(echo "$CREDENTIALS"| grep -o '"refresh_token":"[^"]*"'|sed 's/"refresh_token":"\([^"]*\)"/\1/'| tr -d ' ')

  if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ] || [ -z "$REFRESH_TOKEN" ]; then
    echo "Error to get data on $CREDENTIALS_FILE!"
    exit 1
  fi

  ACCESS_DATA=$(curl -s \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "refresh_token=$REFRESH_TOKEN" \
    -d "grant_type=refresh_token" \
    https://oauth2.googleapis.com/token)

  VERTEX_AI_ACCESS_TOKEN=$(echo $ACCESS_DATA | grep -o '"access_token": "[^"]*"' | sed 's/"access_token": "\([^"]*\)"/\1/')
  expires_in=$(echo $ACCESS_DATA | grep -o '"expires_in": [0-9]*' | sed 's/"expires_in": \([0-9]*\)/\1/')
  if [[ "$OSTYPE" == "darwin"* ]]; then
    expiration_time=$(date -v+${expires_in}S +"%Y-%m-%d %H:%M:%S")
  else
    expiration_time=$(date -u -d "@$(($(date +%s) + expires_in))" +"%Y-%m-%d %H:%M:%S")
  fi

  if [ -z "$VERTEX_AI_ACCESS_TOKEN" ]; then
    echo "Error obtaining the access token!"
    exit 1
  fi

  echo "$VERTEX_AI_ACCESS_TOKEN" > $( echo ../config/google/access_token_$expiration_time".txt")
  echo "$VERTEX_AI_ACCESS_TOKEN"
}

get_token() {
  token=$(get_valid_token)
  if [ -n "$token" ]; then
    echo "$token"
  else
    get_credentials
  fi
}
