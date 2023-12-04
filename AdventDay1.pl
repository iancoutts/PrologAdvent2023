read_lines(Stream, List) :-
    read_line_to_codes(Stream, Line),
    (   Line == end_of_file
    ->  List = []
    ;   List = [Line | More],
        read_lines(Stream, More)
    ).
read_file(File,List):- open(File, read, Stream),read_lines(Stream, List),close(Stream).

list_starts_list([], _ ).
list_starts_list([H|T1],[H|T2]) :- list_starts_list(T1,T2).

atom_starts_list(A,L) :- atom_codes(A,ACodes),list_starts_list(ACodes,L).

first_number_in_codes(Codes,48) :- atom_starts_list(zero,Codes).
first_number_in_codes(Codes,49) :- atom_starts_list(one,Codes).
first_number_in_codes(Codes,50) :- atom_starts_list(two,Codes).
first_number_in_codes(Codes,51) :- atom_starts_list(three,Codes).
first_number_in_codes(Codes,52) :- atom_starts_list(four,Codes).
first_number_in_codes(Codes,53) :- atom_starts_list(five,Codes).
first_number_in_codes(Codes,54) :- atom_starts_list(six,Codes).
first_number_in_codes(Codes,55) :- atom_starts_list(seven,Codes).
first_number_in_codes(Codes,56) :- atom_starts_list(eight,Codes).
first_number_in_codes(Codes,57) :- atom_starts_list(nine,Codes).
first_number_in_codes([H|_],H) :- integer(H), H >= 48, H =< 57.
first_number_in_codes([_|T],X) :- first_number_in_codes(T,X).

last_number_in_codes(Codes,48) :- atom_starts_list(orez,Codes).
last_number_in_codes(Codes,49) :- atom_starts_list(eno,Codes).
last_number_in_codes(Codes,50) :- atom_starts_list(owt,Codes).
last_number_in_codes(Codes,51) :- atom_starts_list(eerht,Codes).
last_number_in_codes(Codes,52) :- atom_starts_list(ruof,Codes).
last_number_in_codes(Codes,53) :- atom_starts_list(evif,Codes).
last_number_in_codes(Codes,54) :- atom_starts_list(xis,Codes).
last_number_in_codes(Codes,55) :- atom_starts_list(neves,Codes).
last_number_in_codes(Codes,56) :- atom_starts_list(thgie,Codes).
last_number_in_codes(Codes,57) :- atom_starts_list(enin,Codes).
last_number_in_codes([H|_],H) :- integer(H), H >= 48, H =< 57.
last_number_in_codes([_|T],X) :- last_number_in_codes(T,X).

tail_number_in_codes(Codes,X) :- reverse(Codes,RevCodes),last_number_in_codes(RevCodes,X).

first_last_numbers_in_codes(Codes,[H,T]) :- first_number_in_codes(Codes,H),tail_number_in_codes(Codes,T).

extract_values([],[]).
extract_values([H|T],[A|B]) :- first_last_numbers_in_codes(H,Codes),number_codes(A,Codes),extract_values(T,B).

day1(File,X) :- read_file(File,Crypts),extract_values(Crypts,Values),sum_list(Values,X).
