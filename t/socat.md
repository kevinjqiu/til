Monitor unix domain socket
==========================

    sudo mv /path/to/sock /path/to/sock.original
    sudo socat -t100 -x -v UNIX-LISTEN:/path/to/sock,mode=777,reuseaddr,fork UNIX-CONNECT:/path/to/sock.original
