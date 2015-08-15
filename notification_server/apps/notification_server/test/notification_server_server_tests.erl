-module(notification_server_server_tests).
-include_lib("eunit/include/eunit.hrl").


update_songs_test()->
    [
     ?_assertMatch(ok, notification_server_server:update_songs([])),
     ?_assertMatch(ok, notification_server_server:update_songs(["test.mp3"|"test2.mp3"]))
    ].

init_test([])->
    ?_assertMatch({ok,{Events,Songs}}, notification_server_server:init([])).

handle_call_test()->
    [  
       ?_assertMatch({ok,Events, _}, notification_server_server:handle_call({get_events},self(),[])),
       ?_assertMatch({ok,Songs, _}, notification_server_server:handle_call({get_songs},self(),[]))
    ];

handle_call_test() ->
    {ok,Events, _} = notification_server_server:handle_call({get_events},self(),[]),
    ?_assert(is_list(Events));

handle_call_test() ->
    {ok,Songs, _} = notification_server_server:handle_call({get_songs},self(),[]),
    ?_assert(is_list(Songs)).

handle_cast_test()->
    [   
        ?_assertMatch({noreply, _}, notification_server_server:handle_cast({new_event,{"test",{{1994,6,4},{10,10,0}},"test","test"}},[])),    ?_assertMatch({noreply, _}, notification_server_server:handle_cast({remove_event,0},[]))
    ].
    
handle_info_test()->
    ?_assertMatch({noreply, _}, notification_server_server:handle_info([],[])).


get_events_test()->
    ?_assert(is_list(notification_server_server:get_events())).

get_songs_test()->
    ?_assert(is_list(notification_server_server:get_songs())).
