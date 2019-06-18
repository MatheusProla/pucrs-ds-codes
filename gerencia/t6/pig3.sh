#!/bin/bash

PIG_RELEASE="0.17.0"
PIG_DIRECTORY="pig-$PIG_RELEASE"
DATASET_PATH="datasets"

export PIG_HOME="$PWD/$PIG_DIRECTORY"
export PATH=$PIG_HOME/bin:$PATH

HDFS_USER="/user/$USER"

hadoop fs -rm -r -f "$HDFS_USER/stopwords"
hadoop fs -rm -r -f "$HDFS_USER/shakespeare"

hadoop fs -mkdir -p "$HDFS_USER/stopwords"
hadoop fs -mkdir -p "$HDFS_USER/shakespeare"

hadoop fs -put "$PWD/$DATASET_PATH/stop-word-list.csv" "$HDFS_USER/stopwords"
hadoop fs -put "$PWD/$DATASET_PATH/shakespeare.txt" "$HDFS_USER/shakespeare"

pig -f pig3-commands 1>ex3-stdout.txt 2>ex3-stderr.txt
