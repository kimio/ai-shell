#!/bin/bash

source getAuthToken.sh

show_help() {
    echo "Uso: $0 -p <project_id> -l <location_id> -a <api_endpoint> -m <model_id> -r <request_file>"
    echo
    echo "Parâmetros:"
    echo "  -p <project_id>     Project ID"
    echo "  -l <location_id>    Location ID"
    echo "  -a <api_endpoint>   API Endpoint"
    echo "  -m <model_id>       Model ID"
    echo "  -r <request_file>   Path to the JSON request file"
    echo
}

make_request() {
    local access_token=$(get_token)
    local project_id="$2"
    local location_id="$3"
    local api_endpoint="$4"
    local model_id="$5"
    local request_file="$6"

    curl \
        -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $access_token" \
        "https://${api_endpoint}/v1/projects/${project_id}/locations/${location_id}/publishers/google/models/${model_id}:generateContent" -d "@${request_file}"
}

while getopts "p:l:a:m:r:h" opt; do
    case ${opt} in
    p) project_id=$OPTARG ;;
    l) location_id=$OPTARG ;;
    a) api_endpoint=$OPTARG ;;
    m) model_id=$OPTARG ;;
    r) request_file=$OPTARG ;;
    h)
        show_help
        exit 0
        ;;
    \?)
        show_help
        exit 1
        ;;
    esac
done

if [ -z "$project_id" ] || [ -z "$location_id" ] || [ -z "$api_endpoint" ] || [ -z "$model_id" ] || [ -z "$request_file" ]; then
    echo "Error: Please provide all required parameters.."
    show_help
    exit 1
fi

make_request "$access_token" "$project_id" "$location_id" "$api_endpoint" "$model_id" "$request_file"
