:log info "Mikrotik Backup JOB Started . . . By jnz"
:global backupfile Config
:global date [/sys clock get date];
:global time [/sys clock get time];

# Name subject body
:global name subject

# Sending from smtp
:global fromto backupsender@gmail.com
:global user backupsender
:global passwd Password
:global port 587

# Sending in
:global mail backup@foundation.loc

:log info "Creating file..."
/system backup save name=$backupfile

:log info "Backup process pausing for 10s so it complete creating backup file"
:delay 10s
:log info "Start sending Backup file to email using GMAIL SMTP ..."
/tool e-mail
send to=$mail subject="Backup configuration $name $date $time" body="Backup Mikrotik $name" start-tls=yes from=$fromto password=$passwd port=$port user=$user file=$backupfile 

:delay 10s

:log info "Deleting Backup File. All Done."
/file remove $backupfile

:log info "Success"
