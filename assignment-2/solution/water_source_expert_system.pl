% This can be run as Program in Swish editors like https://swish.swi-prolog.org/
% Type start to run the Program

% Declare dynamic predicates to store user inputs. This will help us avoid prompting same input more than once.
:- dynamic lake_dist/1, river_dist/1.

% Main function
start :-
    write('Welcome to the BITS Water Source Expert System.'), nl,
    lake_distance.

% Rule for Lake Distance (Root prompt)
lake_distance :-
    (   lake_dist(LakeDist) -> true; % Check if the lake distance is already stored
        write('What is the distance to the nearest lake (in km)? '), nl,
        read(LakeDist),
        assertz(lake_dist(LakeDist))  % Store the lake distance
    ),
    (   LakeDist < 10 ->
        write('The best water source is Lake.'), nl, end;
        LakeDist >= 10 ->
        river_distance
    ).

% Rule for River Distance
river_distance :-
    (   river_dist(RiverDist) -> true; % Check if the river distance is already stored
        write('What is the distance to the nearest river (in km)? '), nl,
        read(RiverDist),
        assertz(river_dist(RiverDist))  % Store the river distance
    ),
    (   RiverDist >= 8 ->
        rainfall_intensity_high_river;
        RiverDist < 8 ->
        rainfall_intensity_low_river
    ).

% Rule for Rainfall Intensity when River Distance >= 8
rainfall_intensity_high_river :-
    write('What is the rainfall intensity (in mm)? '), nl,
    read(Rainfall),
    (   Rainfall >= 150 ->
        write('The best water source is Rain.'), nl, end;
        Rainfall < 150 ->
        sandy_aquifer
    ).

% Rule for Rainfall Intensity when River Distance < 8
rainfall_intensity_low_river :-
    write('What is the rainfall intensity (in mm)? '), nl,
    read(Rainfall),
    (   Rainfall >= 200 ->
        write('The best water source is Rain.'), nl, end;
        Rainfall < 200 ->
        write('The best water source is River.'), nl, end
    ).

% Rule for Sandy Aquifer when Rainfall < 150
sandy_aquifer :-
    write('Is there a sandy aquifer? (yes/no): '), nl,
    read(SandyAquifer),
    (   SandyAquifer == yes ->
        beach_distance;
        SandyAquifer == no ->
        lake_distance_no_sandy
    ).

% Rule for Beach Distance when Sandy Aquifer is yes
beach_distance :-
    write('What is the distance to the nearest beach (in km)? '), nl,
    read(BeachDist),
    (   BeachDist < 5 ->
        river_distance_beach;
        BeachDist >= 5 ->
        write('The best water source is Ground Water.'), nl, end
    ).

% Rule for River Distance when Beach Distance < 5
river_distance_beach :-
    (   river_dist(RiverDist) -> true; % Reuse previously stored river distance
        write('What is the distance to the nearest river (in km)? '), nl,
        read(RiverDist),
        assertz(river_dist(RiverDist))  % Store the river distance
    ),
    (   RiverDist < 20 ->
        write('The best water source is River.'), nl, end;
        RiverDist >= 20 ->
        write('The best water source is Rain.'), nl, end
    ).

% Rule for Lake Distance when Sandy Aquifer is no
lake_distance_no_sandy :-
    (   lake_dist(LakeDist) -> true; % Reuse previously stored lake distance
        write('What is the distance to the nearest lake (in km)? '), nl,
        read(LakeDist),
        assertz(lake_dist(LakeDist))  % Store the lake distance
    ),
    (   LakeDist < 14 ->
        write('The best water source is Lake.'), nl, end;
        LakeDist >= 14 ->
        write('The best water source is Rain.'), nl, end
    ).

% Ending rule
end :-
    write('Thank you for using the Water Source Expert System!'), nl,
    retractall(lake_dist(_)),  % Clear stored lake distance
    retractall(river_dist(_)).  % Clear stored river distance
