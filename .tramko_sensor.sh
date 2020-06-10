#!/bin/bash
        . $TRAMKO_HOME/.bash_profile
        . /home/oracle/.bashrc
        #export WHENCHANGED_DATE=$(date '+%Y%m%d%H%M'00.0Z)
        export VON_WHENCHANGED_DATE=$(date  --date="last day" '+%Y%m%d'000000.0Z)
        export BIS_WHENCHANGED_DATE=$(date '+%Y%m%d'000000.0Z)
        oid-env
    BIN=$ORACLE_HOME/bin
    $BIN/ldapsearch -vvv -h ad -p 389 -D "$AD_DOMAIN\$AD_ADMIN" -w $AD_SECRET -b "$AD_BASE" -s sub "(&(whenChanged>=${VON_WHENCHANGED_DATE})(whenChanged<=${BIS_WHENCHANGED_DATE})(objectClass=user)(objectCategory=person))" samaccountname 2>/dev/null | grep -i ^samaccountname | awk -F= '{print $2}' | tr [:lower:] [:upper:] >  /tmp/adch-users.list
#        date >> /tmp/sso-ad-getchanged-day.log
#        cat /tmp/adch-day-users.list >> /tmp/sso-ad-getchanged-day.log
        scp /tmp/adch-users.list erprodapp01.housing.gov.sa:/tmp/uu-user

        sso-AD_WhenChanged-fix
        sso-sync
        sso-update-EBS-GUID
