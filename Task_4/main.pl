production('S', ['a', 'A']).
production('A', ['b', 'B', 'x']).
production('B', ['c', 'd', 'B']).
production('B', ['t', 'd']).
production('B', []).

expand(Symbol, Expansion) :-
    production(Symbol, Expansion).

build_parse_tree(Symbol, MaxDepth, Tree) :-
    build_parse_tree(Symbol, 0, MaxDepth, Tree).

build_parse_tree(Symbol, Depth, MaxDepth, leaf(Symbol)) :-
    Depth > MaxDepth.
build_parse_tree(Symbol, _, _, leaf(Symbol)) :-
    \+ expand(Symbol, _).

build_parse_tree(Symbol, Depth, MaxDepth, node(Symbol, Subtrees)) :-
    Depth =< MaxDepth,
    expand(Symbol, Expansion),
    Depth1 is Depth + 1,
    build_subtrees(Expansion, Depth1, MaxDepth, Subtrees).

build_subtrees([], _, _, []).
build_subtrees([Symbol|Symbols], Depth, MaxDepth, [Tree|Trees]) :-
    build_parse_tree(Symbol, Depth, MaxDepth, Tree),
    build_subtrees(Symbols, Depth, MaxDepth, Trees).


extract_results_from_root(node(Symbol, Subtrees), Result) :-
    extract_from_subtrees(Subtrees, Results),
    Result = [Symbol | Results].

extract_from_subtrees([], []).
extract_from_subtrees([leaf(Symbol) | Subtrees], [Symbol | RestResults]) :-
    extract_from_subtrees(Subtrees, RestResults).
extract_from_subtrees([node(_, SubSubtrees) | Subtrees], Results) :-
    extract_from_subtrees(SubSubtrees, SubResults),
    extract_from_subtrees(Subtrees, SubtreeResults),
    append(SubResults, SubtreeResults, Results).

terminal(Symbol) :-
    \+ production(Symbol, _).

valid_expansion(StartSymbol, [Head|Tail]) :-
    Head = StartSymbol, 
    maplist(terminal, Tail). 

min_length_list(StartSymbol, Lists, MinList) :-
    include(valid_expansion(StartSymbol), Lists, ValidLists), % Include only valid lists that start with the specified nonterminal and followed by terminals
    maplist(length, ValidLists, Lengths),
    min_list(Lengths, MinLength),
    member(MinList, ValidLists),
    length(MinList, MinLength).

main(NonTerm, Depth, Tail,Length) :-
    findall(Result, (build_parse_tree(NonTerm, Depth, Tree), extract_results_from_root(Tree, Result)), Results),
    min_length_list(NonTerm, Results, [_|Tail]),
    length(Tail, Length).