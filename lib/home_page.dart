import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double a = 0;
  double b = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Lottie.asset('assets/gifs/g2.json'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      a = await complexTask1();
                      setState(() {});
                      debugPrint('Result 1: $a');
                    },
                    child: const Text(
                      'Using Async',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    (a != 0) ? "Data Received" : "Waiting",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final receivePort = ReceivePort();
                      await Isolate.spawn(complexTask2, receivePort.sendPort);
                      receivePort.listen((total) {
                        debugPrint('Result 2: $total');
                        b = total;
                        setState(() {});
                      });
                    },
                    child: const Text(
                      'Using Isolate',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    (b != 0) ? "Data Received" : "Waiting",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> complexTask1() async {
    var total = 0.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
