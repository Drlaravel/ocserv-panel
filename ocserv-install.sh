#!/usr/bin/env bash


install() {

ip=$(hostname -I|cut -f1 -d ' ')
echo "Your Server IP address is:$ip"

echo -e "\e[32mInstalling gnutls-bin\e[39m"

apt install gnutls-bin
mkdir certificates
cd certificates

cat << EOF > ca.tmpl
cn = "VPN CA"
organization = "Big Corp"
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
EOF

certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem

cat << EOF > server.tmpl
#yourIP
cn=$ip
organization = "my company"
expiration_days = 3650
signing_key
encryption_key
tls_www_server
EOF

certtool --generate-privkey --outfile server-key.pem
certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem

echo -e "\e[32mInstalling ocserv\e[39m"
apt install ocserv
cp /etc/ocserv/ocserv.conf ~/certificates/

sed -i -e 's@auth = "@#auth = "@g' /etc/ocserv/ocserv.conf
sed -i -e 's@auth = "pam@auth = "#auth = "pam"@g' /etc/ocserv/ocserv.conf
sed -i -e 's@try-mtu-discovery = @try-mtu-discovery = true@g' /etc/ocserv/ocserv.conf
sed -i -e 's@dns = @#dns = @g' /etc/ocserv/ocserv.conf
sed -i -e 's@# multiple servers.@dns = 8.8.8.8@g' /etc/ocserv/ocserv.conf
sed -i -e 's@route =@#route =@g' /etc/ocserv/ocserv.conf
sed -i -e 's@no-route =@#no-route =@g' /etc/ocserv/ocserv.conf
sed -i -e 's@cisco-client-compat@cisco-client-compat = true@g' /etc/ocserv/ocserv.conf
sed -i -e 's@##auth = "#auth = "pam""@auth = "plain[passwd=/etc/ocserv/ocpasswd]"@g' /etc/ocserv/ocserv.conf

sed -i -e 's@server-cert = /etc/ssl/certs/ssl-cert-snakeoil.pem@server-cert = /etc/ocserv/server-cert.pem@g' /etc/ocserv/ocserv.conf
sed -i -e 's@server-key = /etc/ssl/private/ssl-cert-snakeoil.key@server-key = /etc/ocserv/server-key.pem@g' /etc/ocserv/ocserv.conf

echo "Enter a username:"
read username

ocpasswd -c /etc/ocserv/ocpasswd $username
iptables -t nat -A POSTROUTING -j MASQUERADE
sed -i -e 's@#net.ipv4.ip_forward=@net.ipv4.ip_forward=@g' /etc/sysctl.conf

sysctl -p /etc/sysctl.conf
cp ~/certificates/server-key.pem /etc/ocserv/
cp ~/certificates/server-cert.pem /etc/ocserv/
echo -e "\e[32mStopping ocserv service\e[39m"
service ocserv stop
echo -e "\e[32mStarting ocserv service\e[39m"
service ocserv start

echo "OpenConnect Server Configured Succesfully"

}

uninstall() {
  sudo apt-get purge ocserv
}

addUser() {

echo "Enter a username:"
read username

ocpasswd -c /etc/ocserv/ocpasswd $username

}

showUsers() {
cat /etc/ocserv/ocpasswd
}

deleteUser() {
echo "Enter a username:"
read username
ocpasswd -c /etc/ocserv/ocpasswd -d $username
}

lockUser() {
echo "Enter a username:"
read username
ocpasswd -c /etc/ocserv/ocpasswd -l $username
}

unlockUser() {
echo "Enter a username:"
read username
ocpasswd -c /etc/ocserv/ocpasswd -u $username
}

getidsbot(){
  local message="OpenConnect Server Configured Successfully"
  clear
        echo -e "\E[44;1;37mㅤOpenConnect User Manager Telegram BOT Activationㅤ\E[0m\n"
        echo -ne "\033[1;32m◇ INFORM YOUR BOT TOKEN:\033[1;37m "
        read tokenbot
        echo ""
        echo -ne "\033[1;32m◇ INFORM YOUR TELEGRAM ID:\033[1;37m "
        read iduser
        clear
        
        export BOT_TOKEN="$tokenbot"
        export ADMIN_USER_ID="$iduser"
        # Check if bot.py exists
        if [ ! -f "bot.py" ]; then
          echo "Downloading bot.py from GitHub..."
          curl -O "https://raw.githubusercontent.com/Drlaravel/ocserv-panel/main/bot.py"
        fi
       screen -dmS bot_session bash -c "python3 ./bot.py" 
       sleep 2
       echo -e "\033[1;32mㅤOpenConnect User Manager Telegram BOT Starting \033[0m\n"
}

install_dependencies() {
    echo "Installing Python dependencies..."
    pip3 install -r requirements.txt
    echo "Python dependencies installed."
}
if [ -e "requirements.txt" ]; then
    install_dependencies
else
    echo "requirements.txt file not found."
    sleep 2
    echo "Downloading bot.py from GitHub..."
    curl -O "https://raw.githubusercontent.com/Drlaravel/ocserv-panel/main/requirements.txt"

fi


telegram-bot(){
  clear

 install_dependencies

echo -e "\E[44;1;37mㅤOpenConnect User Manager Telegram BOT Activationㅤ\E[0m\n"
    echo -e "                 \033[1;33m[\033[1;31m!\033[1;33m] \033[1;31mATTENTION! \033[1;33m[\033[1;31m!\033[1;33m]\033[0m"
    echo -e "\n\033[1;32m1° \033[1;37m- \033[1;33mTHROUGH YOUR TELEGRAM ACCOUNT, ACCESS THE FOLLOWING BOT\033[1;37m:\033[0m"
    echo -e "\n\033[1;32m2° \033[1;37m- \033[1;33mBOT \033[1;37m@BotFather \033[1;33mCREATE YOUR BOT \033[1;31mSEND TO @Botfather: \033[1;37m/newbot\033[0m"
    echo -e "\n\033[1;32m3° \033[1;37m- \033[1;33mBOT \033[1;37m@myidbot \033[1;33mAND GET YOUR ID \033[1;31mSEND TO @myidbot: \033[1;37m/getid\033[0m"
    echo -e "\033[0;34m◇────────────────────────────────────────────────◇\033[1;32m"
    echo ""
    read -p "◇ DO YOU WISH TO CONTINUE ? [y/n]: " -e -i y resposta
    [[ "$resposta" = 'y' ]] && {
        getidsbot
    } || {
        echo -e "\n\033[1;31m◇ Returning...\033[0m"
        sleep 2
        
    }
}
if [[ "$EUID" -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

cd ~
echo '
 ▒█████   ██▓███  ▓█████  ███▄    █     ▄████▄   ▒█████   ███▄    █  ███▄    █ ▓█████  ▄████▄  ▄▄▄█████▓
▒██▒  ██▒▓██░  ██▒▓█   ▀  ██ ▀█   █    ▒██▀ ▀█  ▒██▒  ██▒ ██ ▀█   █  ██ ▀█   █ ▓█   ▀ ▒██▀ ▀█  ▓  ██▒ ▓▒
▒██░  ██▒▓██░ ██▓▒▒███   ▓██  ▀█ ██▒   ▒▓█    ▄ ▒██░  ██▒▓██  ▀█ ██▒▓██  ▀█ ██▒▒███   ▒▓█    ▄ ▒ ▓██░ ▒░
▒██   ██░▒██▄█▓▒ ▒▒▓█  ▄ ▓██▒  ▐▌██▒   ▒▓▓▄ ▄██▒▒██   ██░▓██▒  ▐▌██▒▓██▒  ▐▌██▒▒▓█  ▄ ▒▓▓▄ ▄██▒░ ▓██▓ ░ 
░ ████▓▒░▒██▒ ░  ░░▒████▒▒██░   ▓██░   ▒ ▓███▀ ░░ ████▓▒░▒██░   ▓██░▒██░   ▓██░░▒████▒▒ ▓███▀ ░  ▒██▒ ░ 
░ ▒░▒░▒░ ▒▓▒░ ░  ░░░ ▒
░ ░░ ▒░   ▒ ▒    ░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒ ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ░▒ ▒  ░  ▒ ░░   
  ░ ▒ ▒░ ░▒ ░      ░ ░  ░░ ░░   ░ ▒░     ░  ▒     ░ ▒ ▒░ ░ ░░   ░ ▒░░ ░░   ░ ▒░ ░ ░  ░  ░  ▒       ░    
░ ░ ░ ▒  ░░          ░      ░   ░ ░    ░        ░ ░ ░ ▒     ░   ░ ░    ░   ░ ░    ░   ░          ░      
    ░ ░              ░  ░         ░    ░ ░          ░ ░           ░          ░    ░  ░░ ░               
                                       ░                                              ░                 
 ██▒   █▓ ██▓███   ███▄    █      ██████ ▓█████  ██▀███   ██▒   █▓▓█████  ██▀███                        
▓██░   █▒▓██░  ██▒ ██ ▀█   █    ▒██    ▒ ▓█   ▀ ▓██ ▒ ██▒▓██░   █▒▓█   ▀ ▓██ ▒ ██▒                      
 ▓██  █▒░▓██░ ██▓▒▓██  ▀█ ██▒   ░ ▓██▄   ▒███   ▓██ ░▄█ ▒ ▓██  █▒░▒███   ▓██ ░▄█ ▒                      
  ▒██ █░░▒██▄█▓▒ ▒▓██▒  ▐▌██▒     ▒   ██▒▒▓█  ▄ ▒██▀▀█▄    ▒██ █░░▒▓█  ▄ ▒██▀▀█▄                        
   ▒▀█░  ▒██▒ ░  ░▒██░   ▓██░   ▒██████▒▒░▒████▒░██▓ ▒██▒   ▒▀█░  ░▒████▒░██▓ ▒██▒                      
   ░ ▐░  ▒▓▒░ ░  ░░ ▒░   ▒ ▒    ▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ▒▓ ░▒▓░   ░ ▐░  ░░ ▒░ ░░ ▒▓ ░▒▓░                      
   ░ ░░  ░▒ ░     ░ ░░   ░ ▒░   ░ ░▒  ░ ░ ░ ░  ░  ░▒ ░ ▒░   ░ ░░   ░ ░  ░  ░▒ ░ ▒░                      
     ░░  ░░          ░   ░ ░    ░  ░  ░     ░     ░░   ░      ░░     ░     ░░   ░                       
      ░                    ░          ░     ░  ░   ░           ░     ░  ░   ░                           
     ░                                                        ░                                         
'


PS3='Please enter your choice: '
options=("Install" "Uninstall" "Add User" "Change Password" "Show Users" "Delete User" "Lock User" "Unlock User" "Telegram Bot" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install")
            install
			break
            ;;
        "Uninstall")
            uninstall
			break
            ;;
        "Add User")
            addUser
			break
            ;;
        "Change Password")
            addUser
			break
            ;;
        "Show Users")
	    showUsers
			break
	    ;;
        "Delete User")
	    deleteUser
			break
	    ;;
        "Lock User")
	    lockUser
			break
	    ;;
        "Unlock User")
	    unlockUser
			break
      ;;
        "Telegram Bot")
        telegram-bot
	    ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

