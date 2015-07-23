-module(alarmtest).

-compile(export_all).


start(N)->
    wakeup(N),
%%    os:cmd("mpg123 avicii.mp3"),
    Pid = self(),
    io:format("my pid is: ~p ~n ~n ", [Pid]),
    receive
        _ -> io:format("Received msg!")
                   end,
    io:format("is mpg123 non-blocking? ~n").


wakeup(0)->
    done;
wakeup(N) ->
    os:cmd("espeak wakeup"),
    wakeup(N-1).

    
