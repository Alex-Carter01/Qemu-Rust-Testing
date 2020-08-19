#!/bin/bash
# Run this inside the guest machine at startup to finish setting up its internet connection
ip a
dhclient ens3
