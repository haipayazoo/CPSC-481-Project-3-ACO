;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Authors: 		Cameron Mathos - cmathos@csu.fullerton.edu
;				      John Shelton - john.shelton789@csu.fullerton.edu
;           	Christopher Bos - cbos95@csu.fullerton.edu
;
;Team Name: 	CCJ
;
;Description: This project is to simulate an ant colony by using a heuristic
;             function so that the any may move through a maze. The program
;             will spawn up to 50 ants that will navigate from the top left
;             to the bottom right of the maze. Once the ant makes it to the end,
;             he returns to the maze dropping a scent that will spread
;             throughout the maze. After 30 ants make it to the maze, they will
;             display the shortest path to the maze.

; GLOBAL VARIABLES

; The maze that will be used for the ants to traverse (currently using grid-a)
; The maze is using floating point numbers instead of -'s and x's so that we
; can better track the phereomone values in each cell of the maze.
;-1's represents represents the x's (the walls of the maze)
; 0's represent the empty cells
; Any values higher than 0 are cells with a scent
(defvar *maze* (make-array '(40 60)
  :element-type 'single-float
  :initial-contents
    '((0   0  0  0  0 -1  0 -1  0  0  0  0 -1  0  0  0  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0  0  0  0  0)
      (0  -1  0  0  0 -1  0 -1  0  0  0  0 -1  0 -1  0  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0 -1 -1 -1 -1 -1 -1  0 -1  0  0  0 -1  0  0  0  0  0  0)
      (0  -1  0  0  0 -1  0 -1  0 -1  0 -1 -1  0 -1 -1 -1 -1 -1  0  0 -1 -1  0  0 -1 -1  0  0  0  0 -1  0 -1  0  0 -1  0 -1  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0 -1  0 -1  0 -1 -1 -1)
      (0  -1  0  0  0 -1  0  0  0  0  0  0  0  0 -1  0  0  0  0  0  0 -1  0  0  0  0 -1  0  0 -1 -1 -1  0 -1  0  0  0  0 -1  0  0  0  0  0  0 -1  0 -1  0 -1  0  0  0 -1  0 -1  0 -1  0  0)
      (0  -1  0  0  0  0  0 -1  0  0  0  0 -1  0 -1 -1 -1 -1  0  0 -1 -1  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1  0  0 -1 -1 -1  0  0 -1 -1  0 -1  0 -1  0  0  0 -1  0  0  0 -1  0  0)
      (0  -1  0  0  0 -1  0 -1  0  0 -1 -1  0  0 -1  0  0  0  0 -1  0  0  0  0  0  0 -1 -1 -1  0  0 -1  0 -1  0  0 -1  0 -1  0  0  0  0  0  0 -1  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0  0)
      (0  -1  0  0  0  0  0 -1  0  0  0  0 -1  0 -1  0  0  0  0 -1  0 -1  0  0 -1 -1 -1  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0 -1  0  0  0 -1  0  0  0  0  0  0)
      (0  -1  0  0  0 -1  0  0  0  0  0  0 -1  0  0  0  0  0  0 -1  0 -1  0  0 -1  0 -1  0  0 -1  0 -1  0 -1  0  0 -1  0 -1  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0 -1 -1 -1 -1  0 -1  0)
      (0   0  0  0  0 -1  0 -1  0  0  0  0 -1  0 -1  0 -1 -1  0 -1  0 -1  0  0 -1  0 -1  0  0 -1  0 -1 -1 -1 -1 -1 -1  0 -1 -1 -1  0 -1 -1 -1 -1  0 -1  0  0  0  0  0 -1  0  0  0  0  0  0)
      (-1 -1 -1 -1 -1 -1 -1 -1  0 -1 -1 -1  0 -1 -1  0  0  0  0  0  0 -1  0  0 -1  0  0  0  0 -1  0 -1  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1  0 -1  0 -1 -1 -1  0 -1  0 -1  0 -1  0  0)
      (0  -1  0 -1  0  0  0  0 -1  0  0  0 -1  0 -1 -1  0 -1  0 -1  0 -1  0  0  0  0  0  0  0 -1  0  0  0  0  0 -1 -1  0  0 -1 -1  0  0  0  0 -1  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0)
      (0   0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1  0 -1  0  0  0  0  0 -1  0 -1  0  0  0  0)
      (0   0  0 -1 -1  0 -1  0  0  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1  0 -1  0  0  0  0 -1  0  0  0 -1  0  0 -1  0 -1  0  0 -1 -1  0  0 -1  0  0  0 -1  0 -1  0 -1 -1  0  0 -1)
      (0  -1  0  0  0  0  0  0 -1  0  0  0 -1  0 -1  0 -1  0 -1 -1 -1 -1  0 -1  0 -1 -1 -1 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0 -1  0 -1  0  0  0  0)
      (0  -1  0 -1  0  0  0  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0  0  0 -1  0  0  0  0  0  0 -1  0  0  0  0  0 -1  0 -1 -1 -1  0 -1 -1  0)
      (-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1 -1  0  0  0  0  0  0)
      (0  -1  0  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0  0  0  0  0 -1  0  0  0 -1  0  0  0  0 -1  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0)
      (0  -1  0  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0  0  0  0  0 -1  0  0  0  0  0 -1  0 -1 -1  0  0  0  0  0  0  0  0 -1  0 -1 -1 -1  0 -1 -1 -1  0 -1  0 -1 -1  0 -1 -1)
      (0  -1  0  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0 -1  0 -1 -1 -1  0  0  0 -1  0  0  0  0  0  0  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0)
      (0   0  0  0 -1  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0  0 -1  0  0 -1  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0)
      (0   0  0  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0 -1  0 -1  0  0  0 -1  0 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0 -1  0  0  0  0  0  0)
      (0  -1  0  0 -1  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0 -1  0  0  0 -1  0  0 -1  0 -1  0  0  0 -1  0 -1 -1 -1  0 -1  0 -1)
      (0  -1  0  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0 -1  0  0  0  0  0  0 -1 -1 -1 -1 -1  0 -1 -1  0 -1 -1  0  0  0 -1  0  0 -1  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0)
      (0  -1 -1  0 -1 -1 -1 -1  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0 -1  0  0  0 -1  0 -1  0  0  0 -1  0 -1)
      (0   0  0  0 -1  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0 -1  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1 -1 -1  0  0  0  0  0 -1  0  0 -1  0 -1  0  0  0 -1  0 -1  0 -1  0  0  0  0)
      (0   0 -1  0 -1  0  0  0  0  0  0  0 -1  0  0  0 -1  0  0  0  0  0  0  0  0 -1  0 -1  0  0 -1  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0  0  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0)
      (0   0 -1  0 -1 -1 -1  0 -1  0 -1  0 -1  0  0  0 -1  0  0 -1  0  0  0  0  0 -1  0 -1  0  0 -1  0  0  0  0  0  0  0 -1  0  0  0 -1  0  0 -1 -1  0  0  0  0 -1  0 -1  0 -1 -1 -1  0 -1)
      (0   0 -1  0 -1  0  0  0  0  0 -1  0 -1  0 -1 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1  0 -1 -1 -1  0 -1 -1 -1  0 -1 -1  0 -1  0  0  0 -1  0 -1  0  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0)
      (0   0 -1  0 -1  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0  0  0 -1  0  0  0 -1  0 -1 -1 -1 -1 -1  0  0)
      (0   0  0  0 -1 -1  0 -1  0 -1 -1  0 -1 -1  0 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1  0 -1  0  0 -1 -1 -1 -1  0  0 -1  0  0  0  0  0 -1  0 -1  0  0 -1  0  0  0 -1  0  0  0  0  0  0  0  0)
      (-1 -1  0  0 -1  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0)
      (0   0  0  0 -1  0  0  0  0  0 -1  0 -1 -1 -1 -1 -1  0 -1 -1 -1  0 -1 -1 -1 -1  0 -1  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0 -1  0 -1  0  0 -1  0  0  0 -1  0 -1  0  0  0  0  0  0)
      (-1  0 -1  0 -1  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0  0  0  0  0 -1 -1 -1 -1  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0 -1 -1  0 -1  0 -1 -1)
      (0   0  0  0 -1 -1 -1 -1  0  0 -1  0  0  0  0  0  0  0  0 -1 -1  0 -1  0 -1 -1  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0 -1  0  0  0  0 -1  0)
      (0   0  0  0 -1  0  0  0  0  0 -1  0 -1  0  0  0 -1  0  0 -1  0  0  0 -1  0 -1  0  0 -1  0 -1  0  0  0  0  0  0  0 -1  0  0  0 -1  0  0  0  0  0  0 -1  0 -1  0 -1  0  0  0  0 -1  0)
      (0  -1 -1  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0 -1  0  0 -1  0  0  0 -1 -1 -1 -1 -1  0  0  0  0  0 -1  0 -1  0 -1 -1 -1  0  0 -1  0 -1  0  0 -1 -1 -1  0)
      (0   0  0  0 -1  0  0 -1  0  0 -1  0 -1  0  0  0 -1  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0 -1  0)
      (0   0 -1 -1  0  0  0 -1  0  0  0  0  0  0  0  0 -1  0  0 -1  0  0  0  0  0 -1  0  0  0  0 -1  0  0  0  0  0  0  0 -1  0  0  0 -1  0  0  0  0  0  0 -1  0 -1  0 -1  0  0 -1 -1 -1  0)
      (0   0  0  0 -1  0  0 -1  0  0 -1 -1 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0 -1 -1 -1 -1 -1 -1 -1  0  0  0  0  0  0)
      (0   0  0  0 -1  0  0 -1  0  0 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0))))


; The list of ants that are currently in the maze
; Each ant has the current path and whether or not they've reached the goal
(defvar *ants* '())

; A list of the ant's respective state of foraging or returning
(defvar *foraging* '())

; The tabu list of each ants
(defvar *tabu_list* '())

; This holds a list of each ant's current location
(defvar *ant_locations* (list))

; The list of ants that have reached the goal
(defvar *reached_goal* 0)

; Some of the parameters specified in the project
(defvar *scent_drop* 10)
(defvar *scent_spread* 0.1)
(defvar *balance_factor* 0.1)
(defvar *tabu_limit* 8)


;FUNCTIONS

; Creates and initializes an ant at the coordinate 0,0
(defun create_ant ()

  ; Adds a new ant to the ant maze
  ; NIL means the ant has not reached the goal
  (setq *ants* (append *ants* (list(list(list 0 0)))))

  ; 0 means the ants are foraging, 1 means they are returning
  (setq *foraging* (append *foraging* (list 0)))

  ; Initializes the tabu list of the new ant
  (setq *tabu_list* (append *tabu_list* (list(list(list 0 0)))))

  ; Initializes the ant's current location in the maze
  (setq *ant_locations* (append *ant_locations* (list(list 0 0))))

)

; Moves an ant from the list of ants in the maze
(defun move_ant ()

  ; Loops for every ant in the list
  (loop for i from 0 to (- (list-length *ant_locations*) 1)
    do

      ; Finds valid moves of the ant
      (setq candidates (valid_moves i))

      ; If there are no valid moves, then the ant is completely stuck
      ; We need to wipe the tabu list of that ant so that it may continue
      ; We retry valid_moves function afterwards
      (if (= (list-length candidates) 0)

        (progn
          (replace (nth i *tabu_list*) '())
          (setq candidates (valid_moves i))
        )

      )

      ; Calls the heuristic function to find the best move
      (setq best_move (heuristic_function candidates i))

      ; Moves the ants' current location
      (replace (nth i *ant_locations*) best_move)

      ; Appends the move to the ant's path taken so far
      (setf (nth i *ants*) (append (nth i *ants*) (list best_move)))

      ; If the tabu list has reached the tabu limit, then it is emptied
      (if (> (list-length (nth i *tabu_list*)) *tabu_limit*)

        (replace (nth i *tabu_list*) '())

      )

      ; Adds the move to the tabu list
      (setf (nth i *tabu_list*) (append (nth i *tabu_list*) (list best_move)))

      ; Check to see if the ant has reached the goal
      (if (and (= (nth 0 (nth i *ant_locations*)) 40)
               (= (nth 1 (nth i *ant_locations*)) 60))

              (progn

                 ; The goal counter is incremented by one
                 (setq *reached_goal* (+ *reached_goal* 1))

                 ; Ant switching from foraging to returning
                 (replace (nth i *foraging*) 1)

              )
      )
    )
)

; Finds valid moves based on location of ant, tabu list, and maze walls
(defun valid_moves (index)

  ; Gets the location of the ant as well as the tabu list of that ant
  (setq ant_location (nth index *ant_locations*))
  (setq ant_tabu (nth index *tabu_list*))

  ; Acquires the row and column of the ant's current ant_location
  (setq row (nth 0 ant_location))
  (setq col (nth 1 ant_location))


  ; Initializes a list of the possible cell moves that will be returned
  (setq candidates '())

  ; Checks to see if the cell below is out-of-bounds
  (if (<= (+ row 1) 39)

    ; Checks to see if the cell below hits a wall
    (if (/= (aref *maze* (+ row 1) col) -1.0)

      ; Checks to see if the cell below is in the tabu list
      (if (/= (in_tabu_list ant_tabu (list (+ row 1) col)) 1)

        ; The cell below meets the conditions and is picked as a candidate
        (setq candidates (append candidates (list (list (+ row 1) col))))

      )

    )

  )

  ; Checks to see if the cell on top is out-of-bounds
  (if (>= (- row 1) 0)

    ; Checks to see if the cell on top hits a wall
    (if (/= (aref *maze* (- row 1) col) -1.0)

      ; Checks to see if the cell on top is in the tabu list
      (if (/= (in_tabu_list ant_tabu (list (- row 1) col)) 1)

        ; The cell on top meets the conditions and is picked as a candidate
        (setq candidates (append candidates (list (list (- row 1) col))))

      )

    )

  )

  ; Checks to see if the cell to the right is out-of-bounds
  (if (<= (+ col 1) 59)

    ; Checks to see if the cell to the right hits a wall
    (if (/= (aref *maze* row (+ col 1)) -1.0)

      ; Checks to see if the cell to the right is in the tabu list
      (if (/= (in_tabu_list ant_tabu (list row (+ col 1))) 1)

      ; The cell to the right meets the conditions and is picked as a candidate
        (setq candidates (append candidates (list (list row (+ col 1)))))

      )

    )

  )

  ; Checks to see if the cell to the left is out-of-bounds
  (if (>= (- col 1) 0)

  ; Checks to see if the cell to the left hits a wall
    (if (/= (aref *maze* row (- col 1)) -1.0)

      ; Checks to see if the cell to the left is in the tabu_list
      (if (/= (in_tabu_list ant_tabu (list row (- col 1))) 1)

        ; The cell to the left meets the conditions and is picked as a candidate
        (setq candidates (append candidates (list (list row (- col 1)))))

      )

    )

  )

  ; Returns the potential candidates of the ant
  candidates

)

; This function checks to see if the candidate move is already in
; the tabu list
(defun in_tabu_list (ant_tabu cell)

    ; If founnd is 0, then the candidate cell is not in the tabu list
    (setq found 0)

    ; Loops for each entry in the ant's tabu list
    (loop for i in ant_tabu do

      ;Checks the coordinates of each move in the tabu list with candidate's
      (if (and (= (nth 0 i) (nth 0 cell)) (= (nth 1 i)  (nth 1 cell)))

        ; If there is one found, then we set found to 1
        ; Indicating that we've found one
        (setq found 1)
      )

    )

    ; Returns whether found or not
    found

)

; The heurisitic function we will use to calculat e the best candidate cell
; for the ant to move
(defun heuristic_function (candidates index)

  (setq best_move_value -100)
  (setq best_move '())

  ; Loops for each candidate cell
  (loop for candidate in candidates
    do

      ; This sets up the heuristic function formula to determine the winning
      ; move
      (setq mode_value (mode candidate index))
      (setq scent_value (* *balance_factor* (aref *maze* (nth 0 candidate)(nth 1 candidate))))
      (setq random_fuzz (float (/ (- (random 161) 80) 100.0)))
      (setq heuristic_value (+ mode_value scent_value random_fuzz))

      ; If the heuristic value calculated is better than the current
      ; then replace it
      (if (< best_move_value heuristic_value)

        (progn

          (setq best_move_value heuristic_value)
          (setq best_move candidate)

        )
      )
  )

  best_move
)

; Either gets deltamax if foraging or deltasum if returning
(defun mode (candidate index)

  ; If the ant is foraging we compute the deltamax
  ; Delta max is the difference between the max of the candidate cell and
  ; the ant's current cell
  (if (= (nth index *foraging*) 0)

    (progn
      ; Acquires the max coordinate of the candidate cell
      (if (> (nth 0 candidate) (nth 1 candidate))

        (setq max_neighbor (nth 0 candidate))

        (setq max_neighbor (nth 1 candidate))

      )

      ; Acquires the max coordinate of the ant's current cell
      (if (> (nth 0 (nth index *ant_locations*)) (nth 1 (nth index *ant_locations*)))

        (setq max_current (nth 0 (nth index *ant_locations*)))

        (setq max_current (nth 1 (nth index *ant_locations*)))

      )

      (setq mode (- max_current max_neighbor))

    )

  )

  ; If the returning than we compute the deltasum
  ; The deltasum is the difference between the sum of the candidate cell and
  ; the ant's current cell
  (if (= (nth index *foraging*) 1)

    (progn

      (setq candidate_sum (+ (nth 0 candidate)(nth 1 candidate)))
      (setq current_sum (+ (nth 0 (nth index *ant_locations*)) (nth 1 (nth index *ant_locations*))))
      (setq mode (- candidate_sum current_sum))
    )

  )

  mode

)

; Acquires the shortest path from the ants that have finished
(defun shortest_list()

  (setq shortest_path '())

  (loop for i from 0 to (list-length *ants*) do

    (if (> (list-length (nth i *ants*)) (list-length shortest_path))
      (setq shortest_path (nth i *ants*))
    )

  )

  (print shortest_path)

)

; The main function of the ant colony project
(defun aco ()

  ; Creates the first ant into the maze
  (create_ant)

  ; Main iteration loop that continues until 30 ants have reached the goal
  (loop while (< *reached_goal* 30) do

    ; Moves each ant
    (move_ant)

    ; If the length of the ant is less than 50 than spawn another ant
    (if (< (list-length *ant_locations*) 50)
      (create_ant)
    )


    (shortest_list)

  )


)

(aco)
