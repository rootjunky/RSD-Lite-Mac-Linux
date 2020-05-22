#!/bin/sh
# Liboicl/RootJunky.com - Flash RSDLite ROM files on Linux
# Usage: rsd-flash [XML file]
function platform
{       platform=`uname`
        if [ $(uname -p) = 'powerpc' ]; then
        echo "[-] PowerPC is not supported."
        exit 1
        fi
 
        if [ "$platform" = 'Darwin' ]; then
        ADB="files/./adbosx"
        FASTBOOT="files/./fastbootosx"
        MD5SUM="md5 -r"
        version="OS X"
        else
        ADB="files/./adblinux"
        FASTBOOT="files/./fastbootlinux"
        MD5SUM="md5sum"
        version="Linux"
               
        fi
}

platform
	echo   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    echo   "    ___  ____  ____  _____    ____  ___  ____ ____  __  ________  _  _    "
    echo   "   / _ \/ _  \/ _  \/_  _/_  / / / / / \/ / //_/\ \/ / / __/ _  \/ \/ \   "
    echo   "  / , _/ |_| / |_| / / / / // / /_/ /    /  <    \  /_/ /_/ |_| / ,  , \  "
    echo   " /_/|_|\____/\____/ /_/  \___/\____/_/\_/_/\_/   /_/_/___/\____/_/ \/ \_\ "
    echo   "                                                                          "
    echo   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    echo "----------------------------------------------------------------------------"
	echo "Welcome to RSD Lite For Mac and Linux press enter to start your flash"
	echo "----------------------------------------------------------------------------"
    		    read \n
getValue(){
	val=$(echo "$1" | sed "s/.*$2=\"\([^\"]*\).*/\1/")
	echo "$val" | grep -q " "
	if [ $? -ne 1 ];then
		val=""
	fi
	echo "$val"
}
PATH=.:$PATH
if hash "$FASTBOOT" 2>/dev/null;then
	cat "$1" | grep step[^s] | while read -r line;do
		MD5=$(getValue "$line" "MD5")
		file=$(getValue "$line" "filename");
		op=$(getValue "$line" "operation");
		part=$(getValue "$line" "partition");
		var=$(getValue "$line" "var");
		if [ "$MD5" != "" ];then
			fileMD5=$($MD5SUM "$file" | sed 's/ \(.*\)//');
			if [ "$MD5" != "$fileMD5" ];then
				echo "$file: MD5 mismatch."
				exit 1;
			fi
		fi
		cmd=$(echo $FASTBOOT "$op" "$part" "$file" "$var" | sed -e 's/[[:space:]]/ /g')
		$cmd
	done
	echo "---------------------------------------------------------"
	echo "Please check for errors then press enter to reboot device"
	echo "---------------------------------------------------------"
    		    read \n
	$FASTBOOT reboot
else
	echo "fastboot not found. Please ensure it is in your path."
fi