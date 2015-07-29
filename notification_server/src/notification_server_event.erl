-module(notification_server_event).

%% API
-export([start/1]).


%%====================================================================
%% API
%%====================================================================


start(Event)->
    Pid = spawn(fun()-> event(Event) end),
    io:format("Event here, pid is: ~p ~n ~n", [Pid]),
    {ok,Pid}.

event({notification,Id,Title, DateTime, Descr, Song})->
    io:format("event worker started with this event: ~p ~n ~n", [Title]),
    io:format("date of the event: ~p ~n ~n", [DateTime]),
    Date = convert_to_erlang_date(DateTime),
    {Days, Time} = calendar:time_difference(calendar:local_time(),Date),
    io:format("Diff is ~p Days and ~p ~n ~n", [Days, Time]),
    SecondsLeft = convert_to_seconds({Days,Time}),
    io:format("Seconds left: ~p ~n ~n", [SecondsLeft]),
    tick(SecondsLeft).
    %% timer:apply_after(SecondsLeft, ?MODULE, time_is_up, []).
    %% receive
    %%     _ ->
    %%         ok
    %%             end.


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
    Date.
   
convert_to_seconds({Days,Time}) when Days >=0 ->
    convert_to_seconds({Days,Time},0).

convert_to_seconds({0,Time},Acc)->
    Acc + calendar:time_to_seconds(Time);
convert_to_seconds({Days,Time},Acc) ->
    convert_to_seconds({Days-1,Time},Acc+86400).


tick(Time) when Time >= 0 ->
    io:format("Tick ~p~n", [Time]),
    timer:sleep(1000),
    tick(Time-1);

tick(_StartTime) ->
    io:format("Boom.~n", []),
    time_is_up().


time_is_up()->
    io:format("Time is up!!!!!").
