% Task 2 Var 32

insert_element(El, List, [El|List]).


insert_nth_sublist(El, 1, [], [[El]]).
insert_nth_sublist(El, 1, [Sublist|Rest], [UpdatedSublist|Rest]) :-
    insert_element(El, Sublist, UpdatedSublist).
insert_nth_sublist(El, N, [], [[]|UpdatedRest]) :-
    N > 1,
    N1 is N - 1,
    insert_nth_sublist(El, N1, [], UpdatedRest).
insert_nth_sublist(El, N, [Sublist|Rest], [Sublist|UpdatedRest]) :-
    N > 1,
    N1 is N - 1,
    insert_nth_sublist(El, N1, Rest, UpdatedRest).


filter_element(_, [], [], 0).
filter_element(X, [X|T], Result, NNum) :-
    filter_element(X, T, Result, Num),
    NNum is Num+1.
filter_element(X, [H|T], [H|Result], Num) :-
    dif(X, H),
    filter_element(X, T, Result, Num).


insert_in_final_list(X, I, List, Result) :-
    length(List, N),
    N >= I,
    insert_nth_sublist(X, I, List, Result).
insert_in_final_list(X, I, List, Result) :-
    length(List, N),
    N < I,
    insert_nth_sublist(X, I, List, Result).


group([], []).
group([H|T], Result) :-
    group([H|T], [], Result).
group([], Helper, Helper).
group([H|T], Helper1, Result) :-
    filter_element(H, [H|T], Filtered, N),
    insert_in_final_list(H, N, Helper1, Helper2),
    group(Filtered, Helper2, Result).

main :-
    read(List),
    group(List, Result),
    write(Result).
