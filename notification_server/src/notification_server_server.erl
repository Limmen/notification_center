-module(notification_server_server).

-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%API
-export([start_link/0, stop/0]).

%%Internal functions
-export([spawn_event/1, remove_event/1, get_events/0, get_songs/0]).


%%====================================================================
%% API
%%====================================================================

%%Results in a call to init/1
start_link()->
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
    Events = ets:new(events, [set, named_table]),
    List_of_songs = os:cmd("\ls songs/ | grep .mp3$"),
    Songs = ets:new(songs, [set, named_table, {keypos, 2}]),
    update_songs(List_of_songs),
    {ok, {Events, Songs}}.

%% Expected to return {reply, Reply, NewState}
handle_call({get_events},From,State)->
    Events = ets:foldl(fun({Id,Event,Pid}, A)-> [Event|A]  end, [], events),
    {reply, Events, State};

handle_call({get_songs},From,State)->
    Songs = ets:foldl(fun(Song, A)-> [Song|A]  end, [], songs),
    io:format("fold songs: ~p ~n ~n", [Songs]),
    {reply, Songs, State}.

%% Expected to return {noreply, NewState}
handle_cast({new_event,{Title,DateTime,Description,Song}},State)->
    {Date, {Hr, Min, Sec}} = calendar:local_time(),
    Milliseconds = integer_to_list(timer:seconds(Hr + Min + Sec)),
    Id = Title ++ "_" ++ Milliseconds,
    Event = {notification,Id,Title,DateTime,Description,Song},
    Pid = notification_server_eventsup:add_event(Event),
    ets:insert(events,{Id, Event, Pid}),
    {noreply,State};

handle_cast({remove_event, Id},State)->
    [{Id,Event,Pid}|_] = ets:lookup(events,Id),
    notification_server_eventsup:remove_event(Pid),
    ets:delete(events,Id),
    {noreply,State}.


%% Expexted to return {noreply, NewState}
handle_info(Info,State)->
    {noreply, State}.

%% This function should never be called since we are a part of a supervisor tree.
%% The supervisor will handle termination.
terminate(Reason, State)->
    ok.

%% Exptexted to return {ok, NewState}
code_change(OldVsn, State, Extra)->    
    {ok, State}.

%%====================================================================
%% Internal functions
%%====================================================================

spawn_event(Event)->
    gen_server:cast(?MODULE, {new_event, Event}).

remove_event(Id)->
    gen_server:cast(?MODULE, {remove_event, Id}).

get_events()->
    gen_server:call(?MODULE, {get_events}).

get_songs()->
    gen_server:call(?MODULE, {get_songs}).


update_songs(Songs)->
    update_songs(Songs, []).

update_songs([], [])->
    ok;

update_songs([], Song)->
    ets:insert(songs, {song, Song});

update_songs([10|Songs],Song)->
    ets:insert(songs, {song, Song}),
    update_songs(Songs, []);

update_songs([H|T], Song) ->
    update_songs(T, Song ++ [H]).

    

    
