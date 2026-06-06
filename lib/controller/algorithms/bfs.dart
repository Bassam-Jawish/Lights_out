import 'dart:collection';
import 'dart:math';

import 'package:lights_out/model/node.dart';
import 'package:lights_out/model/state.dart';

class BFSAlgorithm {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  List<GameNode> visitedList = [];
  List<GameState> solutionList = [];
  int maxDepth = 0;
  int totalChildStates = 0;

  BFSAlgorithm(GameNode node) {
    print("Solving ... Using BFS Algorithm");

    GameNode? sol = solveLightsOutBFS(node);

    printInfo(sol!);
  }

  GameNode? solveLightsOutBFS(GameNode node) {
    Queue<GameNode> queue = Queue();
    queue.add(node);
    visitedList.add(node);
    visitedNodesCount++;

    while (queue.isNotEmpty) {
      GameNode currentNode = queue.removeFirst();
      int currentDepth = currentNode.getDepth();

      if (currentNode.getValue().isGameOver(currentNode.getValue())) {
        currentNode.getValue().printLightsStatus(currentNode.getValue());
        return currentNode;
      }
      int childCount = 0;
      for (GameState child in currentNode.getValue().getNextStates(currentNode.getValue())) {
        if (!isVisited(child)) {
          GameNode childNode = GameNode(currentNode, child);
          queue.add(childNode);
          childNode.setDepth(currentDepth + 1);
          visitedList.add(childNode);
          visitedNodesCount++;
          childCount++;
        }
      }
      maxDepth = currentDepth + 1;
      totalChildStates += childCount;
    }

    return null;
  }

  bool isVisited(GameState state) {
    for (GameNode visitedNode in visitedList) {
      if (visitedNode.getValue().equals(visitedNode.getValue(), state)) {
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

    while (sol != null && sol.hasPrevious()) {
      solutionList.add(sol.getValue());
      sol = sol.getParent();
    }

    print("Time Complexity:");
    print("Visited Nodes Count: ${visitedList.length}");
    print('');
    print("Node Depth: ${solutionList.length}");
    print("Space Complexity:");
    print("Max Level of Nodes / Max Depth: ${maxDepth}");
    if (visitedNodesCount > 0) {
      double averageBranchingFactor = totalChildStates / visitedNodesCount.toDouble();
      print("level of average children number of each node: $averageBranchingFactor");
      num spaceComplexity = pow(averageBranchingFactor, maxDepth);
      print("Space Complexity: $spaceComplexity");
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
////////////////////////////////////////////////////////////////////////////////
class BFSSetAlgorithm {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  Set<GameNode> visitedList = Set();
  List<GameState> solutionList = [];
  int maxDepth = 0;
  int totalChildStates = 0;

  BFSSetAlgorithm(GameNode node) {
    print("Solving ... Using BFS Algorithm");

    GameNode? sol = solveLightsOutBFS(node);

    printInfo(sol!);
  }

  GameNode? solveLightsOutBFS(GameNode node) {
    Queue<GameNode> queue = Queue();
    queue.add(node);
    visitedList.add(node);
    visitedNodesCount++;

    while (queue.isNotEmpty) {
      GameNode currentNode = queue.removeFirst();
      int currentDepth = currentNode.getDepth();

      if (currentNode.getValue().isGameOver(currentNode.getValue())) {
        // Solution found
        currentNode.getValue().printLightsStatus(currentNode.getValue());
        return currentNode;
      }

      int childCount = 0;
      for (GameState child in currentNode.getValue().getNextStates(currentNode.getValue())) {
        if (!(visitedList.contains(child))) {
          GameNode childNode = GameNode(currentNode, child);
          queue.add(childNode);
          visitedList.add(childNode);
          visitedNodesCount++;
          childNode.setDepth(currentDepth + 1);
          childCount++;

        }
      }
      maxDepth = currentDepth + 1;
      totalChildStates += childCount;
    }

    return null; // No solution found
  }

  bool isVisited(GameState state) {
    for (GameNode visitedNode in visitedList) {
      if (visitedNode.getValue().equals(visitedNode.getValue(), state)) {
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

    while (sol != null && sol.hasPrevious()) {
      solutionList.add(sol.getValue());
      sol = sol.getParent();
    }

    print("Time Complexity:");
    print("Visited Nodes Count: ${visitedList.length}");
    print('');
    print("Node Depth: ${solutionList.length}");
    print("Space Complexity:");
    print("Max Level of Nodes / Max Depth: ${maxDepth}");
    if (visitedNodesCount > 0) {
      double averageBranchingFactor = totalChildStates / visitedNodesCount.toDouble();
      print("level of average children number of each node: $averageBranchingFactor");
      num spaceComplexity = pow(averageBranchingFactor, maxDepth);
      print("Space Complexity: $spaceComplexity");
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