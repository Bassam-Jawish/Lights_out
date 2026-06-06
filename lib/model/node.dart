import 'dart:math';

import 'package:lights_out/model/state.dart';


// Class Node
class GameNode implements Comparable<GameNode>{
  GameNode? parent;
  GameState? value;
  int cost = 0;
  int depth = 0;
  Set<GameNode>? children;

  GameNode(this.parent, GameState this.value){
  this.cost = getCost();

  }

  bool hasPrevious() {
    return parent != null;
  }

  GameNode getParent() {
    return parent!;
  }

  void setParent(GameNode parent) {
    this.parent = parent;
  }

  GameState getValue() {
    return value!;
  }

  void setValue(GameState value) {
    this.value = value;
  }

  int getCost() {
    return this.cost;
  }

  void setCost(int cost) {
    this.cost = cost;
  }

  // comparing must be here
  @override
  int compare(GameNode o1, GameNode o2) {
    return 0;
  }

  int getDepth() {
    return depth;
  }

  void setDepth(int h) {
    depth = h;
  }

  void connectChildren(Set<GameNode> children) {
    this.children = children;
    for (GameNode child in children) {
      child.setParent(this);
    }
  }

  void printSearchPath() {
    String path = "";
    GameNode? currentNode = this;
    while (currentNode != null && currentNode.hasPrevious()) {
      currentNode = currentNode.getParent();
      if (currentNode != null && currentNode.getValue() != null) {
        path = "-> ${currentNode.getValue()} $path";
      }
    }
    path = "Root $path";
    print(path);

    // Print the lights status for each state in the path
    currentNode = this;
    while (currentNode != null) {
      if (currentNode.getValue() != null) {
        currentNode.getValue()!.printLightsStatus(currentNode.getValue()!);
        print('---');
      }
      currentNode = currentNode.getParent();
    }
  }

  int calculateCost(GameState state) {
    /*int cost = 0;
    for (int i = 0; i < state.lights.length; i++) {
      for (int j = 0; j < state.lights[i].length; j++) {
        if (state.isLightOn(i, j)) {
          cost++;
        }
      }
    }
    return cost;*/
    return 1;
  }

  int calculateCost2(GameState parentState, GameState childState) {
    /*int cost = 0;
    for (int i = 0; i < parentState.lights.length; i++) {
      for (int j = 0; j < parentState.lights[i].length; j++) {
        if (parentState.isLightOn(i, j) && !childState.isLightOn(i, j)) {
          cost++;
        }
      }
    }
    return cost;*/
    return 1;
  }

  int computeCost() {
    if (parent == null) {
      return 0;
    }
    return parent!.cost+1;
  }

  @override
  int compareTo(GameNode other) {
    return cost.compareTo(other.cost);
  }

  int computeHeuristich (GameState state) {
    int litCount = 0;
    for (int i = 0; i < state.lights.length; i++) {
      for (int j = 0; j < state.lights[i].length; j++) {
        if (state.isLightOn(i, j)) {
          litCount++;
        }
      }
    }
    return litCount;
  }

  int computeHeuristicbest(GameState state) {
    int heuristic = 0;
    for (int i = 0; i < state.lights.length; i++) {
      for (int j = 0; j < state.lights[i].length; j++) {
        if (state.lights[i][j]) {
          int minDistance = state.lights.length + state.lights[i].length;
          for (int x = 0; x < state.lights.length; x++) {
            for (int y = 0; y < state.lights[x].length; y++) {
              if (!state.lights[x][y]) {
                int distance = (x - i).abs() + (y - j).abs();
                minDistance = distance < minDistance ? distance : minDistance;
                break;
              }
            }
          }
          heuristic += minDistance;
        }
      }
    }
    return heuristic;
  }

  int computeHeuristichh(GameState state) {
    int rows = state.lights.length;
    int cols = state.lights[0].length;

    int rowParity = 0;
    int colParity = 0;

    for (int i = 0; i < rows; i++) {
      int rowOnCount = state.lights[i].where((element) => element).length;
      if (rowOnCount % 2 != 0) {
        rowParity++;
      }
    }

    for (int j = 0; j < cols; j++) {
      int colOnCount = 0;
      for (int i = 0; i < rows; i++) {
        if (state.lights[i][j]) {
          colOnCount++;
        }
      }
      if (colOnCount % 2 != 0) {
        colParity++;
      }
    }

    return rowParity + colParity;
  }


  int computeHeuristic(GameState state) {
    int heuristicValue = 0;
    int numRows = state.lights.length;
    int numCols = state.lights[0].length;
    int weightFactor = 2; // Adjust weight factor as needed

    // Count the number of turned-on lamps
    int turnedOnCount = 0;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        if (state.lights[i][j]) {
          turnedOnCount++;
        }
      }
    }

    // Calculate the weighted counts for adjacent turned-on lamps
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        if (state.lights[i][j]) {
          int adjacentTurnedOn = 0;

          // Check top lamp
          if (i - 1 >= 0 && state.lights[i - 1][j]) {
            adjacentTurnedOn++;
          }
          // Check bottom lamp
          if (i + 1 < numRows && state.lights[i + 1][j]) {
            adjacentTurnedOn++;
          }
          // Check left lamp
          if (j - 1 >= 0 && state.lights[i][j - 1]) {
            adjacentTurnedOn++;
          }
          // Check right lamp
          if (j + 1 < numCols && state.lights[i][j + 1]) {
            adjacentTurnedOn++;
          }

          heuristicValue += adjacentTurnedOn * weightFactor;
        }
      }
    }

    // Add the total number of turned-on lamps to the heuristic value
    heuristicValue += turnedOnCount;

    return heuristicValue;
  }
}
