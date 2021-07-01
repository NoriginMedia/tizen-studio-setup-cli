#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
DGREY='\033[1;30m' #Dark Grey
NC='\033[0m' #No Color
export PATH=$PATH:~/tizen-studio/tools/ide/bin/

PATH_SECURITY_PROFILES=~/tizen-studio-data/profile/profiles.xml

confirm() {
    read -r -p "${1:-$1 [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            printf "\n$DGREY $2 $NC\n"
            eval $3
            ;;
        *)
            false
            ;;
    esac
}

generateSignedWidget() {
        read -r -p "Enter security profile name: " profile
        read -r -p "Path to your application's Tizen folder: " buildPath
        if [[ `tizen package -t wgt -s $profile -- $buildPath` == *"Specify location of the working directory"* ]]
           then  printf "\n${RED}Incorrect Path!!!\nSpecify correct location of the Tizen folder. $NC\n\n"
        else 
           printf "\n${DGREY}Generating signed widget... $NC\n\n"
           tizen package -t wgt -s $profile -- $buildPath
        fi
}

installAditionalPackages() {
            printf "\n${DGREY}Installing 3 additional packages...$NC\n"
            cd ~/tizen-studio/package-manager
            ./package-manager-cli.bin install cert-add-on --accept-license
            printf "\n$GREEN ## [1/3] Installed! ## $NC\n"
            ./package-manager-cli.bin install TV-SAMSUNG-Extension-Tools --accept-licens
            printf "\n$GREEN ## [2/3] Installed! ## $NC\n"
            ./package-manager-cli.bin install TV-SAMSUNG-Public --accept-license
            printf "\n$GREEN ## [3/3] Installed! ## $NC\n"
}

installTizenStudioIDE() {
    printf "\n${DGREY}Select the OS type to begin the installation $NC\n"
         PS3='Your choice? '
         OPTIONS=("Mac" "Windows" "Exit")
         select choice in "${OPTIONS[@]}"; do
         case $choice in
            "Mac")
                printf "\n${DGREY}Installing latest version 4.1$NC\n"
                curl http://download.tizen.org/sdk/Installer/tizen-studio_4.1/web-cli_Tizen_Studio_4.1_macos-64.bin? -O
                chmod 700 *web-cli_Tizen_Studio_4.1_macos-64.bin*
                ./web-cli_Tizen_Studio_4.1_macos-64.bin? --accept-license

                #This function is called to installed some additional packages that are required for native app development
                installAditionalPackages

                printf "\n$GREEN ## Installation Done! Launching IDE... ## $NC\n"
                open ~/tizen-studio/TizenStudio.app
            break
                ;;
            
            "Windows")
              #TODO Windows version of the script
                printf "\n${DGREY}Installing latest version 4.1$NC\n"
                curl http://download.tizen.org/sdk/Installer/tizen-studio_4.1/web-cli_Tizen_Studio_4.1_windows-64.exe? -O
              
                #This function is called to installed some additional packages that are required for native app development
                installAditionalPackages

                printf "\n$GREEN ## Installation Done! Launching IDE... ## $NC\n"
                open ~/tizen-studio/TizenStudio.app  #TODO fix the open command for windows 
            break
                ;;
            
            "Exit") 
                confirm "Are you sure?" "Exiting..." exit
                ;;
            *) printf "\n$RED Invalid Option!!!$NC\n";;
        esac
        done
}

updateVersion() {
    printf "\n${DGREY}Updating Tizen Studio to the latest version...$NC\n"
    cd ~/tizen-studio/package-manager
    ./package-manager-cli.bin update --accept-license --latest
    open ~/tizen-studio/TizenStudio.app
}

PS3='What do you want to do? '
OPTIONS=("Install" "Update" "Generate Signed Tizen Widget" "Quit")
select choice in "${OPTIONS[@]}"; do
    case $choice in
        "Install")
        if [[ ! -z `ls ~ /usr | egrep '^tizen'` ]]
           then  printf "\n${GREEN}Already installed, launching IDE $NC\n\n"
           open ~/tizen-studio/TizenStudio.app
        else 
           installTizenStudioIDE
        fi
        break
            ;;
        
        "Update") 
        if [[ ! -z `ls ~ /usr | egrep '^tizen'` ]]
          then updateVersion
        else 
           printf "\n${RED}Tizen Studio not installed, installing latest version $NC\n\n"
           installTizenStudioIDE
        fi
            break
            ;;

        "Generate Signed Tizen Widget")
            profiles=`tizen security-profiles list`
            activeProfile=`sed -n '/profileitem/{s/.*<profileitem>//;s/<\/profileitem.*//;p;}' "$PATH_SECURITY_PROFILES"
`
           if [[ "$profiles" != *"Not found"* ]] && [ ! -z "$activeProfile" ]
           then 
           printf "\n${DGREY}Your security profiles \n$profiles $NC\n"
            generateSignedWidget
           else printf "\n${RED} No security profile found, open Tizen Certificate Manager to create certificate profile.$NC\n"
           fi
            break
            ;;

        "Quit")
            confirm "Are you sure?" "Exiting..." exit
            ;;

      *) printf "\n$RED Invalid Option!!! $NC\n";;
    esac
done