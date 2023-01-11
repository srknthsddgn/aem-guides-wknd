#!/bin/bash
TIME=`date +%d%m%Y_%H%M`
                           cd /var/lib/jenkins/workspace/Test_1
                           mkdir zipfiles
                           find . -name "*.zip" -not -path "./zipfiles/*" -exec cp -rf {} zipfiles \;
                           cd zipfiles
                           find . -name "*.zip" -exec basename {} .zip \; >> filenames
                           file=filenames
                           #Dev Environment Details
                           Author_Host="172.16.1.149"
                           Author_Port="4502"
                           User="admin"
                           Passwd="admin"
                           # Package Manager URL of the AEM.
                           URL="/crx/packmgr/service.jsp"
                           echo
                           echo " Installing Pakage on Author"
                           echo
                           while IFS= read -r LINE; do
                           curl -u $User:$Passwd -F file=@$LINE.zip -F name=$LINE -F force=true -F install=true http://$Author_Host:$Author_Port$URL
                           if [ $? -eq 0 ] ; then
                                 echo "Installing Package on Author is Sucess" >> /tmp/jenkinslog
                           else
                                 echo "Installing Package on Author Failed" 1>&2 >> /tmp/jenkinslog
                           fi
                           done < "$file"
