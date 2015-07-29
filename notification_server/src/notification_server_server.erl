-module(notification_server_server).

-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%API
-export([start_link/0, stop/0]).

%%Internal functions
-export([spawn_event/1, remove_event/1, get_events/0]).


%%====================================================================
%% API
%%====================================================================

%%Results in a call to init/1
start_link()->
    io:format("server starting ~n ~n"),
    %%first argument ({local, notification_server_server}) means the gen_server is locally registered as "notification_server_server"
    %% second aregument (notification_server_server) is the name of the callback module (this module)
    %% third argument ([]) is optional arguments that will be passed to init/1
    %% fourh argument ([]) is optional options for the gen_server
    gen_server:start_link({local, notification_server_server}, notification_server_server, [], []).

%%Results in a call to terminate/2
stop()->
    gen_server:stop().


%%====================================================================
%% Server callbacks
%%====================================================================

%% Expected to return {ok, State}
%% New ets set-table is created for the servers internal state.
%% Primary key defaults to first position in every element (tuple).
init([])->
    io:format("Init! ~n ~n"),
    Table = ets:new(events, [set, named_table]),
    {ok, Table}.

%% Expected to return {reply, Reply, NewState}
handle_call({get_events},From,State)->
    io:format("handle call ~n ~n"),
    Events = ets:foldl(fun({Id,Event,Pid}, A)-> [Event|A]  end, [], events),
    io:format("Events: ~p ~n ~n", [Events]),
    {reply, Events, State}.

%% Expected to return {noreply, NewState}
handle_cast({new_event,{Title,DateTime,Description,Song}},State)->
    io:format("handle cast ~n ~n"),
%    Id = io_lib:format("~p",[term_to_binary(make_ref())]),
    {Date, {Hr, Min, Sec}} = calendar:local_time(),
    Milliseconds = integer_to_list(timer:seconds(Hr + Min + Sec)),
    Id = Title ++ "_" ++ Milliseconds,
    %% Id = "yo",
    Event = {notification,Id,Title,DateTime,Description,Song},
%    spawn(fun()->notification_server_eventsup:add_event(Event) end),
    Pid = notification_server_eventsup:add_event(Event),
    io:format("child PId?! : ~p ~n ~n ", [Pid]),
    io:format("Handle_Cast have started event process ~n ~n"),
    io:format("Id that is being stored in ETS is: ~p ~n", [Id]),
    ets:insert(events,{Id, Event, Pid}),
    io:format("Handle_cast have inserted event in ETS ~n ~n"),
    {noreply,State};

handle_cast({remove_event, Id},State)->
    io:format("handle remove cast ~n ~n"),
    io:format("Id to lookup is: ~p ~n ~n", [Id]),
    io:format("Id to lookup in binary is: ~p ~n ~n", [list_to_binary(Id)]),
    io:format("First key in ETS is: ~p ~n ~n",[ets:first(events)]),
    [{Id,Event,Pid}|_] = ets:lookup(events,Id),
    %% Pid = ets:lookup(events,Id),
    io:format("Pid is: ~p ~n ~n ", [Pid]),
    spawn(fun()->notification_server_eventsup:remove_event(Pid) end),
    ets:delete(events,Id),
    io:format("Process killed and entry in ETS removed ~n ~n"),
    {noreply,State}.


%% Expexted to return {noreply, NewState}
handle_info(Info,State)->
    io:format("handle info ~n ~n"),
    {noreply, State}.

%% This function should never be called since we are a part of a supervisor tree.
%% The supervisor will handle termination.
terminate(Reason, State)->
    io:format("terminate ~n"),
    ok.

%% Exptexted to return {ok, NewState}
code_change(OldVsn, State, Extra)->    
    {ok, State}.

%%====================================================================
%% Internal functions
%%====================================================================

spawn_event(Event)->
    io:format("spawn_event ~n ~n"),
    gen_server:cast(?MODULE, {new_event, Event}).

remove_event(Id)->
    io:format("remove event ~n ~n"),
    gen_server:cast(?MODULE, {remove_event, Id}).

get_events()->
    gen_server:call(?MODULE, {get_events}).
