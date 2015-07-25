%%%-------------------------------------------------------------------
%% @doc notification_server top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module('notification_server_sup').

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
%% API functions
%%====================================================================

%% Results in a call to init/1
start_link() ->
    supervisor:start_link({global, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->

    io:format("Root supervisor starting ~n ~n"),
    

    %If child dies more than 1 time per 3 seconds, terminate.
    %one_for_one means that if a child terminates only that child will be restarted, not all.
    Flags = #supflags{strategy = one_for_one, intensity = 1, period = 3},
    SupFlags = {Flags#supflags.strategy, Flags#supflags.intensity, Flags#supflags.period},
        
    %permanent restart defines that the child process should always be restarted.
    %shutdown = brutal_kill means we don't care about giving the server time to terminate,
    % we kill it in a  ruthless manner.
    ServerSpecs = #childspecs{id = events_server,
                            start = {notification_server_server, start_link, []},
                            restart = permanent,
                            shutdown = brutal_kill,
                            type = worker,
                            modules = [notification_server_server]},

    ServerChild = {ServerSpecs#childspecs.id,
                  ServerSpecs#childspecs.start,
                  ServerSpecs#childspecs.restart,
                  ServerSpecs#childspecs.shutdown,
                  ServerSpecs#childspecs.type,
                  ServerSpecs#childspecs.modules},

    %Since the child is a supervisor itself, we set shutdown=infinity to give it time to kill
    % it's childs before me terminate it.
    Event_SupervisorSpec = #childspecs{id = events_supervisor,
                            start = {notification_server_eventsup, start_link, []},
                            restart = permanent,
                            shutdown = infinity,
                            type = supervisor,
                            modules = [notification_server_eventsup]},
    Event_SupervisorChild = {Event_SupervisorSpec#childspecs.id,
                            Event_SupervisorSpec#childspecs.start,
                            Event_SupervisorSpec#childspecs.restart,
                            Event_SupervisorSpec#childspecs.shutdown,
                            Event_SupervisorSpec#childspecs.type,
                            Event_SupervisorSpec#childspecs.modules},


    ListenerSpec = #childspecs{id = listener,
                            start = {notification_server_listener, start, []},
                            restart = permanent,
                            shutdown = brutal_kill,
                            type = worker,
                            modules = [notification_server_listener]},
    ListenerChild = {ListenerSpec#childspecs.id,
                            ListenerSpec#childspecs.start,
                            ListenerSpec#childspecs.restart,
                            ListenerSpec#childspecs.shutdown,
                            ListenerSpec#childspecs.type,
                            ListenerSpec#childspecs.modules},


    {ok, { SupFlags, [ServerChild, Event_SupervisorChild, ListenerChild]} }.

%%====================================================================
%% Internal functions
%%====================================================================
