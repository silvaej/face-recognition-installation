#!/bin/bash

# Define the virtual environment directory
VENV_DIR=".venv"

# Function to activate the virtual environment
activate_virtualenv() {
    if [ -d "$VENV_DIR" ]; then
        echo "Activating virtual environment..."
        source "$VENV_DIR/Scripts/activate"
    else
        echo "Error: Virtual environment not found!"
        exit 1
    fi
}

# Create a virtual environment
echo "Checking for virtual environment..."
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python -m venv "$VENV_DIR"
else
    echo "Virtual environment already exists."
fi

# Activate the virtual environment
activate_virtualenv

# Update pip inside the virtual environment
echo "Updating pip..."
pip install --upgrade pip

# Install prerequisites
echo "Installing prerequisites..."
pip install cmake

# Install Visual Studio Build Tools
echo "Checking for Visual Studio Build Tools..."

# Define the URL for the Visual Studio Build Tools installer
VS_BUILD_TOOLS_URL="https://aka.ms/vs/17/release/vs_buildtools.exe"

# Download the installer if it doesn't exist
if [ ! -f "vs_buildtools.exe" ]; then
    echo "Downloading Visual Studio Build Tools..."
    curl -LO "$VS_BUILD_TOOLS_URL"
else
    echo "Visual Studio Build Tools installer already downloaded."
fi

# Install Visual Studio Build Tools silently
echo "Installing Visual Studio Build Tools (this may take several minutes)..."
./vs_buildtools.exe --quiet --wait --norestart --nocache \
    --add Microsoft.VisualStudio.Workload.VCTools \
    --add Microsoft.VisualStudio.Component.Windows10SDK.19041

# Check if installation succeeded
if [ $? -ne 0 ]; then
    echo "Error: Visual Studio Build Tools installation failed."
    deactivate  # Deactivate the virtual environment
    exit 1
else
    echo "Visual Studio Build Tools installed successfully."
fi

# Install dlib inside the virtual environment
echo "Installing dlib (this may take some time)..."
pip install dlib

# Install face_recognition inside the virtual environment
echo "Installing face_recognition..."
pip install face_recognition

# Verify installation
echo "Verifying installation..."
python -c "import face_recognition; print('face_recognition version:', face_recognition.__version__)"

if [ $? -eq 0 ]; then
    echo "face_recognition successfully installed!"
else
    echo "Error: face_recognition installation failed. Check the logs above for details."
fi

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate
