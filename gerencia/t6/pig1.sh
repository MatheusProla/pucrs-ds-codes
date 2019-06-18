#!/bin/bash

PIG_RELEASE="0.17.0"
PIG_FILENAME="pig-$PIG_RELEASE.tar.gz"
PIG_DIRECTORY="pig-$PIG_RELEASE"
DATASET_FILENAME="Pig, Hive - Datasets-20190614.zip"
DATASET_PATH="datasets"

if [ ! -f $PIG_FILENAME ];
then
	echo "Downloading Pig"
	wget -c "http://ftp.unicamp.br/pub/apache/pig/pig-$PIG_RELEASE/$PIG_FILENAME"
fi

if [ ! -d $PIG_DIRECTORY ];
then
	echo "Uncompressing Pig"
	tar -xf $PIG_FILENAME
fi

if [ ! -f $DATASET_FILENAME ]; then
    echo "Please download $DATASET_FILENAME"
    exit 1
fi

export PIG_HOME="$PWD/$PIG_DIRECTORY"
export PATH=$PIG_HOME/bin:$PATH

if [ ! -d $DATASET_PATH ]; then
        echo "Uncrompressing Datasets"
        mkdir "$DATASET_PATH"
        cp "$DATASET_FILENAME" "$DATASET_PATH"
        unzip "$DATASET_PATH/$DATASET_FILENAME" -d $DATASET_PATH
fi

HDFS_STATIONS_PATH="/user/$USER/stations"

echo "Sending stations.csv to HDFS"
hadoop fs -mkdir $HDFS_STATIONS_PATH
hadoop fs -put "$PWD/$DATASET_PATH/stations.csv" $HDFS_STATIONS_PATH
hadoop fs -ls -R /

echo "Invoking historyserver"
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

EX6="stations = LOAD \
'stations' USING PigStorage(',') AS \
(station_id:int, name:chararray, lat:float, \
long:float, \
dockcount:int, landmark:chararray, \
installation:chararray); \

station_ids_names = FOREACH stations GENERATE \
station_id, name; \

ordered = ORDER \
station_ids_names BY name;"

EX7="DESCRIBE stations; ILLUSTRATE ordered;"

EX8="DUMP ordered;"

pig -e "$EX6" 1>ex1-6-stdout.txt 2>ex1-6-stderr.txt
pig -e "$EX6 $EX7" 1>ex1-7-stdout.txt 2>ex1-7-stderr.txt
pig -e "$EX6 $EX8" 1>ex1-8-stdout.txt 2>ex1-8-stderr.txt
