%%%-------------------------------------------------------------------
%% @doc notification_server public API
%% @end
%%%-------------------------------------------------------------------

-module('notification_server_app').

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    io:format("notification_server application starting ~n ~n"),
    'notification_server_sup':start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
