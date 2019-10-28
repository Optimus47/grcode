#
# SERVER NET LOAD ALERT SCRIPT
#
# Send alert to admin if interface traffic load is down
#
# Install bwm-ng package
# Install senEmail package
#
# Specials:
# bwm-ng count to mbit convert formula is:
# load=count*8/1000000 
#
# setup mbit low limit:
LIMIT=10
#
# setup admin e-mail:
ALERT=admin@localhost
#
LOG=$HOME/.srvntload.log
#
GU="pick@tick"
GP="tiki-took"

rules_check=$(echo $LIMIT Mbit low limit.)
limit_check=$(bwm-ng -o csv -c 1 -T rate -t 5000 | awk -v h=$HOSTNAME -F ";" '/total/{ load=$5*8/1000000; printf "[%s] Server %s load %.2f Mbit//%.0f\n",strftime("%m/%d/%Y %H:%M:%S", systime()),h,load,load}')
alert_check=$(echo $limit_check | awk -F "//" '{printf "%s",$2}')

if [ $alert_check -ge $LIMIT ]; then
  echo # Foxtrote Uniform Charlie Kilo
else
  echo $limit_check >> $LOG
  sendemail -l $LOG -f $GU -u "Super Cars Alert" -t $ALERT -s "smtp.gmail.com:587" -o tls=yes -xu $GU -xp $GP -q -m $limit_check of $rules_check
fi
