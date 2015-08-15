-module(notification_center_views).

-compile(export_all).

urls() -> [
      {"^json/?$", json},
      {"^delete/?$", delete},
      {"^notifications/?$", notifications},
      {"^songs/?$", songs},
      {"^create/?$", create},
      {"^delete/?$", delete}
    ].


handle_json(Req)->
    Req:ok({"application/json",[], mochijson2:encode([{struct, [{strKey, <<"delete!">>}, {intKey, 10}, {arrayKey, [1, 2, 3]}]}, {struct, [{strKey, <<"delete!">>}, {intKey, 10}, {arrayKey, [1, 2, 3]}]}])}).

handle_delete(Req)->
    PostData = Req:parse_post(),
    Id = proplists:get_value("Id", PostData, "null"),
    {notification_server_worker, event_server@limmen} ! {remove_event,Id},        
    index.

handle_notifications(Req)->
    io:format("Inside handle_notifications"),
    Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_events, Pid},
    receive
        [] ->
            Req:ok({"application/json", [], mochijson2:encode({struct, [{empty, <<"true">>}]})});
        Events ->
            io:format("Received notifications"),
            Req:ok({"application/json", [], mochijson2:encode(Events)})
    after 3000 ->
            Req:ok({"application/json", [], mochijson2:encode({struct, [{empty, <<"true">>}]})})
    end.

handle_songs(Req)->
    Pid = self(),
    {notification_server_worker, event_server@limmen} ! {get_songs, Pid},
    receive
        [] ->
            io:format("empty songs ~n ~n"),
            Req:ok({"application/json", [], mochijson2:encode({struct, [{empty, <<"true">>}]})});
        Songs ->
            io:format("received songs: ~p  ~n ~n", [Songs]),
            Req:ok({"application/json", [], mochijson2:encode(Songs)})
    after 3000 ->
            Req:ok({"application/json", [], mochijson2:encode({struct, [{empty, <<"true">>}]})})
    end.

handle_create(Req)->
    io:format("HANDLE CREATE ~n ~n"),
    PostData = Req:parse_post(),
    DateTime = proplists:get_value("date", PostData, "null"),
    Description = proplists:get_value("description", PostData, "null"),
    Title = proplists:get_value("title", PostData, "null"),
    Song = proplists:get_value("song", PostData, "null"),
    {notification_server_worker, event_server@limmen} ! {new_event, {Title,DateTime,Description,Song}},
    index.



json('GET', Req)->
    handle_json(Req);

json('POST', Req)->
    handle_json(Req).

delete('POST', Req)->
    handle_delete(Req).

notifications('GET', Req)->
    handle_notifications(Req).

songs('GET', Req)->
    handle_songs(Req).

create('POST', Req)->
    io:format("yo create"),
    handle_create(Req).


    
