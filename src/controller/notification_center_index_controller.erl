-module(notification_center_index_controller, [Req]).
-compile(export_all).
%-default_action(start).

start('GET', [])->
    io:format(" ~n ~n GET request!  ~n ~n"),
    {ok, []}.


notifications('GET', [])->
    io:format(" ~n ~n Post/GET request!  ~n ~n"),
    io:format("My PID is: ~p ~n ~n",[self()]),
    Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_events, Pid},
    receive
        Events ->
            io:format("yo, received events here! ~p ~n ~n",[Events]),
            {json, Events}
    after 3000 ->
            {json, []}
    end.

create('POST', [])->
    io:format(" ~n ~n Post request!  ~n ~n"),
    DateTime = Req:post_param("date"),
    Description = Req:post_param("description"),
    Title = Req:post_param("title"),
    Song = Req:post_param("song"),
    {notification_server_worker, event_server@limmen} ! {new_event, {Title,DateTime,Description,Song}},    
    io:format(" ~n ~n DateTime:  ~p, Description: ~p, Title: ~p, Song: ~p  ~n ~n",[DateTime,Description, Title, Song]),
    {redirect, [{action, "start"}]}.


songs('GET', [])->
    Songs = boss_db:find(song, []),
    io:format("~n ~n Noti: ~p  ~n ~n", [Songs]),
    {json, Songs}.   
