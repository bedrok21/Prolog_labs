% Task 1.2 Var 45

is_square(N) :-
    integer(N), N >= 0,
    X is integer(sqrt(N)),
    N =:= X*X.

remove_at_squares([], _, []).

remove_at_squares([_|T], Index, Result) :-
    is_square(Index),
    NextIndex is Index + 1,
    remove_at_squares(T, NextIndex, Result).

remove_at_squares([H|T], Index, [H|Result]) :-
    not(is_square(Index)),
    NextIndex is Index + 1,
    remove_at_squares(T, NextIndex, Result).

remove_at_squares(List, Result) :-
    remove_at_squares(List, 1, Result).

main :-
    read(List),
    remove_at_squares(List, Result),
    write(Result).
