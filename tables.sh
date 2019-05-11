#!/bin/sh

cd `dirname $0`

TABLE_MARK="___tablename"
LIST_DIR="TableInfo"

mkdir -p $LIST_DIR

echo '' > tables.txt
echo '' > desctable.hql

lines=`hive -S -e 'show tables;'`
while read line
do
    echo "select '$TABLE_MARK $line';" >> desctable.hql
    echo "desc $line;" >> desctable.hql
done <<END
$lines
END

hive -S -f desctable.hql > tables.txt

fname="dummy"
while read colname colattr
do
    if [ "$TABLE_MARK" = "$colname" ]; then
        fname=$colattr
    else
        echo $colname >> $LIST_DIR/$fname
    fi
done < tables.txt
