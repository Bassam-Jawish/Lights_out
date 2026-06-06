import 'dart:math';

import 'package:lights_out/model/node.dart';
import 'package:lights_out/model/state.dart';

class DFSRecAlgorithm {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  int maxDepth = 0;
  int totalChildStates = 0;

  DFSRecAlgorithm(GameNode node) {
    print("Solving ... Using DFS Recursive Algorithm");

    GameNode? sol = solveLightsOutDFSREC(node);

    printInfo(sol!);
  }

  GameNode? solveLightsOutDFSREC(GameNode node) {
    print('Recursive Call');
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
        GameNode childNode = GameNode(node, child);
        GameNode? sol = solveLightsOutDFSREC(childNode);
        maxDepth = max(maxDepth, node.getDepth() + 1);
        childCount++;
        if (sol != null) {
          return sol;
        }
      }
      totalChildStates += childCount;
    }

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
    print("Max Depth: $maxDepth");
    if (visitedNodesCount > 0) {
      double averageBranchingFactor = totalChildStates / visitedNodesCount.toDouble();
      print("Average Branching Factor: $averageBranchingFactor");
      print('Space: ${maxDepth * averageBranchingFactor}');
    }

    if (sol != null) {
      print('Path from Root:');
      for (int i = solutionList.length - 1; i >= 0; i--) {
        print('Step ${solutionList.length - i} :');
        solutionList[i].printLightsStatus(solutionList[i]);
        print('---');
      }
      print('Game Over');
    }
  }
}
