import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lights_out/controller/algorithms/A_star.dart';
import 'package:lights_out/controller/algorithms/bfs.dart';
import 'package:lights_out/controller/algorithms/dfs_recursive.dart';
import 'package:lights_out/controller/algorithms/hill_climbing.dart';
import 'package:lights_out/controller/algorithms/ucs.dart';
import 'package:lights_out/model/node.dart';
import 'package:lights_out/model/state.dart';
import 'package:lights_out/view/gameplay.dart';

import 'algorithms/dfs.dart';
// Strategy Game

// Here is class Logic that contains userplay mode and objects of algorithms that can solve it.
class GameLogicController extends GetxController {

  // Timer
  Timer? _timer;
  int passedSeconds = 0;
  final time = '00.00'.obs;

  void _startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (timer) {
      passedSeconds++;
      int minutes = passedSeconds~/60;
      int seconds = (passedSeconds%60);
      time.value = "${minutes.toString().padLeft(2,"0")}:${seconds.toString().padLeft(2,"0")}";
    });
  }

  void _stopTimer() {
    print('stop Timer');
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _resetTimer() {
    print('reset Timer');
    _stopTimer();
    passedSeconds = 0;
    time.value = '00:00';
    _startTimer();
  }

  void stopAndResetTimer() {
    print('stop and reset Timer');
    if (_timer != null) {
      passedSeconds = 0;
      time.value = '00:00';
      _timer!.cancel();
      _timer = null;
    }
  }
  //////////////////////////////////////////////////////////////////////////////

  // UserMode

  Rx<GameState> gameModel = Rx<GameState>(GameState(height: 3, width: 3));

  RxInt moves = 0.obs;

  RxBool isWin = false.obs;

  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();

  void onStartClicked() {

    int height = int.tryParse(heightController.text) ?? 3;
    int width = int.tryParse(widthController.text) ?? 3;

    gameModel.value = GameState(height: height, width: width);

    moves = 0.obs;

    _startTimer();

    gameModel.value.printLightsStatus(gameModel.value);
  }

  void onResetClicked() {
    _resetTimer();
    gameModel.update((val) {
      val?.randomLights();
    });
    moves.value = 0;
    gameModel.value.printLightsStatus(gameModel.value);
    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

  void onLightClicked(int i, int j) {
    print('Light Clicked');

    if (gameModel.value.canClicked(i, j)) {
      gameModel.update((val) {
        val?.changeLightStatus(i, j);
      });
    }
    if (gameModel.value.canClicked(i-1, j)) {
      gameModel.update((val) {
        val?.changeLightStatus(i-1, j);
      });
    }
    if (gameModel.value.canClicked(i+1, j)) {
      gameModel.update((val) {
        val?.changeLightStatus(i+1, j);
      });
    }
    if (gameModel.value.canClicked(i, j-1)) {
      gameModel.update((val) {
        val?.changeLightStatus(i, j-1);
      });
    }
    if (gameModel.value.canClicked(i, j+1)) {
      gameModel.update((val) {
        val?.changeLightStatus(i, j+1);
      });
    }

    moves ++;
    print(moves);

    gameModel.value.getNextStates(gameModel.value);

    gameModel.value.printLightsStatus(gameModel.value);

    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

////////////////////////////////////////////////////////////////////////////////
  void solveByDFS() async {
    DFSAlgorithm dfsAlgorithm = DFSAlgorithm(GameNode(null, gameModel.value));

    for (int i = dfsAlgorithm.solutionList.length - 1; i >= 0; i--) {
      GameState node = dfsAlgorithm.solutionList[i];
      await Future.delayed(const Duration(milliseconds: 100)); // Add a 1-second delay
      moves ++;
      gameModel.update((val) {
        val!.lights = node.lights;
      });
    }

    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      dfsAlgorithm.solutionList.clear();
      dfsAlgorithm.visitedList.clear();
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

  void solveByDFSRecursive() async {
    DFSRecAlgorithm dfsRecAlgorithm = DFSRecAlgorithm(GameNode(null, gameModel.value));

    for (int i = dfsRecAlgorithm.solutionList.length - 1; i >= 0; i--) {
      GameState node = dfsRecAlgorithm.solutionList[i];
      await Future.delayed(const Duration(milliseconds: 100)); // Add a 1-second delay
      moves ++;
      gameModel.update((val) {
        val!.lights = node.lights;
      });
    }

    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      dfsRecAlgorithm.solutionList.clear();
      dfsRecAlgorithm.visitedList.clear();
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

  void solveByBFS() async{
    BFSAlgorithm bfscAlgorithm = BFSAlgorithm(GameNode(null, gameModel.value));

    for (int i = bfscAlgorithm.solutionList.length - 1; i >= 0; i--) {
      GameState node = bfscAlgorithm.solutionList[i];
      await Future.delayed(const Duration(milliseconds: 100)); // Add a 1-second delay
      moves ++;
      gameModel.update((val) {
        val!.lights = node.lights;
      });
    }

    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      bfscAlgorithm.solutionList.clear();
      bfscAlgorithm.visitedList.clear();
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

  void solveByUCS() async{
    UCSAlgorithmCost ucsAlgorithm = UCSAlgorithmCost(GameNode(null, gameModel.value));

    for (int i = ucsAlgorithm.solutionList.length - 1; i >= 0; i--) {
      GameState node = ucsAlgorithm.solutionList[i];
      await Future.delayed(const Duration(milliseconds: 100)); // Add a 1-second delay
      moves ++;
      gameModel.update((val) {
        val!.lights = node.lights;
      });
    }

    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      ucsAlgorithm.solutionList.clear();
      ucsAlgorithm.visitedList.clear();
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

  void solveByHillClimbing() async{
    HillClimbingAlgorithmPQ hillClimbingAlgorithm = HillClimbingAlgorithmPQ(GameNode(null, gameModel.value));

    for (int i = hillClimbingAlgorithm.solutionList.length - 1; i >= 0; i--) {
      GameState node = hillClimbingAlgorithm.solutionList[i];
      await Future.delayed(const Duration(milliseconds: 100)); // Add a 1-second delay
      moves ++;
      gameModel.update((val) {
        val!.lights = node.lights;
      });
    }

    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      hillClimbingAlgorithm.solutionList.clear();
      hillClimbingAlgorithm.visitedList.clear();
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

  void solveByAStar() async{
    AStarAlgorithmCost aStarAlgorithmCost = AStarAlgorithmCost(GameNode(null, gameModel.value));

    for (int i = aStarAlgorithmCost.solutionList.length - 1; i >= 0; i--) {
      GameState node = aStarAlgorithmCost.solutionList[i];
      await Future.delayed(const Duration(milliseconds: 100)); // Add a 1-second delay
      moves ++;
      gameModel.update((val) {
        val!.lights = node.lights;
      });
    }

    isWin.value = gameModel.value.isGameOver(gameModel.value);
    if (isWin.value) {
      aStarAlgorithmCost.solutionList.clear();
      aStarAlgorithmCost.visitedList.clear();
      _stopTimer();
      showGameOver(moves.value,time.value);
    }
  }

}