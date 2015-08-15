%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc notification_center.

-module(notification_center).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the notification_center server.
start() ->
    notification_center_deps:ensure(),
    ensure_started(crypto),
    application:start(notification_center).


%% @spec stop() -> ok
%% @doc Stop the notification_center server.
stop() ->
    application:stop(notification_center).
