import 'dart:collection';

import 'package:lights_out/model/node.dart';
import 'package:lights_out/model/state.dart';
import 'package:collection/collection.dart';

class AStarAlgorithmSet {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  HashSet<GameNode> visitedList = HashSet();
  List<GameState> solutionList = [];
  int maxDepth = 0;
  int totalChildStates = 0;
  int maxPriorityQueueSize = 0;

  AStarAlgorithmSet(GameNode node) {
    print("Solving ... Using A* Algorithm");

    GameNode? sol = solveLightsOutAStar(node);

    if (sol == null) {
      print("NO SOLUTION FOUND");
    } else {
      printInfo(sol!);
    }
  }

  GameNode? solveLightsOutAStar(GameNode node) {
    PriorityQueue<GameNode> priorityQueue = PriorityQueue((a, b) {
      int costComparison = (a.getCost() + a.computeHeuristic(a.getValue())).compareTo(
          b.getCost() + b.computeHeuristic(b.getValue()));
      if (costComparison != 0) {
        return costComparison;
      } else {
        return a.computeHeuristic(a.getValue()).compareTo(b.computeHeuristic(b.getValue()));
      }
    });

    priorityQueue.add(node);
    visitedList.add(node);
    visitedNodesCount++;

    while (priorityQueue.isNotEmpty) {
      GameNode currentNode = priorityQueue.removeFirst();
      int currentDepth = currentNode.getDepth();

      // Memory Consuming
      int currentQueueSize = priorityQueue.length;
      if (currentQueueSize > maxPriorityQueueSize) {
        maxPriorityQueueSize = currentQueueSize;
      }

      if (currentNode.getValue().isGameOver(currentNode.getValue())) {
        currentNode.getValue().printLightsStatus(currentNode.getValue());
        return currentNode;
      }

      int childCount = 0;
      for (GameState child in currentNode.getValue().getNextStates(
          currentNode.getValue())) {
        if (!visitedList.contains(child)) {
          GameNode childNode = GameNode(currentNode, child);
          childNode.setCost(currentNode.getCost() +
              childNode.calculateCost2(currentNode.getValue(), child));
          priorityQueue.add(childNode);
          childNode.setDepth(currentDepth + 1);
          visitedList.add(childNode);
          visitedNodesCount++;
          childCount++;
        } else {
          GameNode childNode = GameNode(currentNode, child);
          List<GameNode> priorityList = priorityQueue.toList();

          for (GameNode existingNode in priorityList) {
            if (existingNode.getValue().equalsArr(child)) {
              int existingNodeCost = existingNode.getCost();
              int childNodeCost =
                  currentNode.getCost() +
                      childNode.calculateCost2(currentNode.getValue(), child);

              if (childNodeCost < existingNodeCost) {
                priorityQueue.remove(existingNode);

                childNode.setCost(childNodeCost);
                childNode.setDepth(currentDepth + 1);

                priorityQueue.add(childNode);

                visitedList.add(childNode);
                visitedNodesCount++;

                childCount++;

                break;
              }
            }
          }
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
    print("Cost:");
    print(sol.getCost());
    while (sol != null && sol.hasPrevious()) {
      solutionList.add(sol.getValue());
      sol = sol.getParent();
    }

    print("Time Complexity:");
    print("Visited Nodes Count: ${visitedList.length}");
    print('');
    print("Node Depth: ${solutionList.length}");
    print("Space Complexity:");
    print(maxPriorityQueueSize);
    print("Max Level of Nodes / Max Depth: ${maxDepth}");
    /*if (visitedNodesCount > 0) {
      double averageBranchingFactor = totalChildStates / visitedNodesCount.toDouble();
      print("level of average children number of each node: $averageBranchingFactor");
      num spaceComplexity = pow(averageBranchingFactor, maxDepth);
      print("Space Complexity: $spaceComplexity");
    }*/

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

class AStarAlgorithmCost {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  List<GameNode> visitedList = [];
  List<GameState> solutionList = [];
  int maxDepth = 0;
  int totalChildStates = 0;
  int maxPriorityQueueSize = 0;

  AStarAlgorithmCost(GameNode node) {
    print("Solving ... Using A* Algorithm");

    GameNode? sol = solveLightsOutAStar(node);

    if (sol == null) {
      print("NO SOLUTION FOUND");
    } else {
      printInfo(sol!);
    }
  }

  GameNode? solveLightsOutAStar(GameNode node) {
    PriorityQueue<GameNode> priorityQueue = PriorityQueue((a, b) {
      int costComparison = (a.getCost() + a.computeHeuristic(a.getValue())).compareTo(
          b.getCost() + b.computeHeuristic(b.getValue()));
      if (costComparison != 0) {
        return costComparison;
      } else {
        return a.computeHeuristic(a.getValue()).compareTo(b.computeHeuristic(b.getValue()));
      }
    });

    priorityQueue.add(node);
    visitedList.add(node);
    visitedNodesCount++;

    while (priorityQueue.isNotEmpty) {
      GameNode currentNode = priorityQueue.removeFirst();
      int currentDepth = currentNode.getDepth();

      // Memory Consuming
      int currentQueueSize = priorityQueue.length;
      if (currentQueueSize > maxPriorityQueueSize) {
        maxPriorityQueueSize = currentQueueSize;
      }

      if (currentNode.getValue().isGameOver(currentNode.getValue())) {
        currentNode.getValue().printLightsStatus(currentNode.getValue());
        return currentNode;
      }

      int childCount = 0;
      for (GameState child in currentNode.getValue().getNextStates(
          currentNode.getValue())) {
        if (!isVisited(child)) {
          GameNode childNode = GameNode(currentNode, child);
          childNode.setCost(currentNode.getCost() +
              childNode.calculateCost2(currentNode.getValue(), child));
          priorityQueue.add(childNode);
          childNode.setDepth(currentDepth + 1);
          visitedList.add(childNode);
          visitedNodesCount++;
          childCount++;
        } else {
          GameNode childNode = GameNode(currentNode, child);
          List<GameNode> priorityList = priorityQueue.toList();

          for (GameNode existingNode in priorityList) {
            if (existingNode.getValue().equalsArr(child)) {
              int existingNodeCost = existingNode.getCost();
              int childNodeCost =
                  currentNode.getCost() +
                      childNode.calculateCost2(currentNode.getValue(), child);

              if (childNodeCost < existingNodeCost) {
                priorityQueue.remove(existingNode);

                childNode.setCost(childNodeCost);
                childNode.setDepth(currentDepth + 1);

                priorityQueue.add(childNode);

                visitedList.add(childNode);
                visitedNodesCount++;

                childCount++;

                break;
              }
            }
          }
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
    print("Cost:");
    print(sol.getCost());
    while (sol != null && sol.hasPrevious()) {
      solutionList.add(sol.getValue());
      sol = sol.getParent();
    }

    print("Time Complexity:");
    print("Visited Nodes Count: ${visitedList.length}");
    print('');
    print("Node Depth: ${solutionList.length}");
    print("Space Complexity:");
    print(maxPriorityQueueSize);
    print("Max Level of Nodes / Max Depth: ${maxDepth}");
    /*if (visitedNodesCount > 0) {
      double averageBranchingFactor = totalChildStates / visitedNodesCount.toDouble();
      print("level of average children number of each node: $averageBranchingFactor");
      num spaceComplexity = pow(averageBranchingFactor, maxDepth);
      print("Space Complexity: $spaceComplexity");
    }*/

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