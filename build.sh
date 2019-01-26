#!/bin/sh

mkdir history &> /dev/null
mv verysync.tar.gz history/
tar zcvf verysync.tar.gz verysync
