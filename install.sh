#!/bin/bash

PACKAGE_NAME="if97"
LUA_VERSION="5.5"

sudo ln -s "$(pwd)/$PACKAGE_NAME" /usr/local/share/lua/$LUA_VERSION/$PACKAGE_NAME
