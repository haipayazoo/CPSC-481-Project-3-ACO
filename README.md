Program Name:
Ant Colony Optimization


Team Name: CCJ


Authors/Contact info:
Cameron Mathos - cmathos@csu.fullerton.edu
John Shelton - john.shelton789@csu.fullerton.edu
Christopher Bos - cbos95@csu.fullerton.edu


Class Number: 481


Intro:
This project is to simulate an ant colony by using a heuristic
function so that the any may move through a maze. The program
will spawn up to 50 ants that will navigate from the top left
to the bottom right of the maze. Once the ant makes it to the end,
 he returns to the maze dropping a scent that will spread
throughout the maze. After 30 ants make it to the maze, they will
display the shortest path to the maze.


External Requirements: CLISP


Setup and Usage:
The program was written in a text editor, Atom, and the code was compiled in CLISP, a GNU Common Lisp multi-architectural compiler for Windows. A link to download CLISP is provided right here:

https://sourceforge.net/projects/clisp/files/latest/download

Once you install CLISP, you compile the code by going to your Command Prompt, finding the location of the file (if you extract the file to your Desktop you would use the "cd" command to navigate to your desktop "cd Desktop") and from there you would input the command "clisp project3.lisp". The code should then compile and run with the correct path. If you want to observe the source code, just open up the file in a text editor.


Extra Features:
None


Bugs:
+ The ants have trouble being able to go from one end of the maze to the next
+ Because of the trouble of no ants making it to the end of the maze, shortest path is not displayed
+ No scent drop and spread function was created due to the fact that the ant's could not make it
to the end of the maze.
