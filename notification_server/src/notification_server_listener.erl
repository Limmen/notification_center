-module(notification_server_listener).

%% API
-export([listen/0]).


%%====================================================================
%% API
%%====================================================================

listen()->
    io:format("listener up and listening ~n ~n"),
    io:format("Listener PID is: ~p ~n ~n", [self()]),
    receive
        {newevent, Event} ->
            io:format("Listener Received newevent! ~n ~n"),
            notification_server_server:spawn_event(Event),
            listen();
        {updateevents, Events} ->
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
