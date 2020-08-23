#!/bin/bash

mount_dir=$(mount| grep /dev/mapper/luks-eabd21af-6196-48aa-858f-3d7f58a5e309| awk '{print $3}')
last_backup=$(find "$mount_dir""/backup" -maxdepth 2 -name ""$USER"_*" -printf "%T@ %Tc %p\n" | sort -nr | head -n1| awk '{print $9}')

printf "Last backup in: "$last_bak"\n"
rsync -ahP --inplace "$last_backup" /
