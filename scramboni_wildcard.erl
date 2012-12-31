#!/usr/bin/env escript

% This is an Erlang version of the subanagram generator.

% It takes a word at the command line as an argument.
% e.g.: `./scramboni.erl representative`

% It delivers as output the words that are eligible subanagrams, ordered in length from shortest to longest, 
% along with the number of Scrabble points from each word, assuming no double or triple letter or word squares.

% Unlike scramboni, you can submit wildcards to this script:
% e.g.: `./scramboni_wildcard.erl *evation*`
% Wildcards are rendered as asterisks, maximum two wildcards at a time.
% The use of wildcards has been shown to slow down performance.  Patience is requested.

% Note: You need a file of words, one word per line, in the same directory as the script.

main([Original_word]) ->
	List_of_words = file_parse("ospd3.txt"),
	Subanagrams = sa_function(string:to_lower(Original_word), List_of_words),
	Subanagram_sublists = lists:map(fun(Word_length) -> get_length(Subanagrams, Word_length) end, [2,3,4,5,6,7,8]),
	print_sorted_lists(Subanagram_sublists).

print_sorted_lists(Sorted_lists) ->
	lists:map(fun(Sorted_list) -> print_line(Sorted_list) end, Sorted_lists).

print_line(Sorted_list) ->
	Points_list = dict:from_list([{$a, 1}, {$b,3}, {$c, 3}, {$d, 2}, {$e, 1}, {$f, 4}, {$g, 2}, {$h, 4}, {$i, 1}, {$j, 8}, {$k, 5}, {$l, 1}, {$m, 3}, {$n, 1}, {$o, 1}, {$p, 3}, {$q, 10}, {$r, 1}, {$s, 1}, {$t, 1}, {$u, 1}, {$v, 4}, {$w, 4}, {$x, 8}, {$y, 4}, {$z, 10}]),
	lists:map(fun(Word) -> io:fwrite("~s ~w~n", [Word, lists:sum(lists:map(fun(Letter) -> dict:fetch(Letter, Points_list) end, Word))]) end, Sorted_list).

get_length(List_of_words, Length_to_search_for) ->
	lists:filter(fun(Word) -> length(Word) =:= Length_to_search_for end, List_of_words). 

file_parse(File) ->
	{ok, S} = file:open(File, [read,binary,raw]),
	Size = filelib:file_size(File), 
	{ok, B1} = file:pread(S, 0, Size),
	string:tokens(binary_to_list(B1), "\n").

sa_function(Original, List_of_words) -> 
	lists:filter(fun(Subanagram) -> length(Subanagram -- (Original -- "**")) =:= round(lists:sum(lists:filter(fun(X) -> lists:member(X, "*") end, Original)) / 42) end, List_of_words).

