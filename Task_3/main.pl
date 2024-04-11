accepts(Word, Res) :-
   start(S),
   accepts_from(S,Word,End),
   append(Word, End, Res).

accepts_from(S,[],End) :-
   generate_end(S, [], End).
accepts_from(S,[T|Ts],End) :-
   transition(S,T,NextS),
   accepts_from(NextS,Ts, End).

generate_end(S,[],[T|Ts]) :-
   transition(S,T,NextS),
   generate_end(NextS,[NextS],Ts).
generate_end(S,_,[]) :-
   end(S).
generate_end(S,States,[T|Ts]) :-
   transition(S,T,NextS),
   \+ member(NextS, States),
   append(States, [NextS], NewStates),
   generate_end(NextS,NewStates,Ts).

main(FileName, Word, Res) :-
    read_file_lines(FileName, [Line|Rest]),
    atom_codes(Token, Line),
    assertz(start(Token)),
    assert_facts(Rest),
    accepts(Word, Res).

read_file_lines(FileName, Lines) :-
    open(FileName, read, Stream),
    read_lines(Stream, Lines),
    close(Stream).
read_lines(Stream, []) :-
    at_end_of_stream(Stream),
    !.
read_lines(Stream, [Line|Rest]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    read_lines(Stream, Rest).
assert_facts([]).
assert_facts([Line|Rest]) :-
    interpret_line(Line),
    assert_facts(Rest).
interpret_line(Line) :-
    atomic_list_concat(Tokens, ' ', Line),
    interpret_tokens(Tokens).
interpret_tokens([State]) :-
    assertz(end(State)).
interpret_tokens([From, Symbol, To]) :-
    assertz(transition(From, Symbol, To)).


