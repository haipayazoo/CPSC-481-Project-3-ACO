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

; A temporary test maze so that we don't have to work with a huge maze first
(defvar *test_maze* (make-array '(4 4)
  :element-type 'single-float
  :initial-contents
  '((0 0 -1 0)
    (0 0 -1 0)
    (0 0 -1 0)
    (0 0  0 0))))

; The list of ants that are currently in the maze
; Each ant has the current path and whether or not they've reached the goal
(defvar *ants* '())

; The list of ants that have reached the goal
(defvar *reached_goal* 0)

; The list of best paths from each ant that made it towards the goal
(defvar *best_paths* '())

; The tabu list of each ants
(defvar *tabu_list* '())

; This holds a list of each ant's current location
(defvar *ant_locations* (list))

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
  (setq *ants* (append *ants* (list(list(list nil '(0 0))))))

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
      (if (= (list-length candidates) 0)

        (progn
          (replace (nth i *tabu_list*) '())
          (setq candidates (valid_moves i))
        )

      )

      ; Calls the heuristic function to find the best move
      (setq best_move (heuristic_function candidates))


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

; The heurisitic function we will use to calculate the best candidate cell
; for the ant to move
(defun heuristic_function (candidates)

  (loop for i in candidates
    do
      (print i)
  )
)

; The main function of the ant colony project
(defun aco ()

  ; Creates the first ant into the maze
  (create_ant)

  ; Main iteration loop that continues until 30 ants have reached the goal
  ;loop while (*reached_goal* < 30) do

    (move_ant)

  ;)

  ; USING FOR TESTING vvv
  ;(setf (nth 1 *ants*) (append (list (nth 1 *ants*) '(1 1))))

)

(aco)
