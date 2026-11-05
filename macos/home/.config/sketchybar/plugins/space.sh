#!/bin/sh

non_empty_workspaces="$(aerospace list-workspaces --monitor all --empty no --format '%{workspace}' 2>/dev/null)"
all_workspaces="$(aerospace list-workspaces --all --format '%{workspace}' 2>/dev/null)"

if [ "$SENDER" = "aerospace_workspace_change" ] && [ -n "$FOCUSED_WORKSPACE" ]; then
  focused_workspace="$FOCUSED_WORKSPACE"
else
  focused_workspace="$(aerospace list-workspaces --focused --format '%{workspace}' 2>/dev/null)"
fi

[ -n "$all_workspaces" ] || exit 0

display_workspaces="$non_empty_workspaces"

if [ -n "$focused_workspace" ] && ! printf '%s\n' "$display_workspaces" | grep -Fxq "$focused_workspace"; then
  if [ -n "$display_workspaces" ]; then
    display_workspaces="$display_workspaces
$focused_workspace"
  else
    display_workspaces="$focused_workspace"
  fi
fi

printf '%s\n' "$all_workspaces" | while IFS= read -r workspace
do
  [ -n "$workspace" ] || continue

  drawing=off
  background_drawing=off

  if printf '%s\n' "$display_workspaces" | grep -Fxq "$workspace"; then
    drawing=on
  fi

  if [ "$workspace" = "$focused_workspace" ]; then
    background_drawing=on
  fi

  sketchybar --set "space.$workspace" \
             drawing="$drawing" \
             background.drawing="$background_drawing"
done
