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
COLORS=([darkred]="rgba(139, 0, 0," [crimson]="rgba(220, 20, 60," [darkolivegreen]="rgba(85, 107, 47,")

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
for EXTN in ${EXTUL[@]};
do
  wget "$EXTWL/$EXTN.shell-extension.zip"
  ZIPNAME=./$EXTN.shell-extension
  gnome-extensions install -f $ZIPNAME.zip
  unzip -d $ZIPNAME $ZIPNAME.zip
  NAME=$(jq '.uuid' ./$ZIPNAME/metadata.json | tr -d '"')
  gnome-extensions enable $NAME
  rm -Rf ./$ZIPNAME*
done

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
  sleep 1
  sed -i "s/_PRIMARY_COLOR_/${COLORS[$1]}/g" ./temp/gnome-shell/gnome-shell.css
  mv ./temp $ROUTE/kiatori_$1
else
  sed -i "s/_KIATORITHEME_/$THEME/g" ./kiatori.dconf
  cp -r ./kiatori_* $ROUTE
fi

dconf load / < ./kiatori.dconf
rm ./kiatori.dconf

if [ $1 ];
then
  notify-send "kiatori_$1 theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"
else
  notify-send "$THEME theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"
fi

exit 0
