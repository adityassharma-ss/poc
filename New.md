echo -e "label: gpt\n\n/dev/sda2 : start=2050048, size=100%, type=8300" | sudo sfdisk --no-reread --force /dev/sda
