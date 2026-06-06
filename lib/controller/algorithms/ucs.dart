import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:lights_out/model/node.dart';
import 'package:lights_out/model/state.dart';

class UCSAlgorithm {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  List<GameNode> visitedList = [];
  List<GameState> solutionList = [];
  int maxDepth = 0;
  int totalChildStates = 0;
  int maxPriorityQueueSize = 0;

  UCSAlgorithm(GameNode node) {
    print("Solving ... Using UCS Algorithm");

    GameNode? sol = solveLightsOutUCS(node);

    if (sol == null) {
      print("NO SOLUTION FOUND");
    } else {
      printInfo(sol!);
    }
  }

  GameNode? solveLightsOutUCS(GameNode node) {
    PriorityQueue<GameNode> priorityQueue = PriorityQueue((a, b) {
      int costComparison = a
          .calculateCost(a.getValue())
          .compareTo(b.calculateCost(b.getValue()));
      if (costComparison != 0) {
        return costComparison;
      } else {
        return a.getDepth().compareTo(b.getDepth());
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
      for (GameState child
          in currentNode.getValue().getNextStates(currentNode.getValue())) {
        if (!isVisited(child)) {
          GameNode childNode = GameNode(currentNode, child);
          childNode
              .setCost(currentNode.getCost() + childNode.calculateCost(child));
          priorityQueue.add(childNode);
          childNode.setDepth(currentDepth + 1);
          visitedList.add(childNode);
          visitedNodesCount++;
          childCount++;
        } else {
          // I want to see if node is visited then iterative over priorityList if (two states are equals + cost of child node less than node in priorityList){remove node in priorityList and add the child node}
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
    print("Cost:");
    print(sol.cost);
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

class UCSSetAlgorithm {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  HashSet<GameNode> visitedList = HashSet();
  List<GameState> solutionList = [];
  int maxDepth = 0;
  int totalChildStates = 0;
  int maxPriorityQueueSize = 0;

  UCSSetAlgorithm(GameNode node) {
    print("Solving ... Using UCS Algorithm");

    GameNode? sol = solveLightsOutUCS(node);

    if (sol == null) {
      print("NO SOLUTION FOUND");
    } else {
      printInfo(sol!);
    }
  }

  GameNode? solveLightsOutUCS(GameNode node) {
    PriorityQueue<GameNode> priorityQueue = PriorityQueue((a, b) {
      int costComparison = a
          .calculateCost2(a.getParent().getValue(), a.getValue())
          .compareTo(b.calculateCost2(b.getParent().getValue(), b.getValue()));
      if (costComparison != 0) {
        return costComparison;
      } else {
        return a.getDepth().compareTo(b.getDepth());
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
      for (GameState child
      in currentNode.getValue().getNextStates(currentNode.getValue())) {
        if (!visitedList.contains(child)) {
          GameNode childNode = GameNode(currentNode, child);
          childNode
              .setCost(currentNode.getCost() + childNode.calculateCost2(currentNode.getValue(),child));
          priorityQueue.add(childNode);
          childNode.setDepth(currentDepth + 1);
          visitedList.add(childNode);
          visitedNodesCount++;
          childCount++;
        }
        else {
          GameNode childNode = GameNode(currentNode, child);
          List<GameNode> priorityList = priorityQueue.toList();

          for (GameNode existingNode in priorityList) {
            if (existingNode.getValue().equalsArr(child)) {
              int existingNodeCost = existingNode.getCost();
              int childNodeCost = currentNode.getCost() + childNode.calculateCost2(currentNode.getValue(), child);

              if (childNodeCost < existingNodeCost) {
                // Remove the existing node from the priority queue
                priorityQueue.remove(existingNode);

                // Set the cost and depth for the child node
                childNode.setCost(childNodeCost);
                childNode.setDepth(currentDepth + 1);

                // Add the child node to the priority queue
                priorityQueue.add(childNode);

                // Update the visited list
                visitedList.add(childNode);
                visitedNodesCount++;

                // Increment the child count
                childCount++;

                // Break out of the loop since we found and updated the existing node
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

class UCSAlgorithmCost {
  int visitedNodesCount = 0;
  int nodeDepth = 0;
  List<GameNode> visitedList = [];
  List<GameState> solutionList = [];
  int maxDepth = 0;
  int totalChildStates = 0;
  int maxPriorityQueueSize = 0;

  UCSAlgorithmCost(GameNode node) {
    print("Solving ... Using UCS Algorithm");

    GameNode? sol = solveLightsOutUCS(node);

    if (sol == null) {
      print("NO SOLUTION FOUND");
    } else {
      printInfo(sol!);
    }
  }

  GameNode? solveLightsOutUCS(GameNode node) {
    PriorityQueue<GameNode> priorityQueue = PriorityQueue((a, b) {
      int costComparison = a
          .calculateCost2(a.getParent().getValue(), a.getValue())
          .compareTo(b.calculateCost2(b.getParent().getValue(), b.getValue()));
      if (costComparison != 0) {
        return costComparison;
      } else {
        return a.getDepth().compareTo(b.getDepth());
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
      for (GameState child
          in currentNode.getValue().getNextStates(currentNode.getValue())) {
        if (!isVisited(child)) {
          GameNode childNode = GameNode(currentNode, child);
          childNode
              .setCost(currentNode.getCost() + childNode.calculateCost2(currentNode.getValue(),child));
          priorityQueue.add(childNode);
          childNode.setDepth(currentDepth + 1);
          visitedList.add(childNode);
          visitedNodesCount++;
          childCount++;
        }
        else {
          GameNode childNode = GameNode(currentNode, child);
          List<GameNode> priorityList = priorityQueue.toList();

          for (GameNode existingNode in priorityList) {
            if (existingNode.getValue().equalsArr(child)) {
              int existingNodeCost = existingNode.getCost();
              int childNodeCost = currentNode.getCost() + childNode.calculateCost2(currentNode.getValue(), child);

              if (childNodeCost < existingNodeCost) {
                // Remove the existing node from the priority queue
                priorityQueue.remove(existingNode);

                // Set the cost and depth for the child node
                childNode.setCost(childNodeCost);
                childNode.setDepth(currentDepth + 1);

                // Add the child node to the priority queue
                priorityQueue.add(childNode);

                // Update the visited list
                visitedList.add(childNode);
                visitedNodesCount++;

                // Increment the child count
                childCount++;

                // Break out of the loop since we found and updated the existing node
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
