#!/bin/sh
psql --list|grep UTF8|awk '{ print $1 }'
