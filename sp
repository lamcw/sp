#!/bin/sh

SP_SERVICE="org.mpris.MediaPlayer2.spotifyd"
SP_OBJECT="/org/mpris/MediaPlayer2"
SP_INTERFACE="org.mpris.MediaPlayer2.Player"


sp__dbus_call() {
  busctl call --user "${SP_SERVICE}" "${SP_OBJECT}" "${SP_INTERFACE}" "$@"
}

alias sp__play="sp__dbus_call Play"
alias sp__pause="sp__dbus_call Pause"
alias sp__playpause="sp__dbus_call PlayPause"
alias sp__next="sp__dbus_call Next"
alias sp__prev="sp__dbus_call Previous"

sp__metadata() {
  busctl \
  get-property \
  --user --json=short \
  "${SP_SERVICE}" "${SP_OBJECT}" "${SP_INTERFACE}" \
  Metadata
}

sp__search() {
  echo not implemented
}

sp__open() {
  sp__dbus_call OpenUri s "$1"
}

sp__help() {
  echo "usage: $0 [command]"
  echo
  echo "commands"
  echo "  sp play          play track"
  echo "  sp pause         pause track"
  echo "  sp playpause     toggle between play/pause"
  echo "  sp open <url>    open track URL"
  echo
  echo "  sp metadata      show metadata of currently playing track"
  echo
  echo "  sp help          show this help"
}

subcommand="$1"

if [ -z "${subcommand}" ]; then
  sp__help
else
  # arguments given, check if it's a command.
  if command -V sp__"${subcommand}" > /dev/null; then
    shift
    eval sp__"${subcommand}" "$@"
  else
    # it's not. Try a search.
    eval sp__search "$@"
  fi
fi

# vim: sw=2 sts=2 et
