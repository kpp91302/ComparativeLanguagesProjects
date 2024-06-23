% packing_list(Items, Capacity, PackedItems)
packing_list(Items, Capacity, PackedItems) :-
    packing_helper(Items, Capacity, [], PackedItems).

% packing_helper(Items, RemainingCapacity, CurrentPack, PackedItems)
packing_helper([], _, CurrentPack, CurrentPack) :-
    CurrentPack \= [].
packing_helper([Item|Rest], Capacity, CurrentPack, PackedItems) :-
    Item = [_, Size],
    Size =< Capacity,
    NewCapacity is Capacity - Size,
    packing_helper(Rest, NewCapacity, [Item|CurrentPack], PackedItems).
packing_helper([_|Rest], Capacity, CurrentPack, PackedItems) :-
    packing_helper(Rest, Capacity, CurrentPack, PackedItems).

% generate_packing_lists(Items, Capacity, PackingLists)
generate_packing_lists(Items, Capacity, PackingLists) :-
    findall(PackedItems, packing_list(Items, Capacity, PackedItems), UnsortedPackingLists),
    (   UnsortedPackingLists = []
    ->  PackingLists = [[]]
    ;   exclude(is_subset(UnsortedPackingLists), UnsortedPackingLists, FilteredPackingLists),
        findall(PermutedList, (member(PackedItems, FilteredPackingLists), permutation(PackedItems, PermutedList)), PermutedPackingLists),
        sort(PermutedPackingLists, PackingLists)
    ).

% is_subset(Lists, SubList)
is_subset(Lists, SubList) :-
    member(List, Lists),
    SubList \= List,
    subset(SubList, List).

% really_go_now(InputFile, OutputFile)
really_go_now(InputFile, OutputFile) :-
    open(InputFile, read, In),
    read_input(In, Input),
    close(In),
    open(OutputFile, write, Out),
    process_input(Input, Out),
    close(Out).

read_input(In, Input) :-
    read_line_to_string(In, Line),
    (   Line = end_of_file
    ->  Input = []
    ;   split_string(Line, " ", "", [CapacityStr, ItemsStr]),
        atom_number(CapacityStr, Capacity),
        term_string(Items, ItemsStr),
        Input = [Capacity, Items | Rest],
        read_input(In, Rest)
    ).

process_input([Head, List|Tail], Out) :-
    write(Out, "Capacity: "),
    write(Out, Head),
    write(Out, " Items to pack: "), write(Out, List),
    generate_packing_lists(List, Head, PackingLists),
    (   PackingLists = []
    ->  SortedPackingLists = [[]]
    ;   PackingLists = SortedPackingLists
    ),
    write(Out, " Pack this: "), write(Out, SortedPackingLists),
    writeln(Out, ""),
    process_input(Tail, Out).

process_input([], _).

:- initialization(main).

main :-
    current_prolog_flag(argv, [InputFile, OutputFile]),
    really_go_now(InputFile, OutputFile).