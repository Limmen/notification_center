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
    Table = ets:new(events, [set, named_table, {keypos, 2}]),
    {ok, Table}.

%% Expected to return {reply, Reply, NewState}
handle_call({get_events},From,State)->
    io:format("handle call ~n ~n"),
    Events = ets:foldl(fun(X, A)-> [X|A]  end, [], events),
    io:format("Events: ~p ~n ~n", [Events]),
    {reply, Events, State}.

%% Expected to return {noreply, NewState}
handle_cast({new_event,{Title,DateTime,Description,Song}},State)->
    io:format("handle cast ~n ~n"),
    Id = io_lib:format("~p",[term_to_binary(make_ref())]),
%    Id = make_ref(),
    Event = {notification,Id,Title,DateTime,Description,Song},
    spawn(fun()->notification_server_eventsup:add_event(Event) end),
    io:format("Handle_Cast have started event process ~n ~n"),
    ets:insert(events,Event),
    io:format("Handle_cast have inserted event in ETS ~n ~n"),
    {noreply,State};

handle_cast({remove_event, {Id, Event}},State)->
    io:format("handle cast ~n ~n"),
    spawn(fun()->notification_server_eventsup:remove_event(Id) end),
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

get_events()->
    gen_server:call(?MODULE, {get_events}).
