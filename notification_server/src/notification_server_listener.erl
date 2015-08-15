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
    receive
        {new_event, Event} ->
            io:format("Receieved new event signal!"),
            notification_server_server:spawn_event(Event),
            listen();
        {remove_event, Id} ->
            notification_server_server:remove_event(Id),
            listen();
        {get_events, From}->
            Events = notification_server_server:get_events(),
            From ! Events,
            listen();            
        {get_songs, From}->
            Songs = notification_server_server:get_songs(),
            From ! Songs,
            listen();            
        _  -> 
            listen()
                  end.

%%====================================================================
%% Supervisor callbacks
%%====================================================================



%%====================================================================
%% Internal functions
%%====================================================================
