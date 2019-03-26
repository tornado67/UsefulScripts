 #remove tabs also
 sed -i -e '/\t/d' -e 's/#.*//' -e '/^$/d'  /etc/freeradius/3.0/users
 
 #do not remove tabs
  sed -i -e 's/#.*//' -e '/^$/d'  /etc/freeradius/3.0/users
