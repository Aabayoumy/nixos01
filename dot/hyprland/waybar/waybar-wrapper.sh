#!/bin/sh
export LD_LIBRARY_PATH=/nix/store/ys7psw9r5964i4zs6cn7rmmkk6572wmd-pipewire-1.2.5-jack/lib:$LD_LIBRARY_PATH
exec waybar
