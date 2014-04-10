#!/bin/sh
# ----------------------------------------------
# Script is designed to be Postprep equivalent on Mac.
# author: Lucas Messenger
# version: 0.1.2
# created: 02_24_2014
# modified: 02_26_2014
#
#
# Notes:
# ----------------------------------------------
# Flash Player has better link:
# http://fpdownload.macromedia.com/get/flashplayer/current/licensing/mac/install_flash_player_12_osx_pkg.dmg
# But requires Adobe distribution license (looks like it's free)
#

dmgNames=( "Flash.dmg" "Reader.dmg" "AIR.dmg" "Shockwave.dmg" "Silverlight.dmg" "Firefox.dmg" "Java.dmg" )
volNames=( "Adobe Flash Player Installer" "Adobe Reader Installer" "Adobe AIR" "Adobe Shockwave 12" "Silverlight" "Firefox" "Java 7 Update 51" )

clear
uid=$(id -u) #check to see if running in root
if [ "$uid" != "0" ]; then
	echo -e "Postprep for Mac must be run as root user. Please try again."
	exit
fi

mkdir ~/postprep_temp
cd ~/postprep_temp

# Get Flash, Reader, AIR, and Shockwave, Silverlight, and Firefox with curl
echo "Downloading installers...\n"
curl -s -o Flash.dmg http://aihdownload.adobe.com/bin/live/AdobeFlashPlayerInstaller_12_ltrosxd_aaa_aih.dmg
echo "Adobe Flash Player done."
curl -s -o Reader.dmg http://aihdownload.adobe.com/bin/live/AdobeReaderInstaller_11_en_ltrosxd_aaa_aih.dmg
echo "Adobe Reader done."
curl -s -o AIR.dmg http://airdownload.adobe.com/air/mac/download/latest/AdobeAIR.dmg
echo "Adobe AIR done."
curl -s -o Shockwave.dmg http://fpdownload.macromedia.com/get/shockwave/default/english/macosx/latest/Shockwave_Installer_Full_64bit.dmg
echo "Adobe Shockwave done."
curl -s -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36" \
    -Lo Silverlight.dmg http://www.microsoft.com/getsilverlight/handlers/getsilverlight.ashx
echo "Microsoft Silverlight done."
curl -s -L -o Firefox.dmg "http://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
echo "Mozilla Firefox done."
curl -s -L -o Java.dmg "http://javadl.sun.com/webapps/download/AutoDL?BundleId=83377"
echo "Java done."
sleep 1
echo "Installers downloaded.\n"
sleep 1

# Mount downloaded installers
echo "Mounting installers..."
for dmg in ${dmgNames[@]} 
do
	hdiutil attach $dmg -nobrowse -quiet
	echo "$dmg is mounted."
done
sleep 1
echo "Installers are mounted.\n"
sleep 1

clear
# Install from mounted volumes
echo "postprep: installing Firefox..."
cp -R /Volumes/Firefox/Firefox.app /Applications
echo "postprep: Firefox installed."
/Volumes/Adobe\ Flash\ Player\ Installer/Install\ Adobe\ Flash\ Player.app/Contents/MacOS/Install\ Adobe\ Flash\ Player
/Volumes/Adobe\ Reader\ Installer/Install\ Adobe\ Reader.app/Contents/MacOS/Install\ Adobe\ Reader
/Volumes/Adobe\ AIR/Adobe\ AIR\ Installer.app/Contents/MacOS/Adobe\ AIR\ Installer
installer -pkg /Volumes/Adobe\ Shockwave\ 12/Shockwave_Installer_Full.pkg -target /
installer -pkg /Volumes/Silverlight/Silverlight.pkg -target /
installer -pkg /Volumes/Java\ 7\ Update\ 51/Java\ 7\ Update\ 51.pkg -target /
sleep 1

#Unmount installers
echo "Unmounting installers..."
for vol in ${volNames[@]}
do
    hdiutil detach /Volumes/$name -quiet
    echo "$vol is unmounted."
done
sleep 1
echo "Installers are unmounted.\n"
rm -rf ~/postprep_temp
sleep 1
echo "Postprep Mac has completed."
exit 0
