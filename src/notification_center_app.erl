%% @author Mochi Media <dev@mochimedia.com>
%% @copyright notification_center Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the notification_center application.

-module(notification_center_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for notification_center.
start(_Type, _StartArgs) ->
    notification_center_deps:ensure(),
    notification_center_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for notification_center.
stop(_State) ->
    ok.
