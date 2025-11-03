#!/bin/bash

# Function to check if a user exists
user_exists() {
    local user=$1
    grep -i -w "^$user:" /etc/passwd > /dev/null
}

# Function to generate a random special character
generate_special_char() {
    echo ' !@#$%^&*()_' | fold -w1 | shuf | head -1
}

# Function to create a user
create_user() {
    local user=$1
    local password=$2

    # Check if user already exists
    if user_exists "$user"; then
        echo "Error: User '$user' already exists. Please choose a different username."
        return 1
    fi

    # Create the user
    sudo useradd -m "$user" --shell /bin/bash

    # Set a temporary password
    local spec=$(generate_special_char)
    local temp_password="IndianArmy@${RANDOM}${spec}"
    echo "$user:$temp_password" | sudo chpasswd

    # Mark password as expired
    sudo passwd -e "$user"

    echo "User '$user' created successfully."
    echo "Temporary password: $temp_password"
    echo "Please change the password on the first login."
}

# Main script logic
if [ $# -gt 0 ]; then
    # Validate usernames using regex (only alphabetic characters)
    for user in "$@"; do
        if [[ $user =~ ^[a-zA-Z]+$ ]]; then
            create_user "$user"
        else
            echo "Error: Username '$user' is invalid. Only alphabetic characters are allowed."
        fi
    done
else
    echo "Usage: $0 <username1> [username2] [username3] ..."
    echo "Example: $0 user1 user2 user3"
fi