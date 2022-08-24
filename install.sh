#! /bin/bash

# kiatori theme for Gnome 42.*^
# Version: 1.0.1
# Customization by Spellmell
# spellmell.github.io
# spellmell@protonmail.com
# 7/25/2022
# https://github.com/spellmell/kiatori_gnome_theme

THEME=kiatori_darkred
ROUTE=~/.themes
FONTROUTE=~/.local/share/fonts
FONTSNAMES=("Raleway" "Orbitron")
EXTWL="https://extensions.gnome.org/extension-data"
EXTUL=("extension-listtu.berry.v30" "user-themegnome-shell-extensions.gcampax.github.com.v49" "just-perfection-desktopjust-perfection.v21")
# colors
declare -A COLORS
COLORS=([darkred]="rgba(139, 0, 0," [tomato]="rgba(255, 99, 71," [crimson]="rgba(220, 20, 60," [firebrick]="rgba(178, 34, 34," [orangered]="rgba(255, 69, 0," [darkolivegreen]="rgba(85, 107, 47," [forestgreen]="rgba(34, 139, 34," [darkcyan]="rgba(0, 139, 139," [dimgrey]="rgba(105, 105, 105," [midnightblue]="rgba(25, 25, 112," [royalblue]="rgba(65, 105, 225," [seagreen]="rgba(46, 139, 87," [teal]="rgba(0, 128, 128,")
declare -A COLORSHEX
COLORSHEX=([darkred]="#8B0000" [tomato]="#FF6347" [crimson]="#DC143C" [firebrick]="#B22222" [orangered]="#FF4500" [darkolivegreen]="#556B2F" [forestgreen]="#228B22" [darkcyan]="#008B8B" [dimgrey]="#696969" [midnightblue]="#191970" [royalblue]="#4169E1" [seagreen]="#2E8B57" [teal]="#008080")

# fonts instalation
for FONTNAME in ${FONTSNAMES[@]};
do
  if [ ! -d /usr/share/fonts/$FONTNAME ];
  then
    if [ ! -d $FONTROUTE ];
    then
      mkdir -p $FONTROUTE
      wget -O $FONTNAME.zip "https://fonts.google.com/download?family=$FONTNAME"
      unzip -o -d $FONTROUTE/$FONTNAME $FONTNAME.zip
      rm ./$FONTNAME.zip
    fi
  fi
done

# extensions installation
# for EXTN in ${EXTUL[@]};
# do
#   wget "$EXTWL/$EXTN.shell-extension.zip"
#   ZIPNAME=./$EXTN.shell-extension
#   gnome-extensions install -f $ZIPNAME.zip
#   unzip -d $ZIPNAME $ZIPNAME.zip
#   NAME=$(jq '.uuid' ./$ZIPNAME/metadata.json | tr -d '"')
#   gnome-extensions enable $NAME
#   rm -Rf ./$ZIPNAME*
# done

# theme instalation
if [ ! -d $ROUTE ];
then
  mkdir -p $ROUTE
fi

cp ./setup/kiatori.dconf_setup ./kiatori.dconf
sed -i "s/_USERNAME_/$USER/" ./kiatori.dconf

if [ $1 ];
then
  sed -i "s/_KIATORITHEME_/kiatori_$1/g" ./kiatori.dconf
  cp -r ./kiatori_darkred ./temp
  cp ./setup/gnome-shell_PATRON_.css ./temp/gnome-shell/gnome-shell.css
  sed -i "s/(_PRIMARY_COLOR_)/($1)/g" ./temp/gnome-shell/gnome-shell.css
  sed -i "s/_PRIMARY_COLOR_/${COLORS[$1]}/g" ./temp/gnome-shell/gnome-shell.css
  sed -i "s/stop-color:#8a0000;stop-opacity:1;/stop-color:${COLORSHEX[$1]};stop-opacity:1;/g" ./temp/gnome-shell/assets/grad_bg_overview.svg
  sed -i "s/stop-color:#8a0000;stop-opacity:1;/stop-color:${COLORSHEX[$1]};stop-opacity:1;/g" ./temp/gnome-shell/assets/grad_bg_popups.svg
  mv ./temp $ROUTE/kiatori_$1
  notify-send "kiatori_$1 theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"
else
  sed -i "s/_KIATORITHEME_/$THEME/g" ./kiatori.dconf
  cp -r ./kiatori_* $ROUTE
  notify-send "$THEME theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"
fi

dconf load / < ./kiatori.dconf
rm ./kiatori.dconf

busctl --user call org.gnome.Shell
exit 0
