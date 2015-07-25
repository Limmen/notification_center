-module(notification_server_event).

%% API
-export([start/1]).


%%====================================================================
%% API
%%====================================================================

start(Event)->
    io:format("event worker started with this event: ~p ~n ~n", [Event]),
    receive
        _ ->
            ok
                end.


%%====================================================================
%% Internal functions
%%====================================================================
