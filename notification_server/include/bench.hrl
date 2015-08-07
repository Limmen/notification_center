bench(Name, Fun, Trials) ->
    print_result(Name,Trials, repeat_tc(Fun, Trials)).

repeat_tc(Fun, Trials) ->
    timer:tc(fun() -> repeat(Trials, Fun) end).

repeat(0, _Fun) -> ok;
repeat(N, Fun) -> Fun(), repeat(N - 1, Fun).

print_result(Name,Trials, {Time, _}) ->
    io:format("~s: ~p times in  ~w milli-seconds~n", [Name,Trials,Time div 1000]).
