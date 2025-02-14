#!/bin/bash
#title: CHOMTE.SH - hostdiscovery.sh V1.3
#description:   Automated and Modular Shell Script to Automate Security Vulnerability Reconnaisance Scans
#author:        mr-rizwan-syed
#This script will do host discovery of CIDR / ASN 
#==============================================================================

# Function to check if the argument is a valid CIDR notation
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
NC=`tput sgr0`

casn=$1

is_cidr() {
    local cidr_pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$"
    if [[ $1 =~ $cidr_pattern ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if the argument is a valid ASN (Autonomous System Number)
is_asn() {
    local asn_pattern="^AS[0-9]+$"
    if [[ $1 =~ $asn_pattern ]]; then
        return 0
    else
        return 1
    fi
}

is_private_ip() {
  local ip="$1"
  local -a private_ranges=("10." "192.168." "172.16." "172.17." "172.18." "172.19." "172.20." "172.21." "172.22." "172.23." "172.24." "172.25." "172.26." "172.27." "172.28." "172.29." "172.30." "172.31.")

  for range in "${private_ranges[@]}"; do
    if [[ "$ip" == $range* ]]; then
      is_private=1
      return
    fi
  done
}

hostdiscovery(){
    trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC} "' SIGINT
    echo -e ''
    echo -e "${bluebg}1. Nmap Ping Scan Only on $1${NC}"
    nmap -sn $1 -oG $results/hostdiscovery1.gnmap 2>&1 &>/dev/null
    [ -e "$results/hostdiscovery1.gnmap" ] && cat $results/hostdiscovery1.gnmap | grep Host | cut -d ' ' -f 2 | anew -q $results/aliveip.txt
    
    echo -e "${bluebg}2. Nmap TCP SYN ping scan on $1${NC}"
    nmap -sn -PS -n $1 -oG $results/hostdiscovery2.gnmap 2>&1 &>/dev/null
    [ -e "$results/hostdiscovery2.gnmap" ] && cat $results/hostdiscovery2.gnmap | grep Host | cut -d ' ' -f 2 | anew -q $results/aliveip.txt
    
    echo -e "${bluebg}3. Nmap TCP ACK ping scan on $1${NC}"
    nmap -sn -PA -n $1 -oG $results/hostdiscovery3.gnmap 2>&1 &>/dev/null
    [ -e "$results/hostdiscovery3.gnmap" ] && cat $results/hostdiscovery3.gnmap | grep Host | cut -d ' ' -f 2 | anew -q $results/aliveip.txt
        
    is_private_ip $1
    [[ $is_private -eq 1 ]] && echo -e "${bluebg}4. Nmap ARP Ping Scan on $1${NC}"
    [[ $is_private -eq 1 ]] && nmap -sn -PR -n $1 -oG $results/hostdiscovery4.gnmap 2>&1 &>/dev/null
    [ -e "$results/hostdiscovery4.gnmap" ] && cat $results/hostdiscovery4.gnmap | grep Host | cut -d ' ' -f 2 | anew -q $results/aliveip.txt
    
    [[ $is_private -eq 1 ]] && echo -e "${bluebg}5. Nmap ICMP Echo Request Scan on $1${NC}"
    [[ $is_private -eq 1 ]] && nmap -sn -PE -n $1 -oG $results/hostdiscovery5.gnmap 2>&1 &>/dev/null
    [ -e "$results/hostdiscovery5.gnmap" ] && cat $results/hostdiscovery5.gnmap | grep Host | cut -d ' ' -f 2 | anew -q $results/aliveip.txt
    
    [[ $is_private -eq 1 ]] && echo -e "${bluebg}6. Nmap UDP Ping Scan on $1${NC}"
    [[ $is_private -eq 1 ]] && nmap -sn -PU -n $1 -oG $results/hostdiscovery6.gnmap 2>&1 &>/dev/null
    [ -e "$results/hostdiscovery6.gnmap" ] && cat $results/hostdiscovery6.gnmap | grep Host | cut -d ' ' -f 2 | anew -q $results/aliveip.txt
    
    rm $results/hostdiscovery*.gnmap
}

nmapdiscovery(){
    # Main script
    if [ $# -ne 1 ]; then
        echo "hostdiscovery.sh: $0 <argument>"
        exit 1
    fi
    # Check if it's a valid CIDR
    if is_cidr "$casn"; then
        echo "CIDR notation: $casn"
        hostdiscovery $casn
    fi
    # Check if it's a valid ASN
    if is_asn "$casn"; then
        echo -e "ASN: $casn \n"
        echo -e "${BLUE}[#] asnmap -a $casn -silent | anew -q $results/asnip.txt ${NC}"
        asnmap -a $casn -silent | anew -q $results/asnip.txt
        echo -e "${BLUE}[#] whois -h whois.radb.net -- \"-i origin $casn\" | grep route: | cut -d ':' -f 2 | tr -d ' ' | grep -Eo '([0-9.]+){4}/[0-9]+' | anew -q $results/asnip.txt${NC}"
        whois -h whois.radb.net -- "-i origin $casn" | grep route: | cut -d ':' -f 2 | tr -d ' ' | grep -Eo "([0-9.]+){4}/[0-9]+"| anew -q $results/asnip.txt
        [ -e "$results/asnip.txt" ] && ${MAGENTA}cat $results/asnip.txt ${NC}
        [ -e "$results/asnip.txt" ] && cat $results/asnip.txt | while IFS= read -r cidr; do hostdiscovery $cidr; done
    fi
}   
