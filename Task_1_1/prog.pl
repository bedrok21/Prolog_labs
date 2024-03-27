% Task 1.1  Var 2

find_max([X], X).
find_max([H|T], Max) :-
    find_max(T, MaxT),
    Max is max(H, MaxT).

filter_element(_, [], [], 0).
filter_element(X, [X|T], Result, NNum) :-
    filter_element(X, T, Result, Num),
    NNum is Num+1.
filter_element(X, [H|T], [H|Result], Num) :-
    dif(X, H),
    filter_element(X, T, Result, Num).

gen_list(0, _, []).
gen_list(N, El,[El|Rest]) :-
    N > 0,
    N1 is N - 1,
    gen_list(N1, El, Rest).

concat_lists([], L, L).
concat_lists([H|T], L, [H|Result]) :-
    concat_lists(T, L, Result).

move_max_to_front([], []).
move_max_to_front([X], [X]).
move_max_to_front(List, Result):-
    find_max(List, Max),
    filter_element(Max, List, R, Num),
    gen_list(Num, Max, U),
    concat_lists(U, R, Result).

main :-
    read(List),
    move_max_to_front(List, Result),
    write(Result).


