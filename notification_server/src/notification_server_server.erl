-module(notification_server_server).

-behaviour(gen_server).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%API
-export([start_link/0, stop/0]).

%%Internal functions
-export([spawn_event/0, update_events/0]).


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

init([])->
    io:format("Init! ~n ~n").

handle_call(_,_,_)->
    io:format("handle call ~n ~n").

handle_cast(_,_)->
    io:format("handle cast ~n ~n").

handle_info(Info,State)->
    io:format("handle info ~n ~n"),
    {noreply, State}.

terminate(Reason, State)->
    io:format("terminate ~n"),
    ok.

code_change(OldVsn, State, Extra)->    
    {ok, State}.

%%====================================================================
%% Internal functions
%%====================================================================

spawn_event()->
    io:format("spawn_event ~n ~n").

update_events()->
    io:format("update events ~n ~n").
