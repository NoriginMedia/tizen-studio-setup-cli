# tizen-studio-setup-cli
This repo is for Tizen Studio IDE

## Prerequisites
-For Tizen Studio, you must install the Java Development Kit (JDK) version 8 or higher from [here](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html).

## How to use?
-Download or copy the script in some folder.

-Make the file executable by running:
`chmod +x tizenSetupCli.sh`

-Run the script by
`./tizenSetupCli.sh.sh`

## About the Script
The script has 3 option,

1.Install
   It will install the latest version 4.1 of Tizen studio and launch the IDE after installation. IF you already have Tizen Studio installed then selecting this option will launch the IDE.
   It also installs the additional packages that are required for native development.
   -Samsung Certificate Extension
   -TV Extension Tools        
   -TV Extensions-* (Where * is the version)

2.Update
  It will update the Tizen Studio to the latest version if you already have some old version installed and launch the IDE after the update.

3.Generate Signed Tizen Widget
  It will create a .wgt file for your Tizen application and you can use that to make a widget for your app. In order to generate a .wgt file, you will be asked to provide security profile name, to sign the widget and path to your app's widget folder. 

  For security profile name, a list of your security profiles (if you have any) will be shown and you can choose the profile name from this list.

  Path to the widget folder, it's mandatory, .wgt file be generated only if you provide the correct location to your app's widget folder.
  






