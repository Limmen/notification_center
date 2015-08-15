#!/bin/sh
exec notification_server/release/_build/default/rel/notification_server/bin/notification_server &
exec erl \
    -pa ebin deps/*/ebin \
    -boot start_sasl \
    -sname notification_center_dev \
    -s notification_center \
    -s reloader \
    -setcookie event
