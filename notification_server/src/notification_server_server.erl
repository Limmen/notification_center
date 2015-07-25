-module(notification_server_server).

-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%API
-export([start_link/0, stop/0]).

%%Internal functions
-export([spawn_event/1, remove_event/1]).


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
handle_call(_,_,_)->
    io:format("handle call ~n ~n").

%% Expected to return {noreply, NewState}
handle_cast({new_event, Event},State)->
    io:format("handle cast ~n ~n"),
    Id = make_ref(),
    notification_server_eventsup:add_event({Id, Event}),
    ets:insert(events,{Id, Event}),
    io:format("Process spawned and inserted in ETS ~n ~n"),
    {noreply,State};

handle_cast({remove_event, {Id, Event}},State)->
    io:format("handle cast ~n ~n"),
    notification_server_eventsup:remove_event(Id),
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

remove_event(Event)->
    io:format("remove event ~n ~n"),
    gen_server:cast(?MODULE, {remove_event, Event}).
