nmap
====

## SYN scan (half-open scan)

    sudo nmap -sS -v localhost  # -sS means SYN

## specific ports

    sudo nmap -sS -p 80,443 localhost
    sudo nmap -sS -p- localhost

## operating system

    sudo nmap -nS -O localhost

## scan network

    sudo nmap -sS -O 192.168.1.0/24

## UDP scan

    sudo nmap -sU ...
