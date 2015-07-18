-module(notification_center_index_controller, [Req]).
-compile(export_all).
%-default_action(start).

start('GET', [])->
    io:format(" ~n ~n GET request!  ~n ~n"),
    {ok, []}.


%% notifications('GET', [])->
%%     Notifications = boss_db:find(start, []).
%%     {json, Notifications}.

create('GET', [])->
    io:format(" ~n ~n Post/GET request!  ~n ~n"),
    {json, [{lollee, "Hello get for a post :()"}]};

create('POST', [])->
    io:format(" ~n ~n Post request!  ~n ~n"),
    {redirect, [{action, "start"}]}.
