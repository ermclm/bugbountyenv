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
sudo apt-get install -y libcurl4-openssl-dev libssl-dev jq ruby-full unzip libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev build-essential libssl-dev libffi-dev python-dev python-setuptools libldns-dev python3-pip python-pip python-dnspython git rename xargs
echo ""


# --- Install GO ----
if [[ -z "$GOPATH" ]];then
echo -e "${BLUE}It looks like go is not installed, would you like to install it now?...${ENDCOLOR}"
PS3="Please select an option : "
choices=("yes" "no")
select choice in "${choices[@]}"; do
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
					echo "Aborting installation..."
					exit 1
					;;
	esac	
done
fi


# --- Setup environment ----
mkdir ~/tools/
mkdir ~/tools/seclists
cd ~/tools/


echo -e "${BLUE}Configure .bash_rc aliases...${ENDCOLOR}"
cat bash_profile >> ~/.bash_profile
source ~/.bash_profile
echo ""

echo -e "${BLUE}Installing Sublist3r...${ENDCOLOR}"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r*
pip install -r requirements.txt
cd ~/tools/

echo -e "${BLUE}Installing Ffuzz...${ENDCOLOR}"
git clone https://github.com/ffuf/ffuf
cd ffuf; go get; go build
cd ~/tools/


echo -e "${BLUE}Installing wpscan...${ENDCOLOR}"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan*
sudo gem install bundler && bundle install --without test
cd ~/tools/


echo -e "${BLUE}Installing dirsearch...${ENDCOLOR}"
git clone https://github.com/maurosoria/dirsearch.git --depth 1
cd ~/tools/


echo -e "${BLUE}Installing sqlmap...${ENDCOLOR}"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd ~/tools/


echo -e "${BLUE}Installing lazyrecon...${ENDCOLOR}"
git clone https://github.com/nahamsec/lazyrecon.git
cd ~/tools/


echo -e "${BLUE}Installing nmap...${ENDCOLOR}"
sudo apt-get install -y nmap


echo -e "${BLUE}Installing amass...${ENDCOLOR}"
sudo wget https://github.com/OWASP/Amass/releases/download/v3.21.2/amass_linux_amd64.zip
unzip amass_linux_amd64.zip
mv amass_linux_amd64/amass /usr/local/bin
rm -rf amass_linux_amd64*
cd ~/tools/


echo -e "${BLUE}Installing massdns...${ENDCOLOR}"
git clone https://github.com/blechschmidt/massdns.git
cd ~/tools/massdns
make
cd ~/tools/


echo -e "${BLUE}Installing httprobe...${ENDCOLOR}"
sudo go get -u github.com/tomnomnom/httprobe 


echo -e "${BLUE}Downloading Seclists...${ENDCOLOR}"
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools/SecLists/Discovery/DNS/
##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools/
