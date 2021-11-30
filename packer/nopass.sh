#!/bin/env bash

sudo useradd ansible -s /bin/bash -d /home/ansible -m
sudo usermod -aG wheel ansible

echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'packer ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
