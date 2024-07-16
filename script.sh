#!/usr/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if assetfinder is installed; if not, install it
if ! command_exists "assetfinder"; then
    echo "Installing assetfinder..."
    sudo apt install -y assetfinder
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install assetfinder."
        exit 1
    fi
fi

# Check if httprobe is installed; if not, install it
if ! command_exists "httprobe"; then
    echo "Installing httprobe..."
    sudo apt install -y httprobe
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install httprobe."
        exit 1
    fi
fi

# Display ASCII art in red
echo -e "\e[31m------------------------------------------------------------------------------
|                                :...::::::::---==::::                       |
|                             :...:.::::::::-:-===++:::                      |
|                          ..:.....::::----:::::---=*+%                      |
|                         ::::::::::::+:::::::---==+**#                      |
|                        ::::::::::::*#*=-=-:::=-=+=+**                      |
|                        ::::::::::::*@@%#**++=--==+*##=                     |
|                         ::-=::::--::-%@@@%%####***###=                     |
|                         :--=:+%@@@@#-:*@@@%%++*+#%%#+                      |
|                         :=*#*#%%@@@@%-:..::=**%#=@@*                       |
|                         =%@#:-=*#%%@@-::=*@%%#*#@%%*                       |
|                           #%*::--===-::=#%@%#%@@##                         |
|                 ----++=*  +%%@*::*#%@%%@@%++=#@%##                         |
|               -+=%#**##@#=-+#%%*::-*#%%@@%=-:=%%@ #                        |
|              =**#-----==#@+**#-:::-=++#%@%-:--*%%%                         |
|              +**=======-=#%= ===-::-*++#+::-+%%%#*#%#                      |
|             =**+========-+%*  +*+==----::-*%%%%%#*++*%%                    |
|              =%@=======--*+*    :-:::-+    ## %#=-*%%%*+  :==-             |
|                #@%++-:-+*-%     -++==#      *%#%%*-=%%%+-=+**-.::.:        |
|         -       **#@@@@@@                #+#%*=--+*+=-:-=#%.::::::-=:      |
|       --- :--:  ###%                ++*%%##%@###+::-:-*%%%=:::::::-==      |
|        =-=#%#*+=-:*  =           +#+=@%%#=-.::-=--::=*%%%%-:::::::-+*:     |
|       ++=+=-:-+%%*=+++            ===**#%%%#::..::::=*%%%%+--::++=*%#=     |
|      ####%%%%#=-+@%*=           ###*+-::...::--:::::==%%@@@#*+*###%%*+     |
|      *=--====*@%++ @            #==*@@@#%@     +::::-=+%%%%%**-*%#%%#      |
|       %#**#%#+*%*+              +*+=:-===-...:-=+#@%=-==#%%%%%=-@-#%*      |
|       *%%%@@@##+=               #**@@%#**#%%@#++*%#**%*==+%%%@+-@-##       |
|        %%@@%@@@#++            +=***--=+*****+=---=+#%@@%#++#%@+-%=#*       |
|        #%@%%@@%%*=             ##*%%#**+++++*##%%%%%%#%%@@#**%+=%-#        |
|         %*#%%%%%##+           *+**+-=+*#%%%%%#*+++*#%@@%%%@@%#+=%-#        |
|         =*%%%@%%###=+-         *##%%#**+++++**#%%%%%%%%%@@@@  :=%=#        |
|        =*#%%%%%%%#*#**         #*#%**#%%%%%%%%%#####%%@%%@%   :=%=#        |
|       =+##%    %%%*+#*+        **###%%###***###%%%%%%%%@@ %   :=%=*        |
|      +%@%%#       @%*#*+=       %%##%%@@@@@%%%%%###%@@@       :=%+*        |
|        ###         %%#***+=    %%%@%%#########%%%@@%@@        -=*+*        |
|                     %@#**+#*++=+%%%%%%        @%%%@@@        -==+#*        |
|                      %%%*#* ###%%#%%%%#####%%%%@%%@@       --==*%#*+       |
|                       %%%*%#  #%%%%%%@       *%%@@%        =#+#***%%       |
|    ░██████╗██╗░░░██╗██████╗░██╗░░░░░██╗███████╗████████╗██████╗░██████╗░   |
|    ██╔════╝██║░░░██║╚════██╗██║░░░░░██║██╔════╝╚══██╔══╝╚════██╗██╔══██╗   |
|    ╚█████╗░██║░░░██║░█████╔╝██║░░░░░██║██████╗░░░░██║░░░░█████╔╝██████╔╝   |
|    ░╚═══██╗██║░░░██║░╚═══██╗██║░░░░░██║╚════██╗░░░██║░░░░╚═══██╗██╔══██╗   |
|    ██████╔╝╚██████╔╝██████╔╝███████╗██║██████╔╝░░░██║░░░██████╔╝██║░░██║   |
|    ╚═════╝░░╚═════╝░╚═════╝░╚══════╝╚═╝╚═════╝░░░░╚═╝░░░╚═════╝░╚═╝░░╚═╝   |
------------------------------------------------------------------------------ \e[0m"
echo -e "\e[34m* This tool is developed for finding all subdomains of specified domains"
echo -e "* Tool developed by x-Error404-x"
echo -e "* Active user: $USER\e[0m"
echo ""


# Prompt user for domain name
read -p "Enter the Domain: " var

# Validate domain name
if [[ -z "$var" ]]; then
    echo "Error: Domain name cannot be empty."
    exit 1
fi

# Perform subdomain scanning
echo "Scanning subdomains for $var"
echo ""
assetfinder "$var" > list
wc -l list > no1
awk '{print $1}' no1 > status
echo -n -e "\e[33m$(cat status) \e[0m" && echo -e "\e[33mUnfiltered domains found\e[0m"
sleep 1
echo "Filtering,Please wait..."
cat list | httprobe > live
echo "Removing replicated urls,Please wait..."
sort -u live > $var.txt

wc -l $var.txt > no1
awk '{print $1}' no1 > status
echo -n -e "\e[32m$(cat status) \e[0m" && echo -e "\e[32mAlive domains found\e[0m"
sleep 1
echo -e "File saved as \e[31m$var.txt\e[0m"
echo "Cleaning up junks files..."
rm list live no1 status
sleep 1
echo ""

cat $var.txt

