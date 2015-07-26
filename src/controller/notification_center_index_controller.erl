-module(notification_center_index_controller, [Req]).
-compile(export_all).
%-default_action(start).

start('GET', [])->
    io:format(" ~n ~n GET request!  ~n ~n"),
    {ok, []}.

%% notifications('GET', [])->
%%     Notifications = boss_db:find(start, []).
%%     {json, Notifications}.

notifications('GET', [])->
    io:format(" ~n ~n Post/GET request!  ~n ~n"),
    io:format("My PID is: ~p ~n ~n",[self()]),
    Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_events, Pid},
    receive
        Events ->
            io:format("yo, received events here! ~p ~n ~n",[Events]),
            {json, Events};
        _ -> io:format("received smth random  ~n ~n"),
                 {json, [{fail}]}
    end.
%%     Notifications = boss_db:find(notification, []),
%%     io:format("~n ~n Noti: ~p  ~n ~n", [Notifications]),
%% %    {json, [{event,[{ title, "title" }, { map, "map" }, { body, "ddd" }]}]}.
%%     {json,  [{notification,
%%                                <<"131,114,0,3,100,0,19,101,118,101,110,116,95,
%%                                  115,101,114,118,101,114,64,108,105,109,109,
%%                                  101,110,3,0,0,0,89,0,0,0,0,0,0,0,0">>,
%%                                "ggraa","2015-07-30 14:39","grr",
%%                                "TestSong3 - TestArtist3"}] }.




%% [{notification,"103r1","MyTitle",
%%                       "MyDate","MyDescription","MySong"}]


%% [{notification,#Ref<12547.0.0.66>,"BROOOOO",
%%                                "2015-07-30 14:32","ggra",
%%                                "TestSong2 - TestArtist2"}] 

%   {json, Notifications}.

create('POST', [])->
    io:format(" ~n ~n Post request!  ~n ~n"),
    DateTime = Req:post_param("date"),
    Description = Req:post_param("description"),
    Title = Req:post_param("title"),
    Song = Req:post_param("song"),
    %% NewNotification= notification:new(id,Title, DateTime, Description, Song),
    %% {ok, SavedNotification} = NewNotification:save(),
    {notification_server_worker, event_server@limmen} ! {new_event, {Title,DateTime,Description,Song}},    
    io:format(" ~n ~n DateTime:  ~p, Description: ~p, Title: ~p, Song: ~p  ~n ~n",[DateTime,Description, Title, Song]),
    {redirect, [{action, "start"}]}.


songs('GET', [])->
    Songs = boss_db:find(song, []),
    io:format("~n ~n Noti: ~p  ~n ~n", [Songs]),
%    {json, [{"title", "test"}]}.
    {json, Songs}.   
