#!/bin/bash

# Update package list
echo "Updating package list..."
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
    echo "Updating package list again..."
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

# Check if Docker Compose is already installed
dockerComposeVersion=2.20.3

if command -v docker-compose &> /dev/null
then
    echo "Docker Compose is already installed. Skipping Docker Compose installation."
else
    echo "Installing Docker Compose version $dockerComposeVersion..."
    
    # Download Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v$dockerComposeVersion/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Move and make it executable
    sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose

    echo "Docker Compose installation complete. Version: $(docker-compose --version)"
fi

# Add /usr/bin to PATH if not already included
if [[ ":$PATH:" != *":/usr/bin:"* ]]; then
    echo "Adding /usr/bin to PATH..."
    echo 'export PATH=$PATH:/usr/bin' >> ~/.bashrc
    source ~/.bashrc
fi

# Final confirmation message
echo "All installations completed successfully!"
