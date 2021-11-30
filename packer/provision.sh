#!/bin/env bash

printf "User |> $USER \n"

printf "dnf |> install EPEL \n"

sudo dnf install -y  oracle-epel-release-el8

sudo dnf install -y ansible

sudo useradd ansible -s /bin/bash -d /home/ansible -m
sudo usermod -aG wheel ansible

ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix

printf "Ansible |> installed \n"
