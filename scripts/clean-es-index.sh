DAYSAGO=`date --date="7 days ago" +%Y.%m.%d`
ALLLINES=`/usr/bin/curl -s -XGET -u user:pass http://localhost:9200/_cat/indices | egrep service`

current_usage=$( df -h | grep '/dev/mapper/vg_data-lvol_data' | awk {'print $5'} )
echo "Current disk usage $current_usage"
echo "THIS IS WHAT SHOULD BE DELETED FOR ELK:"

max_usage=88%

if [ ${current_usage%?} -ge ${max_usage%?} ]; then
  echo "$ALLLINES" | while read LINE
do
  FORMATEDLINE=`echo $LINE | awk '{ print $3 }' | awk -F'-' '{print $(NF-0)}'`
  if [[ "$FORMATEDLINE" < "$DAYSAGO" ]]
  then
    TODELETE=`echo $LINE | awk '{ print $3 }'`
    echo "http://10.59.121.122:9200/$TODELETE"
    sleep 1
    /usr/bin/curl -s -XDELETE -u user:pass http://localhost:9200/$TODELETE
    sleep 1
  fi
done
elif [ ${current_usage%?} -lt ${max_usage%?} ]; then
  echo "No problems, Disk usage at ${current_usage}."
fi
