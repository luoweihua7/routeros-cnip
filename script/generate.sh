#!/bin/bash

# 参数
LIST_NAME="CN"

# 年.月
DATE_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# ipv4
echo "# Update at ${DATE_TIME}
/ip firewall address-list remove [/ip firewall address-list find list=${LIST_NAME}]
/ip firewall address-list" > ipv4.rsc
curl -kLfsm 5 https://ispip.clang.cn/all_cn_cidr.txt | sed -e 's/^/add address=/' -e 's/$/ list\='${LIST_NAME}'/' >> ipv4.rsc

# ipv6
echo "# Update at ${DATE_TIME}
/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=${LIST_NAME}]
/ipv6 firewall address-list" > ipv6.rsc
curl -kLfsm 5 https://ispip.clang.cn/all_cn_ipv6.txt | sed -e 's/^/add address=/' -e 's/$/ list\='${LIST_NAME}'/' >> ipv6.rsc

# combine ipv4 and ipv6
echo -e "# Update at ${DATE_TIME}
/ip firewall address-list remove [/ip firewall address-list find list=${LIST_NAME}]" > all.rsc
cat ipv4.rsc | grep -v "\#" | grep -v "remove" >> all.rsc
echo -e "\n/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=${LIST_NAME}]" >> all.rsc
cat ipv6.rsc | grep -v "\#" | grep -v "remove" >> all.rsc
