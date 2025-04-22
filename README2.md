PHASE 1: Install and Configure Oracle Express DB (on the Oracle Linux VM)
Step 1: Switch to /tmp
bash
Copy
Edit
cd /tmp
Step 2: Download Oracle XE 21c RPM
bash
Copy
Edit
curl -L -o oracle-database-xe-21c.rpm "https://download.oracle.com/otn-pub/otn_software/db-express/21c/oracle-database-xe-21c-1.0-1.0.18.x86_64.rpm"
This file will be ~2.6 GB. Make sure it downloads fully. You can check with:

bash
Copy
Edit
ls -lh oracle-database-xe-21c.rpm
Step 3: Install the RPM
bash
Copy
Edit
sudo dnf localinstall -y oracle-database-xe-21c.rpm
Step 4: Configure the DB
bash
Copy
Edit
sudo /etc/init.d/oracle-xe-21c configure
You’ll be prompted to:

Set admin password (keep it simple for now, like Admin1234)

Accept default ports (just press Enter)

PHASE 2: Enable Access from Windows VDI
Step 1: Find Internal Private IP of Linux VM
bash
Copy
Edit
ip a | grep inet
Look for something like 172.16.x.x — that’s your private IP.

Step 2: Allow SQL*Net Port (1521) on Linux Firewall
bash
Copy
Edit
sudo firewall-cmd --add-port=1521/tcp --permanent
sudo firewall-cmd --reload
Step 3: Note DB Connection Details
Hostname/IP: <private IP of Oracle Linux VM>

Port: 1521

SID/Service Name: XE

Username: system (or create your own later)

Password: The one you set during setup

Step 4: Use SQL Developer on Windows VDI
Install Oracle SQL Developer on the VDI, and connect:

Connection Name: XE

Username: system

Password: (the one you set)

Hostname: (private IP of Linux VM)

Port: 1521

Service Name: XE

Click Connect

Bonus Tips
If VDI can’t reach the Linux VM, ensure:

Both are in same VNet/subnet or peered

Linux VM has no NSG blocking port 1521

Windows firewall on VDI allows outbound 1521

Let me know once you reach the "Connected" part in SQL Developer — I’ll help create users, schemas, or test DB if needed.
