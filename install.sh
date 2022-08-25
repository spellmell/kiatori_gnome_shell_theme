#! /bin/bash

# kiatori theme for Gnome 42.*^
# Version: 1.0.1
# Customization by Spellmell
# spellmell.github.io
# spellmell@protonmail.com
# 8/15/2022

# https://github.com/spellmell/kiatori_gnome_shell_theme

 # This program is free software; you can redistribute it and/or modify it
 # under the terms and conditions of the GNU Lesser General Public License,
 # version 2.1, as published by the Free Software Foundation.

THEME=kiatori_darkred
ROUTE=~/.themes
FONTROUTE=~/.local/share/fonts
FONTSNAMES=("Raleway" "Orbitron")
EXTWL="https://extensions.gnome.org/extension-data"
declare -A EXTUL
EXTUL=(["extension-list@tu.berry"]="extension-listtu.berry.v30" ["user-theme@gnome-shell-extensions.gcampax.github.com"]="user-themegnome-shell-extensions.gcampax.github.com.v49" ["just-perfection-desktop@just-perfection"]="just-perfection-desktopjust-perfection.v21")
# colors
declare -A COLORS
COLORS=([darkred]="rgba(139, 0, 0," [tomato]="rgba(255, 99, 71," [crimson]="rgba(220, 20, 60," [firebrick]="rgba(178, 34, 34," [orangered]="rgba(255, 69, 0," [darkolivegreen]="rgba(85, 107, 47," [forestgreen]="rgba(34, 139, 34," [darkcyan]="rgba(0, 139, 139," [dimgrey]="rgba(105, 105, 105," [midnightblue]="rgba(25, 25, 112," [royalblue]="rgba(65, 105, 225," [slateblue]="rgba(106, 90, 205," [seagreen]="rgba(46, 139, 87," [teal]="rgba(0, 128, 128," [purple]="rgba(128, 0, 128,")
declare -A COLORSHEX
COLORSHEX=([darkred]="#8B0000" [tomato]="#FF6347" [crimson]="#DC143C" [firebrick]="#B22222" [orangered]="#FF4500" [darkolivegreen]="#556B2F" [forestgreen]="#228B22" [darkcyan]="#008B8B" [dimgrey]="#696969" [midnightblue]="#191970" [royalblue]="#4169E1" [slateblue]="#6A5ACD" [seagreen]="#2E8B57" [teal]="#008080" [purple]="#800080")

declare -F install_fonts
install_fonts (){
  # fonts instalation
  installFonts=true
  if [ $installFonts == true ];
  then
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
  fi
}

declare -F install_extensions
install_extensions (){
  # extensions installation
  installExtensions=true
  extensionsRoute=$HOME/.local/share/gnome-shell/extensions
  if [ $installExtensions == true ];
  then
    for EXTN in ${!EXTUL[@]};
    do
      if [ ! -d $extensionsRoute/$EXTN ];
      then
        wget "$EXTWL/${EXTUL[$EXTN]}.shell-extension.zip"
        ZIPNAME=./${EXTUL[$EXTN]}.shell-extension
        gnome-extensions install -f $ZIPNAME.zip
        unzip -d $ZIPNAME $ZIPNAME.zip
        NAME=$(jq '.uuid' ./$ZIPNAME/metadata.json | tr -d '"')
        gnome-extensions enable $NAME
        rm -Rf ./$ZIPNAME*
      fi
    done
  fi
}

declare -F setup
setup (){
  cp ./setup/kiatori.dconf_setup ./kiatori.dconf
  sed -i "s/_USERNAME_/$USER/" ./kiatori.dconf
}

declare -F dconfig
dconfig (){
  dconf load / < ./kiatori.dconf
  rm ./kiatori.dconf
  notify-send "kiatori_$1 theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"
}

case "$1" in
-i)
# call funcs
install_fonts
install_extensions

# theme instalation
if [ ! -d $ROUTE ];
then
  mkdir -p $ROUTE
fi

if [[ $2 && $2 != "all" ]];
then
  setup
  sed -i "s/_KIATORITHEME_/kiatori_$2/g" ./kiatori.dconf
  cp -r ./kiatori_darkred ./temp
  cp ./setup/gnome-shell_PATRON_.css ./temp/gnome-shell/gnome-shell.css
  sed -i "s/(_PRIMARY_COLOR_)/($2)/g" ./temp/gnome-shell/gnome-shell.css
  sed -i "s/_PRIMARY_COLOR_/${COLORS[$2]}/g" ./temp/gnome-shell/gnome-shell.css
  sed -i "s/#8a0000/${COLORSHEX[$2]}/g" ./temp/gnome-shell/assets/grad_bg_overview.svg
  sed -i "s/#8a0000/${COLORSHEX[$2]}/g" ./temp/gnome-shell/assets/grad_bg_popups.svg
  if [ -d $ROUTE/kiatori_$2 ];
  then
    rm -Rf $ROUTE/kiatori_$2
  fi 
  mv ./temp $ROUTE/kiatori_$2
  dconfig $2
elif [[ $2 && $2 == "all" ]];
# install all themes colors
then
  for i in ${!COLORS[@]}
  do
    if [ $i != "darkred" ];
    then
      $0 -i $i
    fi
  done
  $0 -i darkred # install default theme color
else
  $0 # generic response with help for unexpected errors.
fi
# restart gnome shell
# busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
;;
-r)
  # call funcs
  install_fonts
  install_extensions
  setup

  rndColor=$(echo $(od -txC -An -N3 /dev/random | tr \  -) | sed 's/-//g')
  a=$(echo $rndColor | cut -c 1-2 | tr '[:lower:]' '[:upper:]')
  b=$(echo $rndColor | cut -c 3-4 | tr '[:lower:]' '[:upper:]')
  c=$(echo $rndColor | cut -c 5-6 | tr '[:lower:]' '[:upper:]')
  r=$(echo "ibase=16; $a" | bc)
  g=$(echo "ibase=16; $b" | bc)
  b=$(echo "ibase=16; $c" | bc)
  if [[ $r && $g && $b ]];
  then
    echo "generating new theme whit a random color... #$rndColor"
    sed -i "s/_KIATORITHEME_/kiatori_$rndColor/g" ./kiatori.dconf
    cp -r ./kiatori_darkred ./temp
    cp ./setup/gnome-shell_PATRON_.css ./temp/gnome-shell/gnome-shell.css
    sed -i "s/(_PRIMARY_COLOR_)/($rndColor)/g" ./temp/gnome-shell/gnome-shell.css
    sed -i "s/_PRIMARY_COLOR_/rgba($r, $g, $b,/g" ./temp/gnome-shell/gnome-shell.css
    sed -i "s/#8a0000/\#$rndColor/g" ./temp/gnome-shell/assets/grad_bg_overview.svg
    sed -i "s/#8a0000/\#$rndColor/g" ./temp/gnome-shell/assets/grad_bg_popups.svg
    if [ -d $ROUTE/kiatori_$rndColor ];
    then
      rm -Rf $ROUTE/kiatori_$rndColor
    fi 
    mv ./temp $ROUTE/kiatori_$rndColor
    dconfig $rndColor
  else
    # echo "fail in the random color generation, trying again..."
    $0 -r
  fi
;;
-u)
  rm -Rf $ROUTE/kiatori_*
  notify-send "All Kiotari themes have been uninstalled." -i "gnome-logo-text-dark"
;;
*)
echo -e "\n||| Kiatori Gnome Shell Theme |||\n\nRun: ./install.sh -i all, random, or one of these colors: darkred, tomato, crimson, firebrick, orangered, darkolivegreen, forestgreen, darkcyan, dimgrey, midnightblue, royalblue, slateblue, seagreen, teal, or purple to install. Also you can use -u to uninstall all installed themes.\n"
exit 1
;;
esac
exit 0