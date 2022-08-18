#! /bin/bash

# kiatori theme for Gnome 42.*^
# Version: 1.0.1
# Customization by Spellmell
# spellmell.github.io
# spellmell@protonmail.com
# 7/25/2022
# https://github.com/spellmell/kiatori_gnome_theme

THEME=kiatori_dark
ROUTE=~/.themes
FONTROUTE=~/.local/share/fonts
FONTNAME="Raleway"
EXTWL="https://extensions.gnome.org/extension-data"
EXTUL=("extension-listtu.berry.v30" "user-themegnome-shell-extensions.gcampax.github.com.v49" "just-perfection-desktopjust-perfection.v21")

# font instalation
# if [ ! -d /usr/share/fonts/$FONTNAME ];
# then
#   if [ ! -d $FONTROUTE ];
#   then
#     mkdir -p $FONTROUTE
#   fi
#   wget -O $FONTNAME.zip "https://fonts.google.com/download?family=$FONTNAME"
#   unzip -d -o $FONTROUTE/$FONTNAME $FONTNAME.zip
#   rm ./$FONTNAME.zip
# fi

# theme instalation
# if [ ! -d $ROUTE ];
# then
#   mkdir -p $ROUTE
# fi

# if [ $1 && -d ./kiatori/$1 ];
# then
#   THEME=$1
#   cp -r ./kiatori/$1 $ROUTE
# else
#   cp -r ./kiatori/* $ROUTE
# fi

# for EXTN in ${EXTUL[@]}; do
#   wget "$EXTWL/$EXTN.shell-extension.zip"
#   ZIPNAME=./$EXTN.shell-extension
#   gnome-extensions install -f $ZIPNAME.zip
#   unzip -d $ZIPNAME $ZIPNAME.zip
#   NAME=$(jq '.uuid' ./$ZIPNAME/metadata.json | tr -d '"')
#   gnome-extensions enable $NAME
#   rm -Rf ./$ZIPNAME*
# done

sed -i "s/_KIATORITHEME_/$THEME/g" ./kiatori.dconf
sed -i "s/_USERNAME_/$USER/" ./kiatori.dconf

dconf load / < ./kiatori.dconf

notify-send "kiatori theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"

exit 0
