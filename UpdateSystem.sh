#!/bin/bash
sudo -s  apt-get update
sudo -s  apt-get upgrade -y
sudo -s apt-get dist-upgrade -y
sudo -s apt-get autoremove -y
sudo -s apt-get autoclean -y
