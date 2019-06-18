#!/bin/bash

PIG_RELEASE="0.17.0"
PIG_DIRECTORY="pig-$PIG_RELEASE"

export PIG_HOME="$PWD/$PIG_DIRECTORY"
export PATH=$PIG_HOME/bin:$PATH

cat > "list_stations.pig" <<EOF
stations = LOAD 'stations' USING PigStorage(',') AS 
(station_id:int, name:chararray, lat:float, long:float, dockcount:int, landmark:chararray, installation:chararray);

station_ids_names = FOREACH stations GENERATE
station_id, name;

ordered = ORDER station_ids_names BY name;
STORE ordered INTO 'ordered';
EOF

pig -f list_stations.pig 1>ex2-stdout.txt 2>ex2-stderr.txt
