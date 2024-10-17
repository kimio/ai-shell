# AI-Shell

![Project Overview](assets/abs.png)

## Overview
This project is designed to simplify the use of AI without the need for installing dependencies. By leveraging shell scripts, users can manage authentication tokens and make API requests seamlessly. The provided scripts handle token validation, acquisition, and API interactions, ensuring a smooth and efficient workflow for AI-related tasks.

- **No Dependency Installation**: All functionalities are encapsulated within shell scripts, eliminating the need for additional software installations.
- **Automated Token Management**: Scripts automatically handle token validation and renewal, ensuring uninterrupted access to APIs.
- **Easy Configuration**: Simply set up the required configuration files, and you're ready to go.


The AI-Shell project consists of several scripts designed to manage authentication tokens and make API requests to a specified endpoint. The main components are:

1. `validTokenExpiration.sh`: A script to check if a token is valid based on its expiration date.
2. `getAuthToken.sh`: A script to obtain a new authentication token if no valid token is found.
3. `generateContent.sh`: A script to make API requests using the obtained authentication token.

## Scripts

### 1. `validTokenExpiration.sh`

This script contains functions to check if a token is valid based on its expiration date.

#### Functions

- **`valid_token_expiration`**: Checks if the token file is still valid by comparing the expiration date in the filename with the current date.
- **`get_valid_token`**: Checks if there is a valid token file and returns its content.

### 2. `getAuthToken.sh`

This script checks for an existing valid token and obtains a new authentication token if no valid token is found.

#### Functions

- **`get_valid_token`**: Checks if there is a valid token file and returns its content.
- **`get_credentials`**: Reads the credentials from a JSON file.
- **`get_access_token`**: Obtains a new access token using the credentials.

### 3. `generateContent.sh`

This script makes API requests using the obtained authentication token.

#### Functions

- **`show_help`**: Displays the help message with the description of each argument.
- **`make_request`**: Makes the API request using the provided parameters.

## About

### 1. `validTokenExpiration.sh`

This script is used internally by other scripts to check the validity of a token.

### 2. `getAuthToken.sh`

This script is used to obtain a new authentication token if no valid token is found.

### Configuration VertexAI

To configure the project, you need to set up the `config/google` directory with the following files:

1. **`credentials.json`**: This file should contain your Google Cloud credentials in JSON format. You can obtain this file from the Google Cloud Console by creating a service account and downloading the key.
    ```json
    {    
        "delegates": [],
        "service_account_impersonation_url": "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/service@company.iam.gserviceaccount.com:generateAccessToken",
        "source_credentials": {
            "account": "",
            "client_id": "client.apps.googleusercontent.com",
            "client_secret": "client_secret",
            "refresh_token": "refresh_token",
            "type": "authorized_user",
            "universe_domain": "googleapis.com"
        },
        "type": "impersonated_service_account"
    }
    ```

Make sure these files are correctly placed in the `config/google` directory before running any scripts.


## Example Usage

To make an API request, navigate to the `vertexai` directory and run the `generateContent.sh` script with the appropriate parameters:
* Make sure to replace the parameters with your specific project details. 

```sh
cd vertexai && sh generateContent.sh -p ai-project -l us-central1 -a us-central1-aiplatform.googleapis.com -m gemini-1.5-flash-002 -r ../prompt/request.json 
```


