import 'dart:math';

import 'package:flutter/foundation.dart';

// Class State
class GameState {
  List<List<bool>> lights = [];
  int height;
  int width;

  GameState({required this.height, required this.width}) {
    height = height;
    width = width;

    lights = [
      [true, true, false, true, true, true, true, true, true],
      [false, false, false, false, true, false, false, true, true],
      [false, false, true, true, false, false, true, false, false],
      [false, false, false, false, false, true, true, true, false],
      [false, true, true, true, true, true, true, false, true],
      [true, false, false, true, true, true, true, true, false],
      [true, true, false, false, false, true, true, false, false],
      [false, true, false, true, true, false, true, false, true],
      [true, false, false, false, true, false, false, true, false],
    ];

    /*lights = [
      [false, false, true, false, false, false, false, false, false],
      [true, true, true, true, false, true, true, false, false],
      [true, true, false, false, true, true, false, true, true],
      [true, true, true, true, true, false, false, false, true],
      [true, false, false, false, false, false, false, true, false],
      [false, true, true, false, false, false, false, false, true],
      [false, false, true, true, true, false, false, true, true],
      [true, false, true, false, false, true, false, true, false],
      [false, true, true, true, false, true, true, false, true],
    ];*/
    // example
    /*lights = [
      [true, true, true, true, false, false, false, true, true],
      [true, false, false, true, false, true, false, true, false],
      [true, false, false, false, false, true, true, false, false],
      [true, false, true, true, false, true, true, false, true],
      [false, true, true, false, false, false, true, true, false],
      [true, false, true, false, false, false, true, true, false],
      [true, false, false, true, false, true, true, false, false],
      [true, true, false, false, false, true, false, true, true],
      [true, true, false, true, true, false, false, false, false],
    ];*/

    if (width != 9 && height != 9) {
      lights = List.generate(
        height!,
        (_) => List<bool>.filled(width!, true),
      );
    }

    print('Array initialized');
  }

  factory GameState.copy({required GameState state}) {
    return _CopyState(
      height: state.height,
      width: state.width,
      lights: state.lights,
    );
  }

  void randomLights() {
    for (int i = 0; i < lights.length; i++) {
      for (int j = 0; j < lights[i].length; j++) {
        lights[i][j] = Random().nextBool();
      }
    }
    print('Array randomized');
  }

  void changeLightStatus(int i, int j) {
    lights[i][j] = !lights[i][j];
    print('Light Status Changed');
  }

  bool isLightOn(int i, int j) {
    return lights[i][j];
  }

  bool canClicked(int i, int j) {
    return 0 <= i && i < lights.length && 0 <= j && j < lights[i].length;
  }

  bool isGameOver(GameState state) {
    for (int i = 0; i < state.lights.length; i++) {
      for (int j = 0; j < state.lights[i].length; j++) {
        if (isLightOn(i, j)) {
          print('The Game is not Over');
          return false;
        }
      }
    }
    print('The Game is Over');
    return true;
  }

  void printLightsStatus(GameState state) {
    for (int i = 0; i < state.lights.length; i++) {
      String row = '';
      for (int j = 0; j < state.lights[i].length; j++) {
        row += '${state.lights[i][j]}  ';
      }
      print(row);
    }
    print('Array printed');
    //print(lights);
  }

  List<GameState> getNextStates(GameState state) {
    List<GameState> nextStates = [];

    for (int i = 0; i < state.lights.length; i++) {
      for (int j = 0; j < state.lights[i].length; j++) {
        GameState board = GameState.copy(state: state);
        if (canClicked(i, j)) {
          board.changeLightStatus(i, j);
        }
        if (canClicked(i - 1, j)) {
          board.changeLightStatus(i - 1, j);
        }
        if (canClicked(i + 1, j)) {
          board.changeLightStatus(i + 1, j);
        }
        if (canClicked(i, j - 1)) {
          board.changeLightStatus(i, j - 1);
        }
        if (canClicked(i, j + 1)) {
          board.changeLightStatus(i, j + 1);
        }
        printLightsStatus(board);
        nextStates.add(board);
      }
    }
    return nextStates;
  }

  bool checkMoves(i, j) {
    return canClicked(i, j) &&
        canClicked(i - 1, j) &&
        canClicked(i + 1, j) &&
        canClicked(i, j - 1) &&
        canClicked(i, j + 1);
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          deepEquals(lights, other.lights);

  @override
  int get hashCode => lights.hashCode;

  bool deepEquals(List<List<bool>> list1, List<List<bool>> list2) {
    if (identical(list1, list2)) return true;
    if (list1.length != list2.length) return false;

    for (var i = 0; i < list1.length; i++) {
      if (!listEquals(list1[i], list2[i])) return false;
    }
    return true;
  }

  //////////////////////////////////////////////////////////////////////////////
  bool equals(GameState game1, GameState game2) {
    return game1.equalsArr(game2);
  }

  bool equalsArr(GameState obj) {
    return deepEquals(lights, obj.lights);
  }
}

class _CopyState extends GameState {
  _CopyState(
      {required int height,
      required int width,
      required List<List<bool>> lights})
      : super(height: height, width: width) {
    // Deep copy each value in passed array, to current instance of game
    this.lights = List.generate(
      height,
      (row) => List<bool>.from(lights[row]),
    );
    print('Deep Copy');
  }
}
