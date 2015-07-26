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
    receive
        {new_event, Event} ->
            io:format("Listener Received newevent! ~n ~n"),
            notification_server_server:spawn_event(Event),
            listen();
        {remove_event, Event} ->
            io:format("Remove element ~n ~n"),
%            notification_server_server:remove_event(Event),
            listen();
        {get_events}->
            io:format("Listener received get events ~n ~n"),
            Events = notification_server_server:get_events(),
            io:format("listener received events: ~p ~n ~n ", [Events]),
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
