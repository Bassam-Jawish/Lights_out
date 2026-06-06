# Lights Out

A Flutter puzzle game based on the classic **Lights Out** game. Turn off every light on the board by toggling tiles — each tap flips the selected light and its four neighbors (up, down, left, right). Play manually or watch built-in search algorithms solve the puzzle for you.

## Demo

<video width="100%" controls>
  <source src="https://github.com/Bassam-Jawish/Lights_out/raw/master/videos/demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

> **Can't play the video?** [Download or open the demo directly](videos/demo.mp4).

## How to Play

1. Choose a custom grid size (height × width) from the home screen.
2. Tap a tile to toggle it and its adjacent neighbors.
3. Turn **all lights off** to win.
4. Your move count and elapsed time are tracked automatically.
5. Use **Reset** to shuffle the board and try again.

## Features

- **Custom board sizes** — configure height and width before starting
- **Manual play** — classic Lights Out mechanics with neighbor toggling
- **Move counter & timer** — track your performance
- **Animated home screen** — particle background powered by `animated_background`
- **Auto-solvers** — step through solutions with visual playback
- **Win dialog** — congratulations screen with stats and a quick retry option

## Search Algorithms

The app includes several pathfinding and optimization algorithms that can solve any board configuration:

| Algorithm | Description |
|-----------|-------------|
| **DFS** | Depth-first search — explores one branch fully before backtracking |
| **DFS (Recursive)** | Recursive depth-first search implementation |
| **BFS** | Breadth-first search — finds a shortest-path solution |
| **UCS** | Uniform-cost search — optimal path by step cost |
| **Hill Climbing** | Heuristic local search using a priority queue |
| **A\*** | A* search — optimal path with heuristic guidance |

Each solver animates the solution step-by-step on the board.

## Tech Stack

- [Flutter](https://flutter.dev/) — cross-platform UI
- [GetX](https://pub.dev/packages/get) — state management and navigation
- [animated_background](https://pub.dev/packages/animated_background) — home screen particle effects

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── controller/
│   ├── game_logic_controller.dart     # Game state, timer, solver orchestration
│   └── algorithms/
│       ├── bfs.dart
│       ├── dfs.dart
│       ├── dfs_recursive.dart
│       ├── ucs.dart
│       ├── hill_climbing.dart
│       └── A_star.dart
├── model/
│   ├── state.dart                     # Board state & game rules
│   └── node.dart                      # Search tree node
└── view/
    ├── home.dart                      # Home screen & size picker
    └── gameplay.dart                  # Game board & solver buttons
videos/
└── demo.mp4                           # App demo video
```
