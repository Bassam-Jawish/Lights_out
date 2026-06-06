import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lights_out/controller/game_logic_controller.dart';

class GamePlay extends StatelessWidget {
  GamePlay({Key? key, required this.height, required this.width})
      : super(key: key);

  int height;
  int width;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color(0xFFB1E3FA),
      ),
    );
    final GameLogicController controller = Get.find();
    return WillPopScope(
      onWillPop: () async {
        controller.stopAndResetTimer();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFB1E3FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFB1E3FA),
          leading: IconButton(
            onPressed: () {
              Get.back();
              controller.stopAndResetTimer();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.blueGrey,
            ),
            iconSize: 30,
          ),
          centerTitle: true,
          title: const Text('Lights Out Game'),
          titleTextStyle: const TextStyle(
              color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                controller.onResetClicked();
              },
              icon: const Icon(
                Icons.restart_alt,
                color: Colors.blueGrey,
              ),
              iconSize: 30,
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$height X $width',
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width,
                      childAspectRatio: height / width,
                    ),
                    itemCount: (height * width),
                    itemBuilder: (context, index) =>
                        _buildTile(context, index, controller),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add,
                              size: 25, color: Colors.blueGrey),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(
                            () => Text(
                              'Number of moves: ${controller.moves}',
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time,
                              size: 25, color: Colors.blueGrey),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(
                            () => Text(
                              'Time: ${controller.time.value}',
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 40,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.solveByDFS();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Solve By DFS',
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () {
                          controller.solveByDFSRecursive();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Solve By DFS (Recursive)',
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () {
                          controller.solveByBFS();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Solve By BFS',
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () {
                          controller.solveByUCS();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Solve By UCS',
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () {
                          controller.solveByHillClimbing();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Solve By Hill Climbing',
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () {
                          controller.solveByAStar();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Solve By A*',
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, int index, GameLogicController controller) {
    int x, y = 0;
    x = index ~/ width;
    y = index % width;
    return GestureDetector(
        onTap: () async {
          //final player = AudioCache();
          //await player.play('assets/pop-small-bubble-joshua-chivers-1-1-00-00.mp3');
          controller.onLightClicked(x, y);
        },
        child: GridTile(
          child: Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  gradient: controller.gameModel.value.lights[x][y]
                      ? const RadialGradient(
                          radius: 6,
                          colors: [Colors.blueAccent, Colors.tealAccent])
                      : const RadialGradient(
                          radius: 0,
                          colors: [Color(0xFFB1E3FA), Color(0xFFB1E3FA)]),
                  //color:  Colors.blue : Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ));
  }
}

void showGameOver(moves, time) {
  final GameLogicController controller = Get.find();
  Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _BlinkingText(),
                Text(
                  'Number of moves: $moves',
                  style: const TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                Text(
                  'Time: $time',
                  style: const TextStyle(fontSize: 15.0, color: Colors.black),
                ),
              ],
            )),
      ),
      onConfirm: () {
        Get.back();
        controller.onResetClicked();
      },
      buttonColor: Colors.blue,
      textConfirm: 'Try Again',
      confirmTextColor: Colors.white);
}

class _BlinkingText extends StatefulWidget {
  @override
  createState() => _BlinkingTextWidget();
}

class _BlinkingTextWidget extends State<_BlinkingText>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController!.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController!,
      child: const Text(
        "Congratulations, you won",
        style: TextStyle(fontSize: 20.0, color: Colors.blue),
      ),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
