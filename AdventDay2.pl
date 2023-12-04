read_lines(Stream, List) :-
    read_line_to_codes(Stream, Line),
    (   Line == end_of_file
    ->  List = []
    ;   List = [Line | More],
        read_lines(Stream, More)
    ).
read_file(File,List):- open(File, read, Stream),read_lines(Stream, List),close(Stream).

rgb("red",Amount,[_,G,B],[N,G,B])   :- number_string(N,Amount).
rgb("green",Amount,[R,_,B],[R,N,B]) :- number_string(N,Amount).
rgb("blue",Amount,[R,G,_],[R,G,N])  :- number_string(N,Amount).

grab_to_rgb([],RGB,RGB).
grab_to_rgb([H|T],Carry,RGB) :- 
    split_string(H, " ", "", [Amount, Colour]),
    rgb(Colour,Amount,Carry,NewCarry),
    grab_to_rgb(T,NewCarry,RGB).

grabs_to_rgbs([],RGBs,RGBs).
grabs_to_rgbs([H|T],Carry,RGBs) :- 
        grab_to_rgb(H,[0,0,0],RGB),
        append(Carry,[RGB],NewCarry),
        grabs_to_rgbs(T,NewCarry,RGBs).

split_grabs([],Result,Result).
split_grabs([Grab|T],Carry,Result) :- 
    split_string(Grab, ",", " ", L),
    append(Carry,[L],NewCarry),
    split_grabs(T,NewCarry,Result).

split_game([_, Grabs],L) :- split_string(Grabs, ";", " ", L).

split_games([],Result,Result).
split_games([H|T],Carry,Result) :- 
    split_string(H, ":", " ", L1),
    split_game(L1, L2),
    split_grabs(L2, [], Grab),
    grabs_to_rgbs(Grab,[],RGB),
    append(Carry,[RGB],NewCarry),
    split_games(T,NewCarry,Result).

possible_grab([R,G,B]) :- R =< 12, G =< 13, B =< 14.

possible_game([]).
possible_game([H|T]) :- 
    possible_grab(H),
    possible_game(T).

add_possible_games([],_,Result,Result).
add_possible_games([H|T],Idx,Carry,Result) :-
    possible_game(H),
    NewCarry is Carry + Idx,
    NewIdx is Idx + 1,
    add_possible_games(T,NewIdx,NewCarry,Result).
add_possible_games([_|T],Idx,Carry,Result) :-
    NewIdx is Idx + 1,
    add_possible_games(T,NewIdx,Carry,Result).

game_power([],[Rc,Gc,Bc],P)                 :- P is Rc * Gc * Bc.
game_power([[R,G,B]|T],[Rc,Gc,Bc],Result)   :- R > Rc, G > Gc, B > Bc, game_power(T,[R,G,B],Result).
game_power([[R,G,_]|T],[Rc,Gc,Bc],Result)   :- R > Rc, G > Gc, game_power(T,[R,G,Bc],Result).
game_power([[R,_,B]|T],[Rc,Gc,Bc],Result)   :- R > Rc, B > Bc, game_power(T,[R,Gc,B],Result).
game_power([[R,_,_]|T],[Rc,Gc,Bc],Result)   :- R > Rc, game_power(T,[R,Gc,Bc],Result).
game_power([[_,G,B]|T],[Rc,Gc,Bc],Result)   :- G > Gc, B > Bc, game_power(T,[Rc,G,B],Result).
game_power([[_,G,_]|T],[Rc,Gc,Bc],Result)   :- G > Gc, game_power(T,[Rc,G,Bc],Result).
game_power([[_,_,B]|T],[Rc,Gc,Bc],Result)   :- B > Bc, game_power(T,[Rc,Gc,B],Result).
game_power([[_,_,_]|T],Carry,Result)        :- game_power(T,Carry,Result).

sum_of_powers([],Result,Result).
sum_of_powers([H|T],Carry,Result) :-
    game_power(H,[0,0,0],P),
    NewCarry is Carry + P,
    sum_of_powers(T,NewCarry,Result).

print_games([],_).
print_games([H|T],Idx) :- write('Game '),write(Idx),write('\t'),write(H),nl,NewIdx is Idx + 1,print_games(T,NewIdx).

part1(File,Result) :- read_file(File,List),split_games(List,[],X),add_possible_games(X,1,0,Result).
part2(File,Result) :- read_file(File,List),split_games(List,[],X),sum_of_powers(X,0,Result).
