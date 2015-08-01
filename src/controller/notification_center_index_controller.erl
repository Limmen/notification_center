-module(notification_center_index_controller, [Req]).
-compile(export_all).
%-default_action(start).

start('GET', [])->
    {ok, []}.


notifications('GET', [])->
    Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_events, Pid},
    receive
        [] ->
            {json, [{empty, "true"}]};
        Events ->
            {json, Events}
    after 3000 ->
            {json, []}
    end.

create('POST', [])->
    DateTime = Req:post_param("date"),
    Description = Req:post_param("description"),
    Title = Req:post_param("title"),
    Song = Req:post_param("song"),
    {notification_server_worker, event_server@limmen} ! {new_event, {Title,DateTime,Description,Song}},    
    {redirect, [{action, "start"}]}.


songs('GET', [])->
    Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_songs, Pid},
    receive
        [] ->
            io:format("empty songs ~n ~n"),
            {json, [{empty, "true"}]};
        Songs ->
            io:format("received songs: ~p  ~n ~n", [Songs]),
            {json, Songs}
    after 3000 ->
            {json, []}
    end.
    %% Songs2 = boss_db:find(song, []),
    %% io:format("Songs syntax: ~p ~n ~n", [Songs2] ),
    %% {json, Songs2}.   

delete('POST', [])->
    Id = Req:post_param("Id"),
    {notification_server_worker, event_server@limmen} ! {remove_event,Id},        
    {redirect, [{action, "start"}]}.
