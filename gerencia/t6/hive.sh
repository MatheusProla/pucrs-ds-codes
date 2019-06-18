#!/bin/bash

HIVE_RELEASE="2.3.5"
HIVE_DIRECTORY="apache-hive-$HIVE_RELEASE-bin"
HIVE_FILENAME="$HIVE_DIRECTORY.tar.gz"
DATASET_FILENAME="Pig, Hive - Datasets-20190614.zip"
DATASET_PATH="datasets"

if [ ! -f $HIVE_FILENAME ];
then
	echo "Downloading Hive"
	wget -c "http://apache.claz.org/hive/hive-$HIVE_RELEASE/apache-hive-$HIVE_RELEASE-bin.tar.gz"
fi

if [ ! -d $HIVE_DIRECTORY ];
then
	echo "Uncompressing Hive"
	tar -xf $HIVE_FILENAME
	mv $HIVE_DIRECTORY "$HOME/$HIVE_DIRECTORY"
fi

if [ ! -d $DATASET_PATH ]; then
	echo "Uncrompressing Datasets"
	mkdir "$DATASET_PATH"
	cp "$DATASET_FILENAME" "$DATASET_PATH"
	unzip "$DATASET_PATH/$DATASET_FILENAME" -d $DATASET_PATH
fi

export HIVE_HOME="$HOME/$HIVE_DIRECTORY"

echo "Setting \$HIVE_HOME to $HIVE_HOME"
export PATH="$HIVE_HOME/bin:$PATH"

HDFS_HIVE_PATH="/user/hive"
HDFS_HIVE_BIKESHARE="/user/$USER/bikeshare"

echo "Reseting Hive"
rm -rf metastore_db
hadoop fs -rm -r -f $HDFS_HIVE_PATH
hadoop fs -rm -r -f $HDFS_HIVE_BIKESHARE

echo "Initializing Hive"
hadoop fs -mkdir -p /user/hive/warehouse
hadoop fs -chmod g+w /user/hive/warehouse
schematool -dbType derby -initSchema

echo "Creating $HDFS_HIVE_BIKESHARE/stations"
hadoop fs -mkdir -p $HDFS_HIVE_BIKESHARE/stations
echo "Creating $HDFS_HIVE_BIKESHARE/trip"
hadoop fs -mkdir -p $HDFS_HIVE_BIKESHARE/trip

echo "Adding stations.csv to HDFS"
hadoop fs -put "$PWD/$DATASET_PATH/stations.csv" "$HDFS_HIVE_BIKESHARE/stations/"
echo "Adding trips.csv to HDFS"
hadoop fs -put "$PWD/$DATASET_PATH/trips.csv" "$HDFS_HIVE_BIKESHARE/trip/"

USEDB="USE bikeshare;"
EX6="CREATE DATABASE bikeshare; \
SHOW DATABASES; $USEDB"

EX7="$USEDB CREATE EXTERNAL TABLE stations ( \
station_id INT, \
name STRING, \
lat DOUBLE, \
long DOUBLE, \
dockcount INT, \
landmark STRING, \
installation STRING \
) \
ROW FORMAT DELIMITED \
FIELDS TERMINATED BY ',' \
STORED AS TEXTFILE \
LOCATION 'hdfs:///$HDFS_HIVE_BIKESHARE/stations';"

EX8="$USEDB CREATE EXTERNAL TABLE trips ( \
trip_id INT, \
duration INT, \
start_date STRING, \
start_station STRING, \
start_terminal INT, \
end_date STRING, \
end_station STRING, \
end_terminal INT, \
bike_num INT, \
subscription_type STRING, \
zip_code STRING \
) \
ROW FORMAT DELIMITED \
FIELDS TERMINATED BY ',' \
STORED AS TEXTFILE \
LOCATION 'hdfs:///$HDFS_HIVE_BIKESHARE/trips';"

EX9="$USEDB SHOW TABLES; \
DESCRIBE stations; \
DESCRIBE trips; \
DESCRIBE FORMATTED stations; \
DESCRIBE FORMATTED trips;"

EX10="$USEDB SELECT start_terminal, start_station, COUNT(1) AS count \
FROM trips \
GROUP BY start_terminal, start_station \
ORDER BY count \
DESC LIMIT 10;"

EX11="$USEDB SELECT t.trip_id, t.duration, t.start_date, s.name, s.lat, s.long, s.landmark \
FROM stations s \
JOIN trips t ON s.station_id = t.start_terminal \
LIMIT 10;"

echo "Executing EX6"
hive -e "$EX6" 1>ex4-6-stdout.txt 2>ex4-6-stderr.txt
echo "Executing EX7"
hive -e "$EX7" 1>ex4-7-stdout.txt 2>ex4-7-stderr.txt
echo "Executing EX8"
hive -e "$EX8" 1>ex4-8-stdout.txt 2>ex4-8-stderr.txt
echo "Executing EX9"
hive -e "$EX9" 1>ex4-9-stdout.txt 2>ex4-9-stderr.txt
echo "Executing EX10"
hive -e "$EX10" 1>ex4-10-stdout.txt 2>ex4-10-stderr.txt
echo "Executing EX11"
hive -e "$EX11" 1>ex4-11-stdout.txt 2>ex4-11-stderr.txt
