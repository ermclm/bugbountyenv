#!/bin/bash
# Credits to NahamSEC https://github.com/nahamsec/bbht

BLUE="\e[34m"
ENDCOLOR="\e[0m"

# --- Install system packages ----
echo -e "${BLUE}Update and upgrade system packages...${ENDCOLOR}"
sudo apt-get update -y
sudo apt-get upgrade -y
echo ""

echo -e "${BLUE}Preparing environment with needed packages...${ENDCOLOR}"
sudo apt-get install -y libcurl4-openssl-dev libssl-dev jq ruby-full unzip libpq-dev vim telnet libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev build-essential libssl-dev libffi-dev python3-dev python-setuptools libldns-dev python3-pip python3-dns python3 git rename
pip3 install psycopg2-binary mysql-connector-python-rf requests_ntlm defusedxml bs4 jinja2
echo ""


# --- Install GO ----
if [[ -z "$GOPATH" ]];then
echo -e "${BLUE}It looks like go is not installed, would you like to install it now (yes/no)?...${ENDCOLOR}"
read choice
    case $choice in
        yes)
            echo -e "${BLUE}Installing Golang${ENDCOLOR}"
            export GOROOT=/usr/local/go
            export GOPATH=$HOME/go
            export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
            echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
            echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile			
            echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile	
            wget -q -O - https://git.io/vQhTU | bash
            source ~/.bash_profile
            sleep 1
            break
            ;;
        no)
            echo "Please install go and rerun this script"
            ;;
	esac	
fi

# --- Install Ruby using Rbenv script ----
sudo apt-get remove ruby -y
sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
curl -sL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash -
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

rbenv install 3.2.0
rbenv global 3.2.0
sudo apt-get install rubygems

# --- Setup environment ----
mkdir ~/tools/
mkdir ~/tools/seclists

echo -e "${BLUE}Configure .bash_rc aliases...${ENDCOLOR}"
cat bash_profile >> ~/.bash_profile
source ~/.bash_profile
cd ~/tools/
echo ""

echo -e "${BLUE}Installing Sublist3r...${ENDCOLOR}"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r*
pip3 install -r requirements.txt
cd ~/tools/
echo ""


echo -e "${BLUE}Installing Ffuzz...${ENDCOLOR}"
git clone https://github.com/ffuf/ffuf
cd ffuf; go get; go build
cd ~/tools/
echo ""


echo -e "${BLUE}Installing wpscan...${ENDCOLOR}"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan*
echo 3.2.0 > .ruby-version
gem instal bundler && bundle install --without test
cd ~/tools/
echo ""


echo -e "${BLUE}Installing subfinder...${ENDCOLOR}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
echo ""


echo -e "${BLUE}Installing dirsearch...${ENDCOLOR}"
git clone https://github.com/maurosoria/dirsearch.git --depth 1
cd ~/tools/
echo ""


echo -e "${BLUE}Installing sqlmap...${ENDCOLOR}"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd ~/tools/
echo ""


echo -e "${BLUE}Installing lazyrecon...${ENDCOLOR}"
git clone https://github.com/nahamsec/lazyrecon.git
cd ~/tools/
echo ""


echo -e "${BLUE}Installing nmap...${ENDCOLOR}"
sudo apt-get install -y nmap
echo ""


echo -e "${BLUE}Installing amass...${ENDCOLOR}"
sudo wget https://github.com/OWASP/Amass/releases/download/v3.21.2/amass_linux_amd64.zip
unzip amass_linux_amd64.zip
mv amass_linux_amd64/amass /usr/local/bin
rm -rf amass_linux_amd64*
cd ~/tools/
echo ""


echo -e "${BLUE}Installing massdns...${ENDCOLOR}"
git clone https://github.com/blechschmidt/massdns.git
cd ~/tools/massdns
sudo make
cd ~/tools/
echo ""


echo -e "${BLUE}Installing ffuf...${ENDCOLOR}"
go install github.com/ffuf/ffuf@latest
echo ""


echo -e "${BLUE}Installing httprobe...${ENDCOLOR}"
go install github.com/tomnomnom/httprobe@latest
echo ""


echo -e "${BLUE}Downloading Seclists...${ENDCOLOR}"
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools/SecLists/Discovery/DNS/
##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools/
echo ""
echo -e "${BLUE}Installation finished ;)${ENDCOLOR}"