#!/bin/bash
# Run this inside the guest machine at startup to finish setup
# Provides the interface and routes for its internet connection
ip a
dhclient ens3
