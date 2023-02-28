#!/bin/bash
#title:         Chomtesh-Dependency-Installer

RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
NC=`tput sgr0`
wul=`tput smul`

command_exists() {
    command -v "$1" >/dev/null 2>&1
}


dependency_installer(){
    if ! command_exists python3; then
        echo "Installing python3"
        apt install python3 -y  > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: python3"
    fi

    if ! command_exists python3-pip; then
        echo "Installing python3-pip"
        apt install python3-pip -y  > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: python3-pip"
    fi

    if ! command_exists git; then
        echo "Installing git"
        apt install git -y > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: git"
    fi

    if ! command_exists nmap; then
        echo "Installing nmap"
        apt install nmap -y > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: nmap"
    fi

    if ! command_exists xsltproc; then
        echo "Installing xsltproc"
        apt install xsltproc -y > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: xsltproc"
    fi

    if ! command_exists dirsearch; then
        echo "Installing dirsearch"
        apt install dirsearch -y > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: dirsearch"
    fi

    if ! command_exists csvcut; then
        echo "Installing csvkit"
        pip install csvkit -y > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: csvkit"
    fi

    if ! command_exists subfinder; then
        echo "Installing Subfinder"
        go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: subfinder"
    fi

    if ! command_exists gau; then
        echo "Installing gau"
        go install github.com/lc/gau/v2/cmd/gau@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: gau"
    fi

    if ! command_exists waybackurls; then
        echo "Installing waybackurls"
        go install github.com/tomnomnom/waybackurls@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: waybackurls"
    fi

    if ! command_exists httpx; then
        echo "Installing httpx"
        go install github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: httpx"
    fi

    if ! command_exists anew; then
        echo "Installing anew"
        go install github.com/tomnomnom/anew@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: anew"
    fi

    if ! command_exists gf; then
        echo "Installing gf"
        go install github.com/tomnomnom/gf@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: gf"
        git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf
    fi

    if ! command_exists anew; then
        echo "Installing anew"
        go install github.com/tomnomnom/anew@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: anew"
    fi

    if ! command_exists qsinject; then
        echo "Installing qsinject"
        go install github.com/ameenmaali/qsinject@latestt > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: qsinject"
    fi

    if ! command_exists qsreplace; then
        echo "Installing qsreplace"
        go install github.com/tomnomnom/qsreplace@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: qsreplace"
    fi
        
    if ! command_exists subjack; then
        echo "Installing subjack"
        go install github.com/haccer/subjack@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: subjack"
    fi

    if ! command_exists webanalyze; then
        echo "Installing webanalyze"
        go install github.com/rverton/webanalyze/cmd/webanalyze@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: webanalyze"
    fi    

    if ! command_exists nuclei; then
        echo "Installing nuclei"
        go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: nuclei"
        nuclei -update
    fi

    if ! command_exists dmut; then
        echo "Installing dmut"
        go install github.com/bp0lr/dmut@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: dmut"
    fi

    if ! command_exists nuclei; then
        echo "Installing nuclei"
        go install github.com/bp0lr/dmut@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: nuclei"
        nuclei -update
        nuclei -ut 
    fi

    if ! command_exists naabu; then
        echo "Installing naabu"
        # If Naabu is not getting installed by below command, download the compiled binary from official naabu github release page. 
        go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest > /dev/null 2>&1 | pv -p -t -e -N "Installing Tool: naabu"
    fi    
}

required_tools=("python3" "subfinder" "naabu" "httpx" "csvcut" "dmut" "dirsearch" "nuclei" "nmap" "ansi2html" "xsltproc" "anew")
missing_tools=()
for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" &> /dev/null 2>&1; then
        missing_tools+=("$tool")
        echo "Dependency '$tool' not found, installing..."
    fi
done

if [ ${#missing_tools[@]} -ne 0 ]; then
    echo -e ""
    echo -e "${RED}[-]The following tools are not installed:${NC} ${missing_tools[*]}"
    dependency_installer
    exit 1
fi



   

    









