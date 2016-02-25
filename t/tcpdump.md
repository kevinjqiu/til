tcpdump
=======

filter based on host:

    tcpdump host <hostname/ip>

filter by interface:

    tcpdump -i eth0 ...

more information:

    tcpdump -v / -vv / -vvv

save to a file:

    tcpdump -s0 -w filename.pcap
    # -s0 cap as much data as possible

## options

* `-i any|eth0` - specify the interface
* `-D` - show list of interfaces
* `-n`, `-nn` - don't resolve hostname/port names
* `-X` show packet's contents in hex and ascii
* `-v`, `-vv`, `-vvv`
* `-A` - show ascii if possible

## filters

* `host`, `src`, `dst`, `net` (using cidr notation)
* `proto` (can be omitted, e.g., `tcpdump icmp`)
* `port`, `src port`, `dst port`

## writing to a file

`tcpdump port 80 -w capture_file`

+network +linux
