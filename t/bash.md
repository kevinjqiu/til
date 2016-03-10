Shell
=====

## Invoke $EDITOR to write a long command

    ctrl-x e

## Execute a command without saving it to the history

    <space>command

## Place the argument of the most recent argument on the shell

    <ALT>. or <ESC>.

e.g.,

    cp blah /path/to/blah
    cd <ALT>.


## Nice column

    column -t 

e.g.,

    mount | column -t

## Mount a temporary RAM partition

    mount -t tmpfs tmpfs /mnt -o size=1024m

## SSH connection through host-in-the-middle

    ssh -t reachable_host ssh unreachable_host

## Change terminal cursor colour (gnome-terminal)

    echo -ne '\e]12;#ffcc00\a'

You can change the colour code here, or use symbolic colour name:

    echo -ne '\e]12;white\a'

