:- dynamic current_letters/1.

name_game :-
    retractall(current_letters(_)),
    assertz(current_letters([a,b,c])),
    nl,
    writeln('Hi, this is the "Name Game".'),
    writeln('Add, move or delete letters to create your name.'),
    menu.

menu :-
    nl,
    writeln('Choose from the following:'),
    writeln('1 - Display the current set of letters'),
    writeln('2 - Add a letter at a chosen position'),
    writeln('3 - Add a letter at the top'),
    writeln('4 - Add a letter at the bottom'),
    writeln('5 - Delete a letter'),
    writeln('6 - Delete all letters'),
    writeln('7 - Exit'),
    writeln('8 - Move a letter'),
    write('Enter your choice: '),
    read(Choice),
    do_choice(Choice).

do_choice(1) :- !,
    current_letters(Letters),
    format('Current letters: ~w~n', [Letters]),
    menu.

do_choice(2) :- !,
    write('Enter a letter: '), read(Letter),
    write('Enter a position (starting at 1): '), read(Position),
    current_letters(Letters),
    length(Letters, Count),
    Max is Count + 1,
    ( valid_letter(Letter), integer(Position), between(1, Max, Position) ->
        insert_at(Position, Letter, Letters, Updated),
        save_letters(Updated),
        writeln('Letter added.')
    ;   writeln('Invalid letter or position.')
    ),
    menu.

do_choice(3) :- !,
    write('Enter a letter: '), read(Letter),
    ( valid_letter(Letter) ->
        current_letters(Letters),
        save_letters([Letter|Letters]),
        writeln('Letter added at the top.')
    ;   writeln('Please enter a single English letter.')
    ),
    menu.

do_choice(4) :- !,
    write('Enter a letter: '), read(Letter),
    ( valid_letter(Letter) ->
        current_letters(Letters),
        append(Letters, [Letter], Updated),
        save_letters(Updated),
        writeln('Letter added at the bottom.')
    ;   writeln('Please enter a single English letter.')
    ),
    menu.

do_choice(5) :- !,
    write('Enter a letter to delete: '), read(Letter),
    current_letters(Letters),
    ( select(Letter, Letters, Updated) ->
        save_letters(Updated),
        writeln('Letter deleted.')
    ;   writeln('That letter is not in the list.')
    ),
    menu.

do_choice(6) :- !,
    save_letters([]),
    writeln('All letters deleted.'),
    menu.

do_choice(7) :- !,
    writeln('Goodbye!').

do_choice(8) :- !,
    write('Enter a letter to move: '), read(Letter),
    current_letters(Letters),
    ( select(Letter, Letters, Without) ->
        length(Without, Count),
        Max is Count + 1,
        format('New position (1-~d): ', [Max]),
        read(Position),
        ( integer(Position), between(1, Max, Position) ->
            insert_at(Position, Letter, Without, Updated),
            save_letters(Updated),
            writeln('Letter moved.')
        ;   writeln('Invalid position.')
        )
    ;   writeln('That letter is not in the list.')
    ),
    menu.

do_choice(_) :-
    writeln('Invalid choice. Try again.'),
    menu.

valid_letter(Letter) :-
    atom(Letter),
    atom_length(Letter, 1),
    char_type(Letter, alpha).

insert_at(1, Letter, Letters, [Letter|Letters]) :- !.
insert_at(Position, Letter, [Head|Tail], [Head|Updated]) :-
    Position > 1,
    Next is Position - 1,
    insert_at(Next, Letter, Tail, Updated).

save_letters(Letters) :-
    retractall(current_letters(_)),
    assertz(current_letters(Letters)).

% Result
% 102 ?- name_game.

% Hi, this is the "Name Game".
% Add, move or delete letters to create your name.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: 1.
% Current letters: [a,b,c]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% |: 2.
% Enter a letter: |: n.
% Enter a position (starting at 1): |: 2.
% Letter added.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [a,n,b,c]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 3.
% Enter a letter: |: o.
% Letter added at the top.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [o,a,n,b,c]
% hoose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 4.
% Enter a letter: |: f.
% Letter added at the bottom.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [o,a,n,b,c,f]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 5.
% Enter a letter to delete: |: b.
% Letter deleted.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [o,a,n,c,f]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 6.
% All letters deleted.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: []
% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 4.
% Enter a letter: |: n.
% Letter added at the bottom.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [n]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 4.
% Enter a letter: |: o.
% Letter added at the bottom.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [n,o]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 4.
% Enter a letter: |: o.
% Letter added at the bottom.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [n,o,o]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 4.
% Enter a letter: |: f.
% Letter added at the bottom.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [n,o,o,f]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 8.
% Enter a letter to move: |: f.
% New position (1-4): |: 1.
% Letter moved.

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 1.
% Current letters: [f,n,o,o]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: |: 8.
% Enter a letter to move: |: f.
% New position (1-4): |: 4.
% Letter moved.

% Expected continuation (not captured in the original transcript)
% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: 1.
% Current letters: [n,o,o,f]

% Choose from the following:
% 1 - Display the current set of letters
% 2 - Add a letter at a chosen position
% 3 - Add a letter at the top
% 4 - Add a letter at the bottom
% 5 - Delete a letter
% 6 - Delete all letters
% 7 - Exit
% 8 - Move a letter
% Enter your choice: 7.
% Goodbye!
% true.
