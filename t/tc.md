Traffic Control (tc)
====================

Inject latency
--------------

    tc qdisc add dev eth0 root netem delay 97ms

Remove the rule
---------------

    tc qdisc del dev eth0 root netem

List the rules
--------------

    tc -s qdisc
