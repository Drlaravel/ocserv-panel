# OpenConnect-VPN-Server-with-telegram-bot

This source is designed to manage ocserv (OpenConnect Server) through user-friendly interactions in a terminal or Telegram chat. Users can use this bot to perform various actions related to ocserv, such as adding, deleting, locking, unlocking, changing passwords, installing, and deleting configurations.

## Script Installation
Tested on ubuntu 18.04 and 16.04.

Download and saving script on your server:
```bash
curl -O https://raw.githubusercontent.com/iw4p/OpenConnect-Cisco-AnyConnect-VPN-Server-OneKey-ocserv/master/ocserv-install.sh
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

## Setup
pip3 install -r requirements.txt


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

## How to customize the configuration?
In docker way, at the beginning you have to clone the repo:
```sh
git clone https://github.com/iw4p/OpenConnect-Cisco-AnyConnect-VPN-Server-OneKey-ocserv.git
```

cd to the directory
```sh
cd ./OpenConnect-Cisco-AnyConnect-VPN-Server-OneKey-ocserv
```
You can change port, disable UDP, add custom-header and so on.
Modify and customize ocserv.conf file and then build your image with modified ocserv.conf:
```sh
docker build . -t ocserv
```

Create new container from ocserv image
```sh
docker run --name ocserv --privileged -p 443:443 -p 443:443/udp -d ocserv
```

Next steps like add or remove users are same as Docker Installation part.


## Issues
Feel free to submit issues and enhancement requests or contact me via [vida.page/nima](https://vida.page/nima).

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=iw4p/OpenConnect-Cisco-AnyConnect-VPN-Server-OneKey-ocserv&type=Date)](https://star-history.com/#iw4p/OpenConnect-Cisco-AnyConnect-VPN-Server-OneKey-ocserv&Date)


## More
The script is based on [here](https://ocserv.gitlab.io/www/recipes-ocserv-configuration-basic.html)
# ocserv-panel
