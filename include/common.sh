#!/usr/bin/env bash
set -uo pipefail

function showhelp() {
    cat <<EOF
$(basename ${0})

----------------------------------------------------------------------------------------
Usage: ${0} <Synology Model Name> <Options>

Options: postupdate, noconfig, noclean, manual

- postupdate : Option to patch the restore loop after applying DSM 7.1.0-42661 Update 2, no additional build required.

- noconfig: SKIP automatic detection change processing such as SN/Mac/Vid/Pid/SataPortMap of user_config.json file.

- noclean: SKIP the 💊   RedPill LKM/LOAD directory without clearing it with the Clean command. 
           However, delete the Cache directory and loader.img.

- manual: Options for manual extension processing and manual dtc processing in build action (skipping extension auto detection)

Please type Synology Model Name after ./$(basename ${0})

- for jot mode

./$(basename ${0}) DS918+
./$(basename ${0}) DS3617xs
./$(basename ${0}) DS3615xs
./$(basename ${0}) DS3622xs+
./$(basename ${0}) DVA3221
./$(basename ${0}) DS920+
./$(basename ${0}) DS1621+
./$(basename ${0}) DS2422+
./$(basename ${0}) DVA1622
./$(basename ${0}) DS1520+ (Not Suppoted)
./$(basename ${0}) FS2500 (Not Suppoted)

- for jun mode

./$(basename ${0}) DS918+J                                                                                                      
./$(basename ${0}) DS3617xsJ                                                                                                    
./$(basename ${0}) DS3615xsJ                                                                                                    
./$(basename ${0}) DS3622xs+J                                                                                                   
./$(basename ${0}) DVA3221J                                                                                                     
./$(basename ${0}) DS920+J                                                                                                      
./$(basename ${0}) DS1621+J 
./$(basename ${0}) DS2422+J  
./$(basename ${0}) DVA1622J (Not Suppoted)
./$(basename ${0}) DS1520+J
./$(basename ${0}) FS2500J

EOF

}

# Function READ_YN, cecho                                                                                        
# Made by FOXBI                                                                                                               
# 2022.04.14                                                                                                                  
#                                                                                                                             
# ==============================================================================                                              
# Y or N Function                                                                                                             
# ==============================================================================                                              
READ_YN () { # $1:question $2:default                                                                                         
   read -n1 -p "$1" Y_N                                                                                                       
    case "$Y_N" in                                                                                                            
    y) Y_N="y"                                                                                                                
         echo -e "\n" ;;                                                                                                      
    n) Y_N="n"                                                                                                                
         echo -e "\n" ;;                                                                                                      
    q) echo -e "\n"                                                                                                           
       exit 0 ;;                                                                                                              
    *) echo -e "\n" ;;                                                                                                        
    esac                                                                                                                      
}                                                                                         

# ==============================================================================          
# Color Function                                                                          
# ==============================================================================          
cecho () {                                                                                
    if [ -n "$3" ]                                                                                                            
    then                                                                                  
        case "$3" in                                                                                 
            black  | bk) bgcolor="40";;                                                              
            red    |  r) bgcolor="41";;                                                              
            green  |  g) bgcolor="42";;                                                                 
            yellow |  y) bgcolor="43";;                                             
            blue   |  b) bgcolor="44";;                                             
            purple |  p) bgcolor="45";;                                                   
            cyan   |  c) bgcolor="46";;                                             
            gray   | gr) bgcolor="47";;                                             
        esac                                                                        
    else                                                                            
        bgcolor="0"                                                                 
    fi                                                                              
    code="\033["                                                                    
    case "$1" in                                                                    
        black  | bk) color="${code}${bgcolor};30m";;                                
        red    |  r) color="${code}${bgcolor};31m";;                                
        green  |  g) color="${code}${bgcolor};32m";;                                
        yellow |  y) color="${code}${bgcolor};33m";;                                
        blue   |  b) color="${code}${bgcolor};34m";;                                
        purple |  p) color="${code}${bgcolor};35m";;                                
        cyan   |  c) color="${code}${bgcolor};36m";;                                
        gray   | gr) color="${code}${bgcolor};37m";;                                
    esac                                                                            
                                                                                                                                                                    
    text="$color$2${code}0m"                                                                                                                                        
    echo -e "$text"                                                                                                                                                 
}   


function checkinternet() {

    echo -n "Checking Internet Access -> "
    nslookup github.com 2>&1 >/dev/null
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        cecho g "Error: No internet found, or github is not accessible"
        exit 99
    fi

}

function getlatestmshell() {

    echo -n "Checking if a newer mshell version exists on the repo -> "

    if [ ! -f $mshellgz ]; then
        curl -s --location "$mshtarfile" --output $mshellgz
    fi

    curl -s --location "$mshtarfile" --output latest.mshell.gz

    CURRENTSHA="$(sha256sum $mshellgz | awk '{print $1}')"
    REPOSHA="$(sha256sum latest.mshell.gz | awk '{print $1}')"

    if [ "${CURRENTSHA}" != "${REPOSHA}" ]; then
        echo -n "There is a newer version of m shell script on the repo should we use that ? [yY/nN]"
        read confirmation
        if [ "$confirmation" = "y" ] || [ "$confirmation" = "Y" ]; then
            echo "OK, updating, please re-run after updating"
            cp -f /home/tc/latest.mshell.gz /home/tc/$mshellgz
            rm -f /home/tc/latest.mshell.gz
            tar -zxvf $mshellgz
            echo "Updating m shell with latest updates"
            exit
        else
            rm -f /home/tc/latest.mshell.gz
            return
        fi
    else
        echo "Version is current"
        rm -f /home/tc/latest.mshell.gz
    fi

}

