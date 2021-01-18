## Notification e-mail

:global email "backup@foundation.loc"
:global user "backufoundation"
:global passwd "Password"
:global port "587"

# Name subject body
:global name subject

## Check for update
/system package update
set channel=current
check-for-updates
:delay 15s;
## Important note: "installed-version" was "current-version" on older Roter OSes
:if ([get installed-version] != [get latest-version]) do={
   /tool e-mail send to="$email" subject="Upgrading RouterOS on router $name $[/system identity get name]" body="Upgrading RouterOS on router $[/system identity get name] from $[/system package update get installed-version] to $[/system package update get latest-version] ($name)" start-tls=yes password=$passwd port=$port user=$user
   :log info ("Upgrading RouterOS on router $[/system identity get name] from $[/system package update get installed-version] to $[/system package update get latest-version] ($name)")     
   :delay 15s;
   install
} else={

   ## RouterOS latest, let's check for updated firmware
    :log info ("No RouterOS upgrade found, checking for HW upgrade...")
   /system routerboard
   :if ( [get current-firmware] != [get upgrade-firmware]) do={ 
      /tool e-mail send to="$email" subject="Upgrading firmware on router $name $[/system identity get name]" body="Upgrading firmware on router $[/system identity get name] from $[/system routerboard get current-firmware] to $[/system routerboard get upgrade-firmware]" start-tls=yes password=$passwd port=$port user=$user
      :log info ("Upgrading firmware on router $[/system identity get name] from $[/system routerboard get current-firmware] to $[/system routerboard get upgrade-firmware]")
      :delay 15s;
      upgrade
      :delay 180s;
      /system reboot
   } else={
   :log info ("No Router HW upgrade found")
   }
}
