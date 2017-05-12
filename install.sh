#!/bin/bash

# Usage
# cd Desktop
# ./install.sh 2>&1 | tee install.log
#


# https://github.com/asdf-vm/asdf

main_section_heading () {
    echo " "
    echo " "
    echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    echo " $1"
    if [ -n "$2" ]; then
        # $2 is set to a non-empty string
        echo " $2"
    fi
    echo "======================================================================"
}

sub_section_heading () {
    echo " "
    echo " "
    echo "--- $1"
    echo "--------------------"
}
# Personal notes ...
# System settings: Language Support
# Install new language: German
# Set Regional Format to "Deutsch (Schweiz)". Apply System-Wide
# System settings: Text Entry
# Add new Input Source: German (Switzerland)
# sudo apt-get -y install open-vm-tools open-vm-tools-desktop net-tools gnome-shell git

# ----------------------------------------------------------------------------------------------------
main_section_heading "Environment variables"
# ----------------------------------------------------------------------------------------------------
# Env variables used in the commands below

sub_section_heading "postgres"
set -x
# Edit the following to change the name of the database user that will be created:
POSTGRES_APP_DB_USER=postgres
POSTGRES_APP_DB_PASS=$POSTGRES_APP_DB_USER
set +x

sub_section_heading "git"
set -x
GIT_USER_EMAIL="" # Enter your email address here
GIT_USER_NAME="" # Enter your name here
GIT_CREDENTIAL_HELPER_CACHE_TIMEOUT="86400"
set +x


# ----------------------------------------------------------------------------------------------------
main_section_heading "General dependencies"
# ----------------------------------------------------------------------------------------------------
set -x

cd ~/Downloads/
mkdir autoinstall
cd autoinstall

sudo apt-get -y update
sudo apt-get -y upgrade

# net-tools contains ifconfig
sudo apt-get -y install net-tools

# git is needed by a lot of tools below
sudo apt-get -y install git

# For atom
sudo add-apt-repository -y ppa:webupd8team/atom
sudo apt-get -y update
sudo apt-get -y upgrade

# libncurses5-dev
sudo apt-get -y install \
autoconf \
automake \
bison \
build-essential \
libssl-dev \
libssh-dev \
libyaml-dev \
libreadline-dev \
zlib1g-dev \
libncurses-dev \
libffi-dev \
libgdbm3 \
libgdbm-dev \
unison \
unison-gtk \
htop \
inotify-tools \
libxml2-utils \
fop \
xsltproc \
libxslt1-dev \
libtool \
unixodbc-dev


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "git"
# ----------------------------------------------------------------------------------------------------
set -x
if [ -n "${GIT_USER_EMAIL}" ]; then
    # "VAR is set to a non-empty string"
    git config --global user.email "$GIT_USER_EMAIL"
fi
if [ -n "${GIT_USER_EMAIL}" ]; then
    git config --global user.name "$GIT_USER_NAME"
fi

if [ -n "${GIT_CREDENTIAL_HELPER_CACHE_TIMEOUT}" ]; then
    # Save your password in memory and set the cache time in minutes manually:
    git config --global credential.helper 'cache --timeout='$GIT_CREDENTIAL_HELPER_CACHE_TIMEOUT
    # Set the cache to timeout after x secconds
    # 86400 = 1 day
    # default is 15 minutes
fi


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "asdf"
# ----------------------------------------------------------------------------------------------------
set -x

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0

add_to_file_if_not_exists() {
  LINESEARCH=$1
  LINEREPLACE=$2
  FILE=$3
  grep -qF "$LINESEARCH" "$FILE" || echo -e $LINEREPLACE >> "$FILE"
}

# For asdf and Ubuntu or other linux distros
add_to_file_if_not_exists '. $HOME/.asdf/asdf.sh' '\n. $HOME/.asdf/asdf.sh' ~/.bashrc
add_to_file_if_not_exists '. $HOME/.asdf/completions/asdf.bash' '\n. $HOME/.asdf/completions/asdf.bash' ~/.bashrc

#Reloads the .bashrc for asdf, without needing to log in and out again
. ~/.bashrc
# This does not seem to work, so perform these steps manually within this session
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "Erlang, Elixir and Elm"
# ----------------------------------------------------------------------------------------------------
set -x

# Dependencies for elixir, erlang, elm
sub_section_heading "Dependencies building elixir, erlang, elm using asdf"



# Use asdf to install Erlang, Elixir and Elm
sub_section_heading "Add asdf plugins ..."

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add elm https://github.com/vic/asdf-elm.git
asdf plugin-update --all

asdf_install () {
  APPNAME=$1
  # Get the last line in the version number string (sed -e '$!d'). This will be the latest version available for the application.
  LATEST_VERSION=$(asdf list-all $APPNAME | sed -e '$!d')
  echo $APPNAME: $LATEST_VERSION
  asdf install $APPNAME $LATEST_VERSION
  asdf global $APPNAME $LATEST_VERSION
  asdf local $APPNAME $LATEST_VERSION
}

sub_section_heading "Install ..."

sub_section_heading "asdf_install erlang"
asdf_install "erlang"

sub_section_heading "asdf_install elixir"
asdf_install "elixir"

sub_section_heading "asdf_install elm"
asdf_install "elm"


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "nodejs 7.x"
# ----------------------------------------------------------------------------------------------------
set -x

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt install -y nodejs


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "Additional tools that need npm"
# ----------------------------------------------------------------------------------------------------
set -x

sub_section_heading "elm-oracle ..."
sudo npm install -g elm-oracle

sub_section_heading "elm-format ..."
sudo npm install -g elm-format


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "Phoenix (Elixir)"
# ----------------------------------------------------------------------------------------------------
set -x

mix local.hex --force
mix local.rebar --force
mix archive.install "https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez" --force


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "Postgres"
# ----------------------------------------------------------------------------------------------------
set -x

sudo apt-get -y install postgresql postgresql-contrib libpq-dev pgadmin3

PGVERSION=$(ls /etc/postgresql)
PG_CONF="/etc/postgresql/$PGVERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PGVERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PGVERSION/main"
# this has been set at the top of the script POSTGRES_APP_DB_USER=postgres
# this has been set at the top of the script POSTGRES_APP_DB_PASS=postgres

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

if sudo cat "$PG_HBA" |
  grep -xqFe "host    all             all             all                     md5"
then
  echo host    all             all             all                     md5 already exists
else
  echo not found
  echo 'host    all             all             all                     md5' | sudo tee -a $PG_HBA
fi

if sudo cat "$PG_CONF" |
  grep -xqFe "client_encoding = utf8"
then
  echo client_encoding = utf8 already exists
else
  echo not found
  echo 'client_encoding = utf8' | sudo tee -a $PG_CONF
fi

sudo service postgresql restart

sudo -u postgres bash -c "psql -c \"CREATE USER $POSTGRES_APP_DB_USER WITH PASSWORD '$POSTGRES_APP_DB_PASS';\""
sudo -u postgres bash -c "psql -c \"ALTER USER $POSTGRES_APP_DB_USER WITH PASSWORD '$POSTGRES_APP_DB_PASS';\""

# psql -U postgres -W -h localhost
# Enter the password 'postgres' to log on to psql


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "Atom"
# ----------------------------------------------------------------------------------------------------
set -x

sudo apt-get -y install atom

apm install \
atom-elixir \
elm-format \
file-icons \
git-plus \
html-to-elm \
language-elixir \
language-elm \
language-lisp \
linter \
linter-elixirc \
linter-elm-make \
linter-xmllint \
merge-conflicts \
minimap \
project-manager \
refactor \
regex-railroad-diagram \
split-diff \
tabs-to-spaces \
trailing-spaces \
xml-formatter \
monokai

# autocomplete-elixir deprecated and replaced with atom-elixir
# https://github.com/wende/autocomplete-elixir


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "Sublime Text 3 (dev build)"
# ----------------------------------------------------------------------------------------------------
set -x

# Note: this is uses dev build and requires a valid serial number

# This will install or update sublime text, recognizing if the version number of the locally
# installed ST3 is older than the remote version available. There will only be an update
# if the remote version is larger than the local version.
# If this is an initial install, the standard ST3 packages will be installed.
arch=amd64
channel=dev

echo --------------------

if [ "$channel" = "dev" ]
then
  remoteversionurl="http://www.sublimetext.com/updates/3/dev/updatecheck?platform=linux&arch=x64"
else
  remoteversionurl="http://www.sublimetext.com/updates/3/stable/updatecheck?platform=linux&arch=x64"
fi

localversion=$(dpkg -s sublime-text | grep Version  | grep -o -E '[0-9]+')

json=$(wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 20 -O - ${remoteversionurl})
remoteversion=$(echo ${json} | grep -Po '"latest_version": \K[0-9]+')

# remoteversion=$(wget -O - https://www.sublimetext.com/3${channel} | grep -o 'href="https://download.sublimetext.com/Sublime Text Build [0-9][0-9][0-9][0-9].dmg"' | grep -o -E '[0-9]+')

remoteurl=https://download.sublimetext.com/sublime-text_build-${remoteversion}_${arch}.deb
filename=sublime-text_build-${remoteversion}_${arch}.deb

echo --------------------

echo version json=${json}

echo --------------------
echo ${cwd}
echo channel=${channel} 
echo localversion=${localversion}
echo remoteversion=${remoteversion}
echo remoteurl=${remoteurl}
echo remoteversionurl=${remoteversionurl}
echo filename=${filename}
echo --------------------

if [ -z "$remoteversion" ]
then
  echo 'remoteversion variable is undefined'
  exit 1
fi

if [[ "$localversion" != "$remoteversion" ]]
then
  echo Update Sublime Text 3 from ""${localversion}"" to ""${remoteversion}""
  wget --quiet ${remoteurl} && sudo dpkg -i ${filename}
  rm ${filename}

  if [ -z "$localversion" ]
  then
    echo Install my Sublime Text 3 packages ...
    cwd=$(pwd)

    mkdir -p ~/.config/sublime-text-3/Installed\ Packages
    cd ~/.config/sublime-text-3/Installed\ Packages/
    wget --quiet https://packagecontrol.io/Package%20Control.sublime-package

    mkdir -p ~/.config/sublime-text-3/Packages/User
    cd ~/.config/sublime-text-3/Packages/User/
    wget --quiet https://github.com/rudolfb/ubuntu-elixir-elm-install-shell-script/raw/master/sublime-text-3/Package%20Control.sublime-settings
    wget --quiet https://github.com/rudolfb/ubuntu-elixir-elm-install-shell-script/raw/master/sublime-text-3/Terminal.sublime-settings

    # Revert back to previous directory
    cd $cwd
  fi
else
  echo Sublime Text 3 local version ${localversion} is up to date  
fi

echo --------------------


# When you open Sublime Text the package control will automatically be initialized, and all packages in the sublime.settings will be downloaded and installed.
subl --background &


set +x
# ----------------------------------------------------------------------------------------------------
main_section_heading "Check the version numbers to test the installations"
# ----------------------------------------------------------------------------------------------------

sub_section_heading "git"
echo "git --version"
git --version
echo "git config --list"
git config --list

sub_section_heading "node"
echo "node --version"
node --version
echo "npm --version"
npm --version

sub_section_heading "postgres"
echo "psql --version"
psql --version

sub_section_heading "erlang"
echo "asdf current erlang"
asdf current erlang

echo "asdf current elixir"
asdf current elixir

sub_section_heading "elixir"
echo "elixir --version"
elixir --version

sub_section_heading "elm"
echo "asdf current elm"
asdf current elm

echo "elm --version"
elm --version

sub_section_heading "atom"
echo "atom --version"
atom --version
echo "Enter 'atom' in a shell to start atom."

# ----------------------------------------------------------------------------------------------------
main_section_heading "End"
# ----------------------------------------------------------------------------------------------------

exec bash
