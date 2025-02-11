#!/bin/bash
#title: CHOMTE.SH - active_recon
#description:   Automated and Modular Shell Script to Automate Security Vulnerability Reconnaisance Scans
#author:        mr-rizwan-syed
#==============================================================================

function active_recon(){
    
    techdetect(){
      [ -e $results/httpxmerge.csv ] && urls=($(csvcut -c url,tech $results/httpxmerge.csv | grep -i $1 | cut -d ',' -f 1))
      [ -e $results/httpxout.csv ] && urls=($(csvcut -c url,tech $results/httpxout.csv | grep -i $1 | cut -d ',' -f 1))
      urls+=($(csvcut -c Host,Category,App $webtech | grep -i $1 | cut -d ',' -f 1))
      result=$(printf "%s\n" "${urls[@]}")
      for url in $result; do
          echo $url | grep -oE "^https?://[^/]*(:[0-9]+)?"
      done
    }

    # techdetect function can be use to run with manual tools; see below examples; altough nuclei has automatic-scan feature now.
    
    wordpress_recon(){
        techdetect WordPress | anew $enumscan/wordpress_urls.txt -q &>/dev/null 2>&1
        if [ -s $enumscan/wordpress_urls.txt ];then
            echo -e ""
            [ ! -e $enumscan/wordpress_nuclei_results.txt ] && echo -e "${YELLOW}[*] Running Wordpress Recon\n${NC}"
            [ ! -e $enumscan/wordpress_nuclei_results.txt ] && echo -e "${BLUE}[*] nuclei -l $enumscan/wordpress_urls.txt -w ~/nuclei-templates/workflows/wordpress-workflow.yaml -o $enumscan/wordpress_nuclei_results.txt \n${NC}"
            [ ! -e $enumscan/wordpress_nuclei_results.txt ] && nuclei -l $enumscan/wordpress_urls.txt -w ~/nuclei-templates/workflows/wordpress-workflow.yaml -o $enumscan/wordpress_nuclei_results.txt
        #   [ ! -e $enumscan/*_wpscan_result.txt ] && interlace -tL $enumscan/wordpress_urls.txt -threads 5 -c "wpscan --url _target_ $wpscan_flags -o $enumscan/_cleantarget_wpscan_result.txt"
            echo -e "WordPress Recon: [$(cat $enumscan/wordpress_urls.txt | wc -l)]"
        fi
    }

    joomla_recon(){
        techdetect joomla | anew $enumscan/joomla_urls.txt -q &>/dev/null 2>&1
        if [ -s $enumscan/joomla_urls.txt ];then
            echo -e ""
            [ ! -e $enumscan/joomla_nuclei_results.txt ] && echo -e "${YELLOW}[*] Running Joomla Recon\n${NC}"
            [ ! -e $enumscan/joomla_nuclei_results.txt ] && echo -e "${BLUE}[*] nuclei -l $enumscan/joomla_urls.txt -w ~/nuclei-templates/workflows/joomla-workflow.yaml -o $enumscan/joomla_nuclei_results.txt\n${NC}"
            [ ! -e $enumscan/joomla_nuclei_results.txt ] && nuclei -l $enumscan/joomla_urls.txt -w ~/nuclei-templates/workflows/joomla-workflow.yaml -o $enumscan/joomla_nuclei_results.txt
            echo -e "Joomla Recon: [$(cat $enumscan/joomla_urls.txt | wc -l)]"
        fi
    }

    drupal_recon(){
        techdetect Drupal | anew $enumscan/drupal_urls.txt -q &>/dev/null 2>&1
        if [ -s $enumscan/drupal_urls.txt ];then
            echo -e ""
            [ ! -e $enumscan/drupal_nuclei_results.txt ] && echo -e "${YELLOW}[*] Running Drupal Recon\n${NC}"
            [ ! -e $enumscan/drupal_nuclei_results.txt ] && echo -e "${BLUE}[*] nuclei -l $enumscan/drupal_urls.txt -w ~/nuclei-templates/workflows/drupal-workflow.yaml -o $enumscan/drupal_nuclei_results.txt\n${NC}"
            [ ! -e $enumscan/drupal_nuclei_results.txt ] && nuclei -l $enumscan/drupal_urls.txt -w ~/nuclei-templates/workflows/drupal-workflow.yaml -o $enumscan/drupal_nuclei_results.txt
            echo -e "Drupal Recon: [$(cat $enumscan/drupal_urls.txt | wc -l)]"
        fi
    }

    jira_recon(){
        techdetect jira | anew $enumscan/jira_urls.txt -q &>/dev/null 2>&1
        if [ -s $enumscan/jira_urls.txt ];then
            echo -e ""
            [ ! -e $enumscan/jira_nuclei_results.txt ] && echo -e "${YELLOW}[*] Running Jira Recon\n${NC}"
            [ ! -e $enumscan/jira_nuclei_results.txt ] && echo -e "${BLUE}[*] nuclei -l $enumscan/jira_urls.txt -w ~/nuclei-templates/workflows/jira-workflow.yaml -o $enumscan/jira_nuclei_results.txt\n${NC}" 
            [ ! -e $enumscan/jira_nuclei_results.txt ] && nuclei -l $enumscan/jira_urls.txt -w ~/nuclei-templates/workflows/jira-workflow.yaml -o $enumscan/jira_nuclei_results.txt
            echo -e "Jira Recon: [$(cat $enumscan/jira_urls.txt | wc -l)]"
        fi
    }

    jenkins_recon(){
        techdetect jenkins | anew $enumscan/jenkins_urls.txt -q &>/dev/null 2>&1
        if [ -s $enumscan/jenkins_urls.txt ];then
            echo -e ""
            [ ! -e $enumscan/jenkins_nuclei_results.txt ] && echo -e "${YELLOW}[*] Running Jenkins Recon\n${NC}"
            [ ! -e $enumscan/jenkins_nuclei_results.txt ] && echo -e "${BLUE}[*] nuclei -l $enumscan/jenkins_urls.txt -w ~/nuclei-templates/workflows/jenkins-workflow.yaml -o $enumscan/jenkins_nuclei_results.txt\n${NC}" 
            [ ! -e $enumscan/jenkins_nuclei_results.txt ] && nuclei -l $enumscan/jenkins_urls.txt -w ~/nuclei-templates/workflows/jenkins-workflow.yaml -o $enumscan/jenkins_nuclei_results.txt
            echo -e "Jenkins Recon: [$(cat $enumscan/jenkins_urls.txt | wc -l)]"
        fi
    }

    azure_recon(){
        techdetect azure | anew $enumscan/azure_urls.txt -q &>/dev/null 2>&1
        if [ -s $enumscan/azure_urls.txt ];then
            echo -e ""
            [ ! -e $enumscan/azure_nuclei_results.txt ] && echo -e "${YELLOW}[*] Running Azure Recon\n${NC}"
            [ ! -e $enumscan/azure_nuclei_results.txt ] && echo -e "${BLUE}[*] nuclei -l $enumscan/azure_urls.txt -w ~/nuclei-templates/workflows/azure-workflow.yaml -o $enumscan/azure_nuclei_results.txt\n${NC}" 
            [ ! -e $enumscan/azure_nuclei_results.txt ] && nuclei -l $enumscan/azure_urls.txt -w ~/nuclei-templates/workflows/azure-workflow.yaml -o $enumscan/azure_nuclei_results.txt
            echo -e "Azure Recon: [$(cat $enumscan/azure_urls.txt | wc -l)]"
        fi
    }
    
    # Add your custom function here; Refer above

    auto_nuclei(){
        echo -e ""
        [[ ! -e $enumscan/nuclei_pot_autoscan.txt || $rerun == true ]] && echo -e "${YELLOW}[*] Running Nuclei Automatic-Scan\n${NC}"
        [[ ! -e $enumscan/nuclei_pot_autoscan.txt || $rerun == true ]] && echo "${BLUE}[#] nuclei -l $urlprobed $nuclei_flags -resume -as -silent | anew $enumscan/nuclei_pot_autoscan.txt ${NC}"
        [[ ! -e $enumscan/nuclei_pot_autoscan.txt || $rerun == true ]] && nuclei -l $urlprobed $nuclei_flags -resume -as -silent | anew $enumscan/nuclei_pot_autoscan.txt
        [ -s $enumscan/nuclei_pot_autoscan.txt ] && echo -e "Auto Nuclei: [$(cat $enumscan/nuclei_pot_autoscan.txt | wc -l)]"
    }

    full_nuclei(){
        echo -e ""
        [[ ! -e $enumscan/nuclei_full.txt || $rerun == true ]] && echo -e "${YELLOW}[*] Running Nuclei Full-Scan\n${NC}"
        [[ ! -e $enumscan/nuclei_full.txt || $rerun == true ]] && echo "${BLUE}[#] nuclei -l $urlprobed $nuclei_flags -resume -silent | anew $enumscan/nuclei_full.txt ${NC}"
        [[ ! -e $enumscan/nuclei_full.txt || $rerun == true ]] && nuclei -l $urlprobed $nuclei_flags -resume -silent | anew $enumscan/nuclei_full.txt
        [ -s $enumscan/nuclei_full.txt ] && echo -e "Full Nuclei: [$(cat $enumscan/nuclei_full.txt | wc -l)]"
    }


    wordpress_recon 2>/dev/null
    joomla_recon 2>/dev/null
    drupal_recon 2>/dev/null
    jira_recon 2>/dev/null
    jenkins_recon 2>/dev/null
    azure_recon 2>/dev/null

    auto_nuclei  2>/dev/null || echo -e "${BLUE}[*] Nuclei Automatic Scan on $potentialsdurls >> ${NC}$enumscan/nuclei_pot_autoscan.txt"

    [[ "$all" == true || $rerun == true ]] && full_nuclei  2>/dev/null|| echo -e "${BLUE}[*] Nuclei Full Scan on $urlprobed >> ${NC}$enumscan/nuclei_full.txt"

 
}
