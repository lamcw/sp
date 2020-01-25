#!/bin/sh

SP_SERVICE="org.mpris.MediaPlayer2.spotifyd"
SP_OBJECT="/org/mpris/MediaPlayer2"
SP_INTERFACE="org.mpris.MediaPlayer2.Player"

sp__play() {
  busctl call --user $SP_SERVICE $SP_OBJECT $SP_INTERFACE Play
}

sp__playpause() {
  busctl call --user $SP_SERVICE $SP_OBJECT $SP_INTERFACE PlayPause
}

sp__pause() {
  busctl call --user $SP_SERVICE $SP_OBJECT $SP_INTERFACE Pause
}

sp__next() {
  busctl call --user $SP_SERVICE $SP_OBJECT $SP_INTERFACE Next
}

sp__prev() {
  busctl call --user $SP_SERVICE $SP_OBJECT $SP_INTERFACE Previous
}

sp__metadata() {
  busctl \
  get-property \
  --user --json=short \
  $SP_SERVICE $SP_OBJECT $SP_INTERFACE \
  Metadata \
  | jq -r '.'
}

sp__search() {
  echo not implemented
}

sp__open() {
  echo not implemented
}

sp__help() {
  echo "Usage: sp [command]"
}

subcommand="$1"

if [ -z "$subcommand" ]; then
  sp__help
else
  # Arguments given, check if it's a command.
  if command -V sp__"$subcommand" > /dev/null; then
    shift
    eval "sp__$subcommand $*"
  else
    # It's not. Try a search.
    eval "sp__search $*"
  fi
fi

# vim: sw=2 sts=2 et
