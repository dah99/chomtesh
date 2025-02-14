#!/bin/bash
#title: CHOMTE.SH - recon_url
#description:   Automated and Modular Shell Script to Automate Security Vulnerability Reconnaisance Scans
#author:        mr-rizwan-syed
#==============================================================================

recon_url(){
    echo -e ""
    echo -e "${YELLOW}[*] Performing JS Recon from Webpage and Javascript on $domain ${NC}"
    ## Thanks to @KathanP19 and Other Community members
    passivereconurl(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC} "' SIGINT
        
        [ ! -e $enumscan/URLs/gau-allurls.txt ] && echo -e "${BLUE}[*] Gathering URLs - Passive Recon using Gau >>${NC} $enumscan/URLs/gau-allurls.txt"
        [ ! -e $urlprobedsd ] && cat $urlprobed | awk -F[/:] '{print $4}' | anew $urlprobedsd -q &>/dev/null 2>&1
        [ ! -e $enumscan/URLs/gau-allurls.txt ] && interlace --silent -tL $urlprobedsd -o $enumscan -cL ./MISC/passive_recon.il 2>/dev/null | pv -p -t -e -N "Gathering URLs from Gau" >/dev/null
        
        [ ! -e $enumscan/URLs/subjs-allurls.txt ] && echo -e "${BLUE}[*] Gathering URLs - Passive Recon using Subjs >>${NC} $enumscan/URLs/subjs-allurls.txt"
        [ ! -e $enumscan/URLs/subjs-allurls.txt ] && interlace --silent -tL $urlprobed -o $enumscan -c "echo _target_ | subjs | anew _output_/URLs/subjs-allurls.txt -q" 2>/dev/null | pv -p -t -e -N "Gathering JS URLs from Subjs" >/dev/null
    }
    activereconurl(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/katana-allurls.txt ] && echo -e "${BLUE}[*] Gathering URLs - Active Recon using Katana >>${NC} $enumscan/URLs/katana-allurls.txt"
        [ ! -e $enumscan/URLs/katana-allurls.txt ] && katana -list $urlprobed -d 10 -c 50 -p 20 -ef "ttf,woff,woff2,svg,jpeg,jpg,png,ico,gif,css" -jc -kf robotstxt,sitemapxml -aff --silent | anew $enumscan/URLs/katana-allurls.txt -q | pv -p -t -e -N "Katana is running" >/dev/null
    }

    pot_url(){
        alluc=$(cat $enumscan/URLs/*-allurls.txt | wc -l)
        echo -e "${GREEN}${BOLD}[$] All URLs Gathered ${NC}[$alluc] [$enumscan/URLs/*-allurls.txt]"
        
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        
        [ ! -e $enumscan/URLs/potentialurls.txt ] && echo -e "${BLUE}[*] Taking out Potential URLs >>${NC} $enumscan/URLs/potentialurls.txt"
        [ ! -e $enumscan/URLs/potentialurls.txt ] && cat $enumscan/URLs/*-allurls.txt | gf excludeExt | anew $enumscan/URLs/potentialurls.txt -q &>/dev/null 2>&1
        
        potuc=$(<$enumscan/URLs/potentialurls.txt wc -l)
        echo -e "${GREEN}[$] Total Potential URLs ${NC}[$potuc]"
        
        [ ! -e $enumscan/URLs/paramurl.txt ] && echo -e "${BLUE}[*] QSInjecting Unique parameter URLs >>${NC} $enumscan/URLs/paramurl.txt"
        [ ! -e $enumscan/URLs/paramurl.txt ] && cat $enumscan/URLs/potentialurls.txt | qsinject -c MISC/qs-rules.yaml 2>/dev/null | anew $enumscan/URLs/paramurl.txt -q &>/dev/null
        
        purl=$(<$enumscan/URLs/paramurl.txt wc -l)
        echo -e "${GREEN}${BOLD}[$] Unique parameter URLs ${NC}[$purl] [$enumscan/URLs/paramurl.txt]"
    }

    jsextractor(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/alljsurls.txt ] && echo -e "${BLUE}[*] Extracting JS URLs >>${NC} $enumscan/URLs/*-allurls.txt"
        [ ! -e $enumscan/URLs/alljsurls.txt ] && cat $enumscan/URLs/*-allurls.txt | egrep -iv '\.json' | grep -iE "\.js$" | anew $enumscan/URLs/alljsurls.txt -q &>/dev/null 2>&1
        ajsuc=$(<$enumscan/URLs/alljsurls.txt wc -l)
        echo -e "${GREEN}${BOLD}[$] All JS URLs Gathered ${NC}[$ajsuc] [$enumscan/URLs/alljsurls.txt]"
    }

    validjsurlextractor(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/validjsurls.txt ] && echo -e "${BLUE}[*] Finding All Valid JS URLs >>${NC} $enumscan/URLs/validjsurls.txt"
        [ ! -e $enumscan/URLs/validjsurls.txt ] && cat $enumscan/URLs/alljsurls.txt| python3 ./MISC/antiburl.py -N 2>&1 | grep '^200' | awk '{print $2}' | anew $enumscan/URLs/validjsurls.txt -q 2>/dev/null | pv -p -t -e -N "Finding All Valid JS URLs" >/dev/null
        vjsuc=$(<$enumscan/URLs/validjsurls.txt wc -l)
        echo -e "${GREEN}${BOLD}[$] Valid JS URLs Extracted ${NC}[$vjsuc] [$enumscan/URLs/validjsurls.txt]"
    }

    endpointsextractor(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/endpointsfromjs.txt ] && echo -e "${BLUE}[*] Enumerating Endpoints from valid JS files >> ${NC}$enumscan/URLs/endpointsfromjs.txt"
        [ ! -e $enumscan/URLs/endpointsfromjs.txt ] && interlace --silent -tL $enumscan/URLs/validjsurls.txt -c "python3 ./MISC/LinkFinder/linkfinder.py -d -i '_target_' -o cli | anew -q $enumscan/URLs/endpointsfromjs_tmp.txt" 2>/dev/null | pv -p -t -e -N "Enumerating Endpoints from valid js files" >/dev/null
        [ -e $enumscan/URLs/endpointsfromjs_tmp.txt ] && cat $enumscan/URLs/endpointsfromjs_tmp.txt | grep -vE 'Running against|Invalid input' | anew $enumscan/URLs/endpointsfromjs.txt -q 2>/dev/null && rm $enumscan/URLs/endpointsfromjs_tmp.txt
    }

    secretsextractor(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/secretsfromjs.txt ] && echo -e "${BLUE}[*] Enumerating Secrets from valid JS files >> ${NC}$enumscan/URLs/secretsfromjs.txt"
        [ ! -e $enumscan/URLs/secretsfromjs.txt ] && interlace --silent -tL $enumscan/URLs/validjsurls.txt -c "python3 MISC/SecretFinder/SecretFinder.py -i '_target_' -o cli 2>/dev/null| anew $enumscan/URLs/secretsfromjs.txt" 2>/dev/null | pv -p -t -e -N "Enumerating Secrets from valid js files" >/dev/null
    }

    domainfromjsextractor(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/domainfromjs.txt ] && echo -e "${BLUE}[*] Enumerating Domains from valid JS files >> ${NC}$enumscan/URLs/domainfromjs.txt"
        [ ! -e $enumscan/URLs/domainfromjs.txt ] && interlace --silent -tL $enumscan/URLs/validjsurls.txt -c "python3 MISC/SecretFinder/SecretFinder.py -i '_target_' -o cli  -r "\S+$domain" 2>/dev/null | anew $enumscan/URLs/domainfromjs.txt" 2>/dev/null | pv -p -t -e -N "Enumerating Domain from valid js files" >/dev/null
    }

    wordsfromjsextractor(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/wordsfromjs.txt ] && echo -e "${BLUE}[*] Gathering Words from valid JS files >> ${NC}$enumscan/URLs/wordsfromjs.txt"
        [ ! -e $enumscan/URLs/wordsfromjs.txt ] && cat $enumscan/URLs/validjsurls.txt | python3 ./MISC/getjswords.py 2>/dev/null | anew $enumscan/URLs/wordsfromjs.txt 2>/dev/null| pv -p -t -e -N "Gathering words from valid js files" >/dev/null
    }
    varjsurlsextractor(){
        trap 'echo -e "${RED}Ctrl + C detected, Thats what she said${NC}"' SIGINT
        [ ! -e $enumscan/URLs/varfromjs.txt ] && echo -e "${BLUE}[*] Gathering Variables from valid JS files >> ${NC}$enumscan/URLs/varfromjs.txt"
        [ ! -e $enumscan/URLs/varfromjs.txt ] && interlace --silent -tL $enumscan/URLs/validjsurls.txt -c "bash ./MISC/jsvar.sh _target_ 2>/dev/null | anew $enumscan/URLs/varfromjs.txt" 2>/dev/null | pv -p -t -e -N "Gathering Variables from valid js files" >/dev/null
    }
    if [ -s $urlprobed ]; then
        passivereconurl
        activereconurl
    fi  
    if [ -s $enumscan/URLs/gau-allurls.txt ]; then
        jsextractor
        pot_url
        validjsurlextractor
    fi
    if [ -s $enumscan/URLs/validjsurls.txt ]; then
        endpointsextractor
        secretsextractor
        domainfromjsextractor
        wordsfromjsextractor
        varjsurlsextractor
    fi
}

nuclei_fuzzer(){
    echo -e "${YELLOW}[*] Running Nuclei Fuzzer"
    [[ -s $enumscan/URLs/paramurl.txt ]] && echo -e "${BLUE}[#] nuclei -silent -t MISC/fuzzing-templates -list $enumscan/URLs/paramurl.txt | anew $enumscan/URLs/nuclei_fuzzing_results.txt ${NC}" 
    [[ -s $enumscan/URLs/paramurl.txt ]] && nuclei -silent -t MISC/fuzzing-templates -list $enumscan/URLs/paramurl.txt | anew $enumscan/URLs/nuclei_fuzzing_results.txt
}

xnl(){
    echo -e "${YELLOW}[*] Runing Waymore on $domain"
    echo -e "${BLUE}[#] python3 ./MISC/waymore/waymore.py -i $domain -mode B -oU $enumscan/URLs/waymore.txt -oR $enumscan/URLs/waymoreResponses/\n${NC}" 
    [ ! -f $enumscan/URLs/waymore.txt ] && python3 ./MISC/waymore/waymore.py -i $domain -mode B -oU $enumscan/URLs/waymore.txt -oR $enumscan/URLs/waymoreResponses/
    
    echo -e "${YELLOW}[*] Running xnLinkFinder"
    echo -e "${BLUE}[#] python3 ./MISC/xnLinkFinder/xnLinkFinder.py -i $enumscan/URLs/waymoreResponses/ -sp $urlprobed -sf $domain -o $enumscan/URLs/xnLinkFinder_links.txt -op $enumscan/URLs/xnLinkFinder_parameters.txt -owl $enumscan/URLs/xnLinkFinder_wordlist.txt \n${NC}" 
    [ -d $enumscan/URLs/waymoreResponses ] && python3 ./MISC/xnLinkFinder/xnLinkFinder.py -i $enumscan/URLs/waymoreResponses/ -sp $urlprobed -sf $domain -o $enumscan/URLs/xnLinkFinder_links.txt -op $enumscan/URLs/xnLinkFinder_parameters.txt -owl $enumscan/URLs/xnLinkFinder_wordlist.txt 
    
    echo -e "${YELLOW}[*] Extracting Secrets from WayMoreResponses"
    echo -e "${BLUE}[#] trufflehog filesystem $enumscan/URLs/waymoreResponses --only-verified | anew -q $enumscan/URLs/trufflehog-results.txt\n${NC}" 
    [ -d $enumscan/URLs/waymoreResponses ] && trufflehog filesystem $enumscan/URLs/waymoreResponses --only-verified | anew -q $enumscan/URLs/trufflehog-results.txt
}

