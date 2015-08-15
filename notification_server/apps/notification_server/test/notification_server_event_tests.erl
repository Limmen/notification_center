-module(notification_server_event_tests).
-include_lib("eunit/include/eunit.hrl").

convert_to_seconds_test()->
    [
     ?_assert(notification_server_event:convert_to_seconds({4,{8,34,53}}) =:= 376493),
     ?_assert(notification_server_event:convert_to_seconds({4,{2,2,2}}) =:= 352922),
     ?_assert(notification_server_event:convert_to_seconds({0,{0,9,2}}) =:= 542),
     ?_assert(notification_server_event:convert_to_seconds({0,{0,0,0}}) =:= 0)
             ].

convert_to_erlang_date_test()->
    ?_assertMatch({{Year,Month,Day},{Hour,Min,Sec}}, notification_server_event:convert_to_erlang_date({"1994-06-04 06:00"})).

