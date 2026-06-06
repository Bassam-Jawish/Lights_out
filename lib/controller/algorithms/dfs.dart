import 'dart:math';

import 'package:get/get.dart';
import 'package:lights_out/model/node.dart';
import 'package:lights_out/model/state.dart';


class DFSAlgorithm {

  int visitedNodesCount = 0;
  int nodeDepth = 0;
  int maxDepth = 0;
  int totalChildStates = 0;

  DFSAlgorithm(GameNode node) {
    print("Solving ... Using DFS Algorithm (Stack)");

    GameNode? sol = solveLightsOutDFS(
        node
    );

    printInfo(sol!);
  }

  GameNode? solveLightsOutDFS(GameNode initialState) {
    print('solveLightsOutDFS');
    List<GameNode> stack = [];

    stack.add(initialState);
    initialState.setDepth(0);

    while (stack.isNotEmpty) {
      GameNode node = stack.removeLast();
      visitedList.add(node);

      visitedNodesCount++;
      if (node.getValue().isGameOver(node.getValue())) {
        //print('Solution Found');
        node.getValue().printLightsStatus(node.getValue());
        return node;
      }
      int childCount = 0;
      for (GameState child in node.getValue().getNextStates(node.getValue())) {
        if (!isVisited(child)) {
          stack.add(GameNode(node, child));
          childCount++;
          maxDepth = max(maxDepth, node.getDepth() + 1);
          node.setDepth(node.getDepth() + 1);
        }
      }
      totalChildStates += childCount;
    }

    //print('No solution found');
    return null;
  }

  List<GameNode> visitedList = [];

  List<GameState> solutionList = [];

  bool isVisited(GameState state) {
    for (GameNode nextNode in visitedList) {
      if (nextNode.getValue().equals(nextNode.getValue(), state)) {
        return true;
      }
    }
    return false;
  }

  void printInfo(GameNode sol) {
    if (sol != null) {
      print("Successfully Solved");
    } else {
      print("NO SOLUTION FOUND");
    }

    while (sol.hasPrevious()) {
      solutionList.add(sol.getValue());
      sol = sol.getParent();
    }
    print("Time Complexity:");
    print("Visited Nodes Count: ${visitedList.length}");
    print('');
    print("Node Depth: ${solutionList.length}");
    print("Space Complexity:");
    print("Max Level of Nodes /Max Depth: ${maxDepth}");
    if (visitedNodesCount > 0) {
      double averageBranchingFactor = totalChildStates / visitedNodesCount.toDouble();
      print("level of average children number of each node: $averageBranchingFactor");
      print('Space: ${maxDepth * averageBranchingFactor}');
    }

    if (sol != null) {
      print('Path Solution from Root:');
      for (int i = solutionList.length - 1; i >= 0; i--) {
        print('Step ${solutionList.length - i} :');
        solutionList[i].printLightsStatus(solutionList[i]);
        print('---');
      }
      print('Game Over');
    }
  }
}
////////////////////////////////////////////////////////////////////////////////
class DFSSetAlgorithm {

  int visitedNodesCount = 0;
  int nodeDepth = 0;

  DFSSetAlgorithm(GameNode node) {
    print("Solving ... Using DFS Algorithm (Stack)");

    GameNode? sol = solveLightsOutsetDFS(
        node
    );

    printInfo(sol!);
  }

  Set<GameNode> visitedList = {};

  GameNode? solveLightsOutsetDFS(GameNode initialState) {
    print('solveLightsOutDFS');
    List<GameNode> stack = [];

    stack.add(initialState);

    while (stack.isNotEmpty) {
      GameNode node = stack.removeLast();
      visitedList.add(node);
      visitedNodesCount++;
      if (node.getValue().isGameOver(node.getValue())) {
        //print('Solution Found');
        node.getValue().printLightsStatus(node.getValue());
        return node;
      }

      for (GameState child in node.getValue().getNextStates(node.getValue())) {
        if (!visitedList.contains(child)) {
          stack.add(GameNode(node, child));
        }
      }
    }

    //print('No solution found');
    return null;
  }


  bool isVisited(GameState state) {
    for (GameNode nextNode in visitedList) {
      if (nextNode.getValue().equals(nextNode.getValue(), state)) {
        return true;
      }
    }
    return false;
  }

  List<GameState> solutionList = [];

  void printInfo(GameNode sol) {
    if (sol != null) {
      print("Successfully Solved");
    } else {
      print("NO SOLUTION FOUND");
    }

    while (sol.hasPrevious()) {
      solutionList.add(sol.getValue());
      sol = sol.getParent();
    }

    print("Time Complexity:");
    print("Visited Nodes Count: ${visitedList.length}");
    print('');
    print("Node Depth: ${solutionList.length}");

    if (sol != null) {
      print('Path Solution from Root:');
      for (int i = solutionList.length - 1; i >= 0; i--) {
        print('Step ${solutionList.length - i} :');
        solutionList[i].printLightsStatus(solutionList[i]);
        print('---');
      }
      print('Game Over');
    }
  }
}
