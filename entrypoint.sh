#!/bin/bash

USER_ID=${USER_ID:-0}
GROUP_ID=${USER_GROUPS:-0}
CWD=${CWD:-$(pwd)}

# Create user account
if [ $USER_ID != 0 ]; then

   if ! [ -n "$USER" ]; then
      USER=$USER_ID
   fi

   if [ -z "$USER_HOME" ]; then
      export USER_HOME=/$USER
   fi

   if [ -z "$USER_ID" ]; then
      export USER_ID=$USER_ID
   fi

   if [ -z "$GROUP_ID" ]; then
      export GROUP_ID=$GROUP_ID
   fi

   adduser --home "$USER_HOME" --uid "$USER_ID" --disabled-password --gecos "" "$USER" > /dev/null

   if [ -n "$USER_ENCRYPTED_PASSWORD" ]; then
      echo "$USER:$(openssl passwd -1 ${USER_ENCRYPTED_PASSWORD})" | chpasswd
      # useradd -d $USER_HOME -m -p $USER_ENCRYPTED_PASSWORD -u $USER_ID $USER > /dev/null
   else
      echo "$USER:$(openssl passwd -1 'Docker!')" | chpasswd
      # useradd -d $USER_HOME -m -p "Docker!" -u $USER_ID $USER > /dev/null
   fi

   # expects a comma-separated string of the form GROUP1:GROUP1ID,GROUP2,GROUP3:GROUP3ID,...
   # (the GROUPID is optional, but needs to be separated from the group name by a ':')
   for i in $(echo $USER_GROUPS | sed "s/,/ /g")
   do
      if [[ $i == *":"* ]]
      then
	 addgroup ${i%:*} # > /dev/null
         groupmod -g ${i#*:} ${i%:*} #> /dev/null
         adduser $USER ${i%:*} #> /dev/null
      else
         addgroup $i > /dev/null
         adduser $USER $i > /dev/null
      fi
   done

   # set correct primary group
   if [ -n "$USER_GROUPS" ]; then
      group="$( cut -d ',' -f 1 <<< "$USER_GROUPS" )"
      if [[ $group == *":"* ]]
      then
         usermod -g ${group%:*} $USER &
      else
         usermod -g $group $USER &
      fi
   fi

   # give sudo permissions to user by adding him to wheel group
   adduser ${USER} wheel

   # enable passwordless sudo
   echo "$USER_ID       ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
   #chown -f -R $USER_ID:$USER_ID /root || true

  cd $USER_HOME

  # setup nvim for new user
  cp -f -r /root/.config $USER_HOME/.config
  chown -f -R $USER_ID:$USER_ID $USER_HOME/.config

  if [ -n $CWD ]; then cd $CWD; fi
  echo "Running as user $USER."

  if [[ $@ == "" ]]
  then
      exec /usr/local/bin/gosu $USER "sh"
  else
      exec /usr/local/bin/gosu $USER "$@"
  fi

else
  if [ -n $CWD ]; then cd $CWD; fi
  echo "Running as default container user."

  if [[ $@ == "" ]]
  then
      exec "sh"
  else
      exec "$@"
  fi

fi
