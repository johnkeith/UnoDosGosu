var board = [[" "," "," "," "," "],
            [" "," "," "," "," "],
            [" "," "," "," "," "],
            [" "," "," "," "," "],
            [" "," "," "," "," "]];

var letters = ["U","N","O","D","O",
               "U","N","O","O","S",
               "U","N","O","D","S",
               "U","O","O","D","S",
               "O","N","O","D","S"];

function getRandLetter() {
  random_postion = Math.floor(Math.random() * letters.length);
  return letters.splice(random_postion,1);
}

function insertIntoEmptySpace() {
  var random_direction = Math.floor(Math.random()*2);
  var insert_successful = false;
  while (insert_successful === false) {
    var random_row = Math.floor(Math.random() * board.length);
    empty_space = board[random_row].indexOf(" ");
    if (empty_space != -1) {
      board[random_row][empty_space] = getRandLetter();
      insert_successful = true;
    }
  }
}

function startGame() {
  for (var i = 0;i <= 3; i++) {
    insertIntoEmptySpace();
  }
}

startGame();
debug(board);

