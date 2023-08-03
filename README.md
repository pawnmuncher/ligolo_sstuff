# ligolo_sstuff
My ligolo hacks.

### ligolo_start.sh
A quick way to spin up ligolo.
It will prompt you for input(s).

`sudo ./ligolo_start.sh`

### Input examples to follow w/explanations
``` sh
Please enter the username for the TUN/TAP device (the user who will run the proxy): jhacman  #your kali username
Please enter the full path to the ligolo directory: /home/jhacman/Documents/tools/ligolo  #full path to the ligolo FOLDER
TUN/TAP device 'ligolo' already exists. Do you want to remove it? (y/n): y  #kill any existing tuntap
Please enter IP address and/or CIDR (172.17.0.0/24 etc) for ligolo to route for you (or type 'done' to finish): 172.17.0.0/24 #add ip ranges to tunnel
Please enter IP address and/or CIDR (172.17.0.0/24 etc) for ligolo to route for you (or type 'done' to finish): 172.18.0.0/24
Please enter IP address and/or CIDR (172.17.0.0/24 etc) for ligolo to route for you (or type 'done' to finish): done #finished adding, so run
```

