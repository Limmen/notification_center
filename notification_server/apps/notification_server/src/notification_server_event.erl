-module(notification_server_event).
-compile(export_all).
%% API
-export([start/1]).


%%====================================================================
%% API
%%====================================================================


start(Event)->
    Pid = spawn(fun()-> event(Event) end),
    {ok,Pid}.

event({struct, [{id, Id},{title, Title},{date, DateTime}, {description, Description},{song, Song}]})->
    Date = convert_to_erlang_date(binary:bin_to_list(DateTime)),
    {Days, Time} = calendar:time_difference(calendar:local_time(),Date),
    SecondsLeft = convert_to_seconds({Days,Time}),
    tick(SecondsLeft, {binary:bin_to_list(Title), binary:bin_to_list(Song)}).

%%====================================================================
%% Internal functions
%%====================================================================

convert_to_erlang_date([Y,E,A,R,45,M,O,45,D,K,32,H,F,58,I,N])->
    Year = list_to_integer([Y,E,A,R]),
    Month = list_to_integer([M,O]),
    Day = list_to_integer([D,K]),
    Hour = list_to_integer([H,F]),
    Min = list_to_integer([I,N]),
    Date = {{Year,Month,Day},{Hour,Min,0}},
    Date.
   
convert_to_seconds({Days,Time}) when Days >=0 ->
    convert_to_seconds({Days,Time},0).

convert_to_seconds({0,Time},Acc)->
    Acc + calendar:time_to_seconds(Time);
convert_to_seconds({Days,Time},Acc) ->
    convert_to_seconds({Days-1,Time},Acc+86400).


tick(Time, Event) when Time >= 0 ->
    timer:sleep(1000),
    tick(Time-1, Event);

tick(_StartTime, Event) ->
    time_is_up(Event).


time_is_up({Title, Song})->
    os:cmd("espeak " ++ Title ),
    spawn(fun()-> os:cmd("mpg123 songs/'" ++ Song ++ "'") end),
    loop({Title,Song}, 100).


loop({Title,Song}, 0)->
    spawn(fun()-> os:cmd("mpg123 songs/'" ++ Song ++ "'") end),
    loop({Title,Song}, 100);

loop({Title,Song}, RestartSong)->
    os:cmd("espeak " ++ Title),
    timer:sleep(3000),
    loop({Title,Song}, RestartSong-1).
    
