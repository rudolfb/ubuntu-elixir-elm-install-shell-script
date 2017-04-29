

# Returns a list of manually installed packages:
# comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)



# Add additional repositories for Handbrake, Atom
sudo add-apt-repository -y ppa:stebbins/handbrake-releases
sudo add-apt-repository -y ppa:webupd8team/atom
sudo apt-add-repository -y ppa:teejee2008/ppa

sudo apt-get -y update

# Install the packages from the additional repositories
sudo apt-get install -y handbrake-gtk
sudo apt-get install -y handbrake-cli
sudo apt-get install -y atom
sudo apt-get install -y aptik


# Install Calibre
# https://calibre-ebook.com/download_linux
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

#Install other software I need
sudo apt install -y \
aptitude \
atom \
autoconf \
automake \
bison \
chromium-browser \
default-jdk \
default-jre \
evolution \
firefox-locale-de \
fop \
git \
gnome-shell \
gparted \
handbrake-gtk \
htop \
hunspell-de-at \
hunspell-de-ch \
hunspell-de-de \
hunspell-en-au \
hunspell-en-ca \
hunspell-en-gb \
hunspell-en-za \
hyphen-de \
hyphen-en-ca \
hyphen-en-gb \
inotify-tools \
language-pack-gnome-de \
libappindicator1 \
libffi-dev \
libgdbm-dev \
libncurses5-dev \
libpq-dev \
libreadline-dev \
libreoffice-help-de \
libreoffice-help-en-gb \
libreoffice-l10n-de \
libreoffice-l10n-en-gb \
libreoffice-l10n-en-za \
libssh-dev \
libssl-dev \
libtool \
libxml2-utils \
libxslt1-dev \
libyaml-dev \
mythes-de \
mythes-de-ch \
mythes-en-au \
net-tools \
network-manager-openvpn-gnome \
nodejs \
p7zip \
p7zip-full \
rar \
ruby \
thunderbird-locale-de \
thunderbird-locale-en-gb \
unison \
unison-gtk \
unixodbc-dev \
unrar \
vlc \
wngerman \
wogerman \
wswiss \
xsltproc \
zlib1g-dev

# Teamviewer
wget --quiet https://download.teamviewer.com/download/teamviewer_i386.deb && sudo dpkg -i teamviewer_i386.deb

sudo apt-get install -y -f 

#Manual
# smartgit

