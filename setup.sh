#!/bin/env bash

function installCurl() {
    echo "--------------------------------------------"
    echo "Installing curl"
    sudo apt-get install -y curl
}

function installGit() {
    echo "--------------------------------------------"
    echo "Installing git"
    sudo apt-get install -y git
}

function setupGitCola() {
    echo "--------------------------------------------"
    echo "Installing git-cola"
    sudo apt-get install -y git-cola
}

function setupPython() {
    echo "--------------------------------------------"
    echo "Installing python-pip & ipython"
    sudo apt-get install -y python-pip ipython
}

function setupZsh() {
    echo "--------------------------------------------"
    echo "Setting up zsh & oh-my-zsh"
    sudo apt-get install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    chsh -s /bin/zsh
    echo
    echo
    echo "**NOTE**"
    echo "In gnome-terminal, the system will usually default to using Bash, because that's what gnome-terminal runs."
    echo "I overrode that "default" by changing the profile preferences. Open up gnome-terminal (the "Terminal" application), then go to 'Edit' and 'Profile Preferences'."
    echo "Make sure you're editing the 'default' profile, and go to the "Title and Command" tab."
    echo "Under "Command" there are three checkboxes: "Run command as a login shell", "Update login records when command is launched", and "Run a custom command instead of my shell"."
    echo "I checked all three boxes, and under "Custom command:" I put zsh."
    echo "I also set "When command exits:" to "Exit the terminal" so it closes the terminal window."
    echo "Hit the "Close" button, then exit gnome-terminal and then reopen it. It should now start zsh instead of Bash."
    echo "If that doesn't work, please reboot the Machine."
}

function setupOpenInTerminal() {
    sudo apt-get install -y nautilus-open-terminal
}

function setupSublime() {
    echo "--------------------------------------------"
    echo "Setting up sublime-text-2"
    sudo add-apt-repository ppa:webupd8team/sublime-text-2
    sudo apt-get update
    sudo apt-get install sublime-text
}

function setupSwap() {
    echo "--------------------------------------------"
    echo "Setting up swap"
    sudo swapoff -a
    sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
}

function runSetup() {
    err="Invalid process requested. Exiting."
    if [[ $1 == "" ]]; then
        echo $err
        exit
    fi
    START=$(date +%s)
    if [ $1 == "fresh" ]; then
        sudo dpkg --configure -a
        setupSwap
        installCurl
        installGit
        setupPython
        setupOpenInTerminal
        setupSublime
        setupZsh
    elif [ $1 == "curl" ]; then
        installCurl
    elif [ $1 == "git" ]; then
        installGit
    elif [ $1 == "git-cola" ]; then
        setupGitCola
    elif [ $1 == "sublime" ]; then
        setupSublime
    elif [ $1 == "zsh" ]; then
        setupZsh
    elif [ $1 == "swap" ]; then
        setupSwap
    elif [ $1 == "system" ]; then
        setupSystemPackages
    elif [ $1 == "python" ]; then
        setupPython
    else
        echo $err
        exit
    fi
    echo "--------------------------------------------"
    END=$(date +%s)
    echo "Total time: $((($END-$START) / 60)) minutes"
}

runSetup $1
