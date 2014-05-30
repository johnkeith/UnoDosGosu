unodos
======

UNO – DOS Game Design Document

David Pointeau & John Keith

Web + Mobile 


Overview:

Uno – Dos is very similar to 2048 to the extent that the player interacts with tiles on a visual grid. 
Instead of having numbers on the grid, each tile will have one of the following five letters: “U”, “N”, “S”, “D”, and “O”.  
Nothing else will be on the grid a part from those five letters randomly spawned on the grid. 
The grid will be 5 x 5 so a total of 25 tiles. The goal of the game is to move the tiles in such a way to obtain either 
the words “UNO” or “DOS” by moving unique tiles in order to make them join with the correct sequence of letters. 
Every 4 seconds (to be determined) a new random letter will be spawned randomly on the board. 
The movement dynamics will be specified further down.

Victory/Loss conditions:

There’s basically only one way the game ends: when all the tiles are filled with letters. 
Unlike 2048, tiles don’t merge with each other and disappear. When an “UNO” or “DOS” is detected, that block of three 
letters making up the word changes colors signaling the player that he/she has achieved making one word. 
The player can still decide to move those tiles at his own risk. Tiles are always in play. 
The goal of the game is to have as many “UNO” and “DOS” when the gird is full and the game stops.
		
	              Different possible sequences:

	             	=> U N O or D O S  (left to right)
		
                      U       D
                =>    N  or   O    (top to bottom)
		      O       S
		                  
		                      D
		            =>    U N O  (combos)
		                      S
		                      
		                      
		                      
Movement Dynamics:

Unlike 2048 where one movement moves all the tiles to the extremity of the grid when a direction is specified, 
UNO – DOS only allows the player to move one tile at a time, one space at a time. For the web version, 
click with the mouse and drop to the adjacent tile. For mobile device, just flick a tile in the direction you want.
Movements have to be fast! Remember every 4 seconds a new letter is generated.

Scoring:

Unlike 2048 where the score is incremented every time the player makes a move, the scoring algorithm for UNO – DOS 
will only kick in at the end of the game when the entire grid is full. The scoring function will go through the grid 
row by row and search for all the words “UNO” and “DOS” present in the grid. If the function finds “UNO”, “DOS”, “UNO” 
the final score will be: “121”. Basically the total temporary score will contain a sequence of “1” and “2”. 
Once the scoring function is down counting the successful sequences of UNO and DOS, it will then count all the tiles 
that have been unused and decrement the total temporary score composed of 1 and 2 by 10pts every time an unused tile is 
encountered.


Starting Board:

At the start of the game, the word “UNO” will be placed in the center of the game. Under the board there will be a PLAY 
button. As soon as the player clicks on that PLAY button, the letters “U”, “N”, “O” forming the original word “UNO” are 
randomly placed in different tiles of the grid. Simultaneously, as soon as the player hits that PLAY button, 
a countdown of 4 seconds starts (represented by four colored dots filling up from left to right). 
This will give the player an initial idea of how long 4 seconds is and how it is visually represented in the game 
since a new tile will be randomly spawned every 4 seconds for the entire duration of the game.
As soon as the PLAY button is clicked, movement on the board is enabled and the user can start immediately playing. 
The 4 seconds give the player an extra chance to start the game right and get familiar with the movement dynamics. 


Visual Elements:

In order to make the game playable and give the player a good visual representation of what is happening every turn,
tiles with different letters will have different colors. Empty tiles will be represented by the color grey. 
Since “O” is the most recurrent letter and the most valuable (both in the word dos and uno), all “O”s on the board 
will have one distinct bright color to attract the player’s gaze. The letters “U” and “N” will have different colors 
but of the same shade (variations of orange for example) since they are both used to form the word “UNO”. 
Similarly for the word “DOS”, the letters “D” and “S” will be of different colors but similar shading.
As the game progresses and every time the player does manage to get the word “UNO” or “DOS”, those three consecutive tiles 
forming those words will change all the tiles forming those two words into one distinct color to help the player visualize 
what he has achieved. 

Like it was mentioned in the starting board section, the timer will not be represented by a decrementing count of 
integers but rather by four circles lined up in a row “ o o o o ” under the board. Every second, the circles will fill up 
from left to right. When the last circle is filled up, 4 seconds have been reached and the circles empty up and restart. 
Optional: Have a visual representation of the scoring system at the end. 
Just like the game “Threes” where as soon as the board is full, the scoring algorithm kicks in and adds “+” every time the
words “UNO” or “DOS” are encountered, adding to the total score on top of the board. Same, for all the tiles that are unused,
“-“ will be added every time an unused letter is encountered, and the total score is decremented. 
Also, the designs of the grid can be tweaked in different ways to make the game look nicer. 
Implementation details will change as we code.
Optional: Adding animations.

Optional Add-ons:

=>Maybe give the player one/two/three possible pause buttons in order to pause the game for ten seconds at any given time 
so that he/she has time to plan strategy and take a breath.

=>Implement high scores?

=>Add audio components? Every time the player scores an UNO the game could spit out “UNO” in a Spanish accent, 
same for “DOS”.

Playability:

As soon as the game is over and the scoring is completed the player should be able to restart the game very fast.
