import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lights_out/controller/game_logic_controller.dart';
import 'package:lights_out/view/gameplay.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  var heightFocusNode = FocusNode();
  var widthFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final GameLogicController controller = Get.put(GameLogicController());
    return Scaffold(
      backgroundColor: const Color(0xFFB1E3FA),
      appBar: null,
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 50,
            spawnMinSpeed: 10,
            particleCount: 68,
            spawnMaxSpeed: 50,
            minOpacity: 0.3,
            spawnOpacity: 0.4,
            baseColor: Colors.blue,
            //image: Image(image: AssetImage('assets/20231022_204232.jpg'),),
          ),
        ),
        vsync: this,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Lights Out Game',style: TextStyle(color: Colors.blue,fontSize: 35,fontWeight: FontWeight.bold),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.defaultDialog(
                          titlePadding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                          titleStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                          backgroundColor: Colors.white,
                            title: 'Game Size',
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text('Height',style: TextStyle(color: Colors.blueGrey,fontSize: 20,fontWeight: FontWeight.w500),),
                                        SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                            controller: controller.heightController,
                                            focusNode: heightFocusNode,
                                            onFieldSubmitted: (val) {
                                              FocusScope.of(context)
                                                  .requestFocus(widthFocusNode);
                                            },
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(10),
                                              labelStyle: const TextStyle(color: Colors.grey),
                                              fillColor: const Color(0xFFB1E3FA),
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide:  const BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide:  const BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.cancel,color: Colors.blue,size: 35,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text('Width',style: TextStyle(color: Colors.blueGrey,fontSize: 20,fontWeight: FontWeight.w500),),
                                        SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                            controller: controller.widthController,
                                            focusNode: widthFocusNode,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(10),
                                              labelStyle: const TextStyle(color: Colors.grey),
                                              fillColor: const Color(0xFFB1E3FA),
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide:  const BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide:  const BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                            Get.back();
                            controller.onStartClicked();
                            Get.to(() => GamePlay(width: int.tryParse(controller.widthController.text)!,height: int.tryParse(controller.heightController.text)!,));
                            },
                            buttonColor: Colors.blue,
                            textCancel: 'Cancel',
                            textConfirm: 'Start',
                            cancelTextColor: Colors.blue,
                            confirmTextColor: Colors.white);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Start Game',
                        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        exit(0);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Quit Game',
                        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
