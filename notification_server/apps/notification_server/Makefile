BENCHMARKS=$(wildcard test/*.escript)

all: build run

build:
	rebar3 compile
	rebar3 dialyzer
	rebar3 eunit

run: 
	erl -sname event_server -setcookie event -pa _build/default/lib/notification_server/ebin -eval "application:start(notification_server)" -noshell start_sasl

run_in_background:
	erl -sname event_server -setcookie event -pa _build/default/lib/notification_server/ebin -eval "application:start(notification_server)" -noshell start_sasl &

bench:
	escript $(BENCHMARKS)



