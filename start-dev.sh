#!/bin/sh
exec erl \
    -pa ebin deps/*/ebin \
    -boot start_sasl \
    -sname notification_center_dev \
    -s notification_center \
    -s reloader \
    -setcookie event
