all: build run

build:
	rebar3 compile

run: 
	erl -pa _build/default/lib/notification_server/ebin -eval "application:start(notification_server)" -noshell start_sasl
