#!/bin/bash

# Update package list
sudo apt-get update -qq

# Check if Docker is already installed
if command -v docker &> /dev/null
then
    echo "Docker is already installed. Skipping Docker installation."
else
    # Add Docker repository for Debian 'bullseye'
    echo "Adding Docker repository..."
    printf "%s\n" "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list

    # Add Docker's GPG key
    echo "Adding Docker GPG key..."
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

    # Update package list again to include Docker packages
    echo "Updating package list..."
    sudo apt-get update -qq

    # Install Docker
    echo "Installing Docker..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Verify Docker installation
    echo "Verifying Docker installation..."
    sudo systemctl enable docker
    sudo systemctl start docker

    echo "Docker installation complete. Verifying version..."
    docker --version
fi
