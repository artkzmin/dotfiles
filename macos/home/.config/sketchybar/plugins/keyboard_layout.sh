#!/bin/sh

SOURCE_ID="$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null)"
SOURCE_NAME=""
ICON=""
LABEL=""

if [ -z "$SOURCE_ID" ]; then
  SOURCE_NAME="$(
    defaults read com.apple.HIToolbox AppleSelectedInputSources 2>/dev/null \
      | awk -F'= ' '/KeyboardLayout Name/ {gsub(/^[[:space:]]+/, "", $2); gsub(/;$/, "", $2); gsub(/"/, "", $2); print $2; exit}'
  )"
fi

case "$SOURCE_ID" in
  com.apple.keylayout.ABC)
    ICON="🇺🇸"
    LABEL="EN"
    ;;
  com.apple.keylayout.Russian)
    ICON="🇷🇺"
    LABEL="RU"
    ;;
esac

if [ -z "$LABEL" ]; then
  case "$SOURCE_NAME" in
    ABC)
      ICON="🇺🇸"
      LABEL="EN"
      ;;
    Russian)
      ICON="🇷🇺"
      LABEL="RU"
      ;;
  esac
fi

if [ -z "$LABEL" ]; then
  exit 0
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
