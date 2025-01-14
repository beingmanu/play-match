import 'package:flutter/material.dart';

enum ChessPieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final IconData imagePath;
  ChessPiece({
    required this.type,
    required this.isWhite,
    required this.imagePath,
  });
}
