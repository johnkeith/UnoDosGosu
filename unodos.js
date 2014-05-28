var init_board = [[" "," "," "," "," "],
                  [" "," "," "," "," "],
                  [" "," "," "," "," "],
                  [" "," "," "," "," "],
                  [" "," "," "," "," "]];

function getRandLetter() {
  var letters = ["U","N","O","D","S"];
  return letters[Math.floor(Math.random() * letters.length)];
}

function getRandSpace(board) {
  var y = Math.floor(Math.random() * board.length);
  var x = Math.floor(Math.random() * board[y].length);
  // return "The value of y is " + y + " and the value of x is " + x
  return [y,x];
}

function checkSpaceOnBoard(board, space) {
  if (board[space[0]][space[1]] == " ") {
    return true
  } else {
    return false
  }
}

// debug(getRandSpace(init_board));

// debug(checkSpaceOnBoard(init_board, getRandSpace(init_board)));

function startGame(board) {
  for (var i = 0; i <= 3; i++) {
    randLetter = getRandLetter();
    emptySpace = false;
    while (emptySpace == false) {
      var randSpace = getRandSpace(board);
      if (checkSpaceOnBoard(board, randSpace) == true) {
        board[randSpace[0]][randSpace[1]] = randLetter;
        emptySpace = true;
      }
    } 
  }
  return board
}  

// debug(startGame(init_board)); 

