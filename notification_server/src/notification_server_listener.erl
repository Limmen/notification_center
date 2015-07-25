-module(notification_server_listener).

%% API
-export([start/0]).


%%====================================================================
%% API
%%====================================================================

start()->
    register(notification_server_worker, self()),
    listen().

listen()->
    io:format("listener up and listening ~n ~n"),
    io:format("Listener PID is: ~p ~n ~n", [self()]),
    receive
        {new_event, Event} ->
            io:format("Listener Received newevent! ~n ~n"),
            notification_server_server:spawn_event(Event),
            listen();
        {remove_event, Event} ->
            notification_server_server:remove_event(Event),
            listen();
        _  -> 
            io:format("Listener received something random ~n ~n"),
            listen()
                  end.

%%====================================================================
%% Supervisor callbacks
%%====================================================================



%%====================================================================
%% Internal functions
%%====================================================================
