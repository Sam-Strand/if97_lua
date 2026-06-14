#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PACKAGE_NAME="$(basename "$SCRIPT_DIR" | sed 's/-lua$//')"

LUA_VERSION=$(lua -e 'print(_VERSION:match("%d+%.%d+"))')

if [ -z "$LUA_VERSION" ]; then
    echo "Ошибка: не удалось определить версию Lua"
    exit 1
fi

echo "Обнаружена версия Lua: $LUA_VERSION"
echo "Имя пакета: $PACKAGE_NAME"

MODULE_PATH="$SCRIPT_DIR/$PACKAGE_NAME"

if [ ! -d "$MODULE_PATH" ]; then
    echo "Ошибка: папка $PACKAGE_NAME не найдена в $SCRIPT_DIR"
    echo "Убедитесь, что папка $PACKAGE_NAME существует рядом со скриптом"
    exit 1
fi

sudo ln -sfn "$MODULE_PATH" "/usr/local/share/lua/$LUA_VERSION/$PACKAGE_NAME"

echo "Ссылка создана: /usr/local/share/lua/$LUA_VERSION/$PACKAGE_NAME -> $MODULE_PATH"