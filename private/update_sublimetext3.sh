#!/bin/bash
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
	echo Update Sublime Text 3 from ${localversion} to ${remoteversion}
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
