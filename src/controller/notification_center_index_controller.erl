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
    Notifications = boss_db:find(notification, []),
 %   Notification = boss_db:find("notification-1"),
%    boss_db:delete("notification-1"),
    io:format("~n ~n Noti: ~p  ~n ~n", [Notifications]),
%    {json, [{lollee, "Hello get for a post :()"}]};
 %   {json, Notifications};
    {json, Notifications};

create('POST', [])->
    io:format(" ~n ~n Post request!  ~n ~n"),
    DateTime = Req:post_param("date"),
    Description = Req:post_param("description"),
    NewNotification= notification:new(id,"MyTitle", "MyDate", "MyDescription", "MySong"),
    {ok, SavedNotification} = NewNotification:save(),
    io:format(" ~n ~n DateTime:  ~p, Description: ~p ~n ~n",[DateTime,Description]),
    {redirect, [{action, "start"}]}.

