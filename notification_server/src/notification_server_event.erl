-module(notification_server_event).

%% API
-export([start/1]).


%%====================================================================
%% API
%%====================================================================

start({Id, {Title, DateTime, Descr, Song}})->
    io:format("event worker started with this event: ~p ~n ~n", [Title]),
    io:format("date of the event: ~p ~n ~n", [DateTime]),
    convert_to_erlang_date(DateTime),
    receive
        _ ->
            ok
                end.


%%====================================================================
%% Internal functions
%%====================================================================

convert_to_erlang_date([Y,E,A,R,45,M,O,45,D,K,32,H,F,58,I,N])->
    io:format("date convert time! ~n ~n"),
    Year = list_to_integer([Y,E,A,R]),
    Month = list_to_integer([M,O]),
    Day = list_to_integer([D,K]),
    Hour = list_to_integer([H,F]),
    Min = list_to_integer([I,N]),
    Date = {{Year,Month,Day},{Hour,Min,0}},
    io:format("Converted date: ~p ~n ~n", [Date]),
    {Days, Time} = calendar:time_difference(calendar:local_time(),Date),
    io:format("Diff is ~p Days and ~p ~n ~n", [Days, Time]),
    SecondsLeft = convert_to_seconds({Days,Time}),
    io:format("Seconds left: ~p ~n ~n", [SecondsLeft]),
    io:format("Time in seconds left: ~p ~n ~n", [Days, Time]),
    Date.
    

convert_to_seconds({Days,Time}) when Days >=0 ->
    convert_to_seconds({Days,Time},0).

convert_to_seconds({0,Time},Acc)->
    Acc + calendar:time_to_seconds(Time);
convert_to_seconds({Days,Time},Acc) ->
    convert_to_seconds({Days-1,Time},Acc+86400).
