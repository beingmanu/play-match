import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import 'helper.dart';
import 'peice.dart';

class ChessGameProvider with ChangeNotifier {
  List<List<ChessPiece?>>? board;

  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;

  bool? isLocaluserTurn;

  List<List<int>> validMoves = [];

  List<ChessPiece> whitePiecesTaken = [];
  List<ChessPiece> blackPiecesTaken = [];

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  changeTurn(bool islocalTurn) {
    isLocaluserTurn = islocalTurn;
    notifyListeners();
  }

  initBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(
        8,
        (index) => null,
      ),
    );

//init pwan
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: FontAwesomeIcons.solidChessPawn,
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: FontAwesomeIcons.chessPawn,
      );
    }

    //init rook
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessRook,
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessRook,
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessRook,
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessRook,
    );

    //init knights
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessKnight,
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessKnight,
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessKnight,
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessKnight,
    );

    //init bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessBishop,
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessBishop,
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessBishop,
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessBishop,
    );

    //init Queen
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessQueen,
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessQueen,
    );

    //init King
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: FontAwesomeIcons.solidChessKing,
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: FontAwesomeIcons.chessKing,
    );

    board = newBoard;
    notifyListeners();
  }

  void pieceSelected(int row, int col, BuildContext context) {
    if (selectedPiece == null && board![row][col] != null) {
      if (board![row][col]!.isWhite == isLocaluserTurn) {
        selectedPiece = board![row][col];
        selectedRow = row;
        selectedCol = col;
      }
    } else if (board![row][col] != null &&
        board![row][col]!.isWhite == selectedPiece!.isWhite) {
      selectedPiece = board![row][col];
      selectedRow = row;
      selectedCol = col;
    } else if (selectedPiece != null &&
        validMoves.any(
          (element) => element[0] == row && element[1] == col,
        )) {
      movePiece(row, col, context);
    }

    validMoves =
        calculateRealValidMoves(selectedRow, selectedCol, selectedPiece!, true);
    notifyListeners();
  }

  calculateRawValidMoves(int row, int col, ChessPiece piece) {
    List<List<int>> candidateMoves = [];
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        if (isInBoard(row + direction, col) &&
            board![row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board![row + 2 * direction][col] == null &&
              board![row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        if (isInBoard(row + direction, col - 1) &&
            board![row + direction][col - 1] != null &&
            board![row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board![row + direction][col + 1] != null &&
            board![row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
        // horizontal and vertical directions
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], //left
          [0, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board![newRow][newCol] != null) {
              if (board![newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // kill
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        // all eight possible L shapes the knight can move
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, 2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board![newRow][newCol] != null) {
            if (board![newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // capture
            }
            continue; // blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        var directions = [
          [-1, -1], // up
          [-1, 1], // down
          [1, -1], //left
          [1, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board![newRow][newCol] != null) {
              if (board![newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // capture
              }
              break; // block
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
      case ChessPieceType.queen:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board![newRow][newCol] != null) {
              if (board![newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board![newRow][newCol] != null) {
            if (board![newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      default:
    }
    return candidateMoves;
  }

  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece piece, bool checksimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> canidateMoves = calculateRawValidMoves(row, col, piece);
    if (checksimulation) {
      for (var move in canidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        if (simulatedMoveIsSafe(piece, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = canidateMoves;
    }
    return realValidMoves;
  }

  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    ChessPiece? originalDestinationPiece = board![endRow][endCol];

    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board![endRow][endCol] = piece;
    board![startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    board![startRow][startCol] = piece;
    board![endRow][endCol] = originalDestinationPiece;

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  void movePiece(int newRow, int newCol, BuildContext context) {
    if (board![newRow][newCol] != null) {
      var capturedPiece = board![newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    board![newRow][newCol] = selectedPiece;
    board![selectedRow][selectedCol] = null;

    if (isKingInCheck(isLocaluserTurn!)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    selectedPiece = null;
    selectedRow = -1;
    selectedCol = -1;
    validMoves = [];

    if (isCheckMate(!isLocaluserTurn!)) {
      isLocaluserTurn = !isLocaluserTurn!;
      showPlayButton(context, "Play Again");
    }
    notifyListeners();
  }

  bool isKingInCheck(bool iswhiteLing) {
    List<int> kingPosition =
        iswhiteLing ? whiteKingPosition : blackKingPosition;

    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (board![i][j] == null || board![i][j]!.isWhite == iswhiteLing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board![i][j]!, false);

        if (pieceValidMoves.any(
          (element) =>
              element[0] == kingPosition[0] && element[1] == kingPosition[1],
        )) {
          return true;
        }
      }
    }
    return false;
  }

  bool isCheckMate(bool isWhiteKing) {
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (board![i][j] == null || board![i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board![i][j]!, true);

        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  showPlayButton(BuildContext context, String buttonTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: myText("CHECK MATE!"),
        actions: [
          MainButton(
            isLoading: false,
            title: buttonTitle,
            onTap: () {
              navigateBack(context);
              initBoard();
              changeTurn(!isLocaluserTurn!);
              checkStatus = false;
              whitePiecesTaken.clear();
              blackPiecesTaken.clear();
              whiteKingPosition = [7, 4];
              blackKingPosition = [0, 4];
            },
          )
        ],
      ),
    );
  }
}
