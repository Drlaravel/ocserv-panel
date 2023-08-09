# OpenConnect-VPN-Server-with-telegram-bot

This source is designed to manage ocserv (OpenConnect Server) through user-friendly interactions in a terminal or Telegram chat. Users can use this bot to perform various actions related to ocserv, such as adding, deleting, locking, unlocking, changing passwords, installing, and deleting configurations.

## Script Installation
Tested on ubuntu 18.04 and 16.04.

Download and saving script on your server:
```sh
git clone https://github.com/Drlaravel/ocserv-panel.git
```
cd to the directory
```sh
cd ./ocserv-panel
```

Making script executable
```bash
chmod +x ocserv-install.sh
```

And then just run it:
```sh
./ocserv-install.sh
``` 
or
```sh
sudo bash ocserv-install.sh
``` 
## Prerequisites Telegram Bot

- Python 3.7 or later
- Telegram Bot API Token
- Authorized User IDs (for controlling access)
- OpenConnect Server (`ocserv`) installed on your system

## Notes
Ensure that your bot is running and accessible before using it.
Use this bot responsibly and securely. Make sure to follow best practices for securing your bot and the systems it interacts with.

## Features 
- Easy install
- Easy uninstall
- Add User
- Change Password
- Show All Users
- Delete User
- Lock User
- Unlock User

## How to connect to it?
For making connection to your server, you can use `AnyConnect`, `OpenConnect` or other alternative clients.

- AnyConnect: [GUI AnyConnect client for available platforms](https://it.umn.edu/vpn-downloads-guides).
- OpenConnect: [OpenConnect client for Linux](https://computingforgeeks.com/how-to-connect-to-vpn-server-with-openconnect-ssl-vpn-client-on-linux/).

And one more thing, contributions are welcome.


