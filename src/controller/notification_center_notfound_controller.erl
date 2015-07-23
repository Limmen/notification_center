-module(notification_center_notfound_controller, [Req]).
-compile(export_all).


notfound('GET', []) ->
    {ok, []}.
