-module(notification_server_eventsup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%% Records
-record(supflags, {strategy, intensity, period}).
-record(childspecs, {id, start, restart, shutdown, type, modules}).


%%====================================================================
%% API
%%====================================================================

%% Results in a call to init/1
start_link() ->
    io:format("Event supervisor trying to start up ~n ~n"),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


%%====================================================================
%% Supervisor callbacks
%%====================================================================

init([]) ->

    io:format("Child supervisor starting ~n ~n"),
    
    %If child dies more than 1 time per 3 seconds, terminate.
    %one_for_one means that if a child terminates only that child will be restarted, not all.
    Flags = #supflags{strategy = one_for_one, intensity = 1, period = 3},
    SupFlags = {Flags#supflags.strategy, Flags#supflags.intensity, Flags#supflags.period},
    
    %permanent restart defines that the child process should always be restarted.
    %shutdown = brutal_kill means we don't care about giving the server time to terminate,
    % we kill it in a  ruthless manner.
    EventSpec = #childspecs{id = notification_server_event,
                            start = {notification_server_event, start, []},
                            restart = permanent,
                            shutdown = brutal_kill,
                            type = worker,
                            modules = [notification_server_event]},
    EventChild = {EventSpec#childspecs.id,
                 EventSpec#childspecs.start,
                 EventSpec#childspecs.restart,
                 EventSpec#childspecs.shutdown,
                 EventSpec#childspecs.type,
                 EventSpec#childspecs.modules},
    


    {ok, {SupFlags, [EventChild]} }.

%%====================================================================
%% Internal functions
%%====================================================================
