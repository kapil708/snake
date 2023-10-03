import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> snakePosition = [45, 65, 85, 105, 125];
  int numbersOfSquares = 640;
  String direction = 'down';

  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);

  void generateNewFood() {
    food = randomNumber.nextInt(numbersOfSquares - 60);
  }

  void startGame() {
    direction = 'down';
    snakePosition = [45, 65, 85, 105, 125];
    Duration duration = const Duration(milliseconds: 200);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        showGameOverScreen();
      } else {
        setState(() {});
      }
    });
  }

  void updateSnake() {
    // For no wall limit
    /*switch (direction) {
      case 'down':
        if (snakePosition.last > (numbersOfSquares - 20)) {
          snakePosition.add(snakePosition.last + 20 - numbersOfSquares);
        } else {
          snakePosition.add(snakePosition.last + 20);
        }

        break;

      case 'up':
        if (snakePosition.last < 20) {
          snakePosition.add(snakePosition.last - 20 + numbersOfSquares);
        } else {
          snakePosition.add(snakePosition.last - 20);
        }
        break;

      case 'left':
        if (snakePosition.last % 20 == 0) {
          snakePosition.add(snakePosition.last - 1 + 20);
        } else {
          snakePosition.add(snakePosition.last - 1);
        }
        break;

      case 'right':
        if ((snakePosition.last + 1) % 20 == 0) {
          snakePosition.add(snakePosition.last + 1 - 20);
        } else {
          snakePosition.add(snakePosition.last + 1);
        }
        break;
    }*/

    // With wall limit
    switch (direction) {
      case 'down':
        snakePosition.add(snakePosition.last + 20);
        break;

      case 'up':
        snakePosition.add(snakePosition.last - 20);
        break;

      case 'left':
        snakePosition.add(snakePosition.last - 1);
        break;

      case 'right':
        snakePosition.add(snakePosition.last + 1);
        break;
    }

    if (snakePosition.last == food) {
      generateNewFood();
    } else {
      snakePosition.removeAt(0);
    }

    //setState(() {});
  }

  bool gameOver() {
    // check for self bite
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) count += 1;
        if (count == 2) return true;
      }
    }

    // check walls
    switch (direction) {
      case 'down':
        if (snakePosition.last > numbersOfSquares) return true;
        break;

      case 'up':
        if (snakePosition.last < 0) return true;
        break;

      case 'left':
        if (snakePosition.last % 20 == 19) return true;
        break;

      case 'right':
        if (snakePosition.last % 20 == 0) return true;
        break;
    }

    return false;
  }

  void showGameOverScreen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("Your score: ${snakePosition.length - 5}"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  snakePosition = [45, 65, 85, 105, 125];
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                startGame();
                Navigator.pop(context);
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text("Score: ${snakePosition.length - 5}"),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                child: Container(
                  color: Colors.black,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: numbersOfSquares,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20),
                    itemBuilder: (context, index) {
                      return snakePosition.contains(index)
                          ? Center(
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(color: Colors.white),
                                ),
                              ),
                            )
                          : index == food
                              ? Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(color: Colors.green),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    // child: Container(color: Colors.black),
                                    child: Container(color: Colors.grey.shade900),
                                  ),
                                );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            //padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: startGame,
                  child: const Text("Start Game"),
                ),
                const Text("Creator: KAPIL SINGH"),
              ],
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
