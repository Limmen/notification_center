#!/usr/bin/env escript


-mode(compile).

-include("../include/bench.hrl").

-define(NR_OF_TESTS, 100000).                             
                                                              
main(_)->                                                 
    io:format(" ~n ~n----- BENCH MARKS (NR_OF_TESTS to bench is = 100000) ~n ~n"),
    bench_date_convert(),                                     
    bench_seconds_convert(),                                  
    {ok, _} = net_kernel:start([bench, shortnames]),          
    erlang:set_cookie(node(), event),                         
    case net_adm:ping(list_to_atom("notification_center@limmen")) of
        pong ->  bench_get_songs(),                           
                 bench_get_events(),                          
                 halt(0);                                     
        pang -> io:format("pang! ~n"),                        
                halt(2)                                       
    end.                                                      
                                                              
bench_date_convert()->                                        
    bench("Convert to erlang date", fun()-> convert_to_erlang_date("1994-08-14 19:50") end, ?NR_OF_TESTS).
                                                              
bench_seconds_convert()->                                     
    bench("Convert  1year to seconds", fun()-> convert_to_seconds({364, {22, 10, 50}}) end, ?NR_OF_TESTS).
                                                              
bench_get_songs()->                                           
    bench("Get songs", fun()-> get_songs() end, ?NR_OF_TESTS).
                                                              
bench_get_events()->                                          
    bench("Get events", fun()-> get_events() end, ?NR_OF_TESTS).




get_songs()->
        Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_songs, Pid},
    receive
        [] ->
            "Empty";
        Songs ->
            Songs
    end.


get_events()->
    Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_events, Pid},
    receive
        [] ->
            "Empty";
        Events ->
            Events
    end.

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



%% main([Node]) ->
%% try
%%     {ok, _} = net_kernel:start(['mynode@127.0.0.1', longnames]).
%%     erlang:set_cookie(node(), mycookie),
%%     case net_adm:ping(list_to_atom(Node)) of
%%     pong -> halt(0);
%%     pang -> halt(2)
%%     end
%% catch _:Reason
%%     io:format("~p~n", [Reason]),
%%     halt(3)
%% end.
