import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SurfApp());
}

class SurfApp extends StatelessWidget {
  const SurfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePageStateful(title: 'Gesture Master'),
    );
  }
}

class HomePageStateful extends StatefulWidget {
  final String title;

  const HomePageStateful({required this.title, super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> with SingleTickerProviderStateMixin {
  bool _isInitialized = false;
  late double _x;
  late double _y;
  double _size = 50;
  Color _color = Colors.blue;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration of the animation
      vsync: this,
    );
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget myWidget(Color color) {
    return 
      RotationTransition(
        turns: _controller,
        child: SizedBox(
          width: _size, 
          height: _size, 
          child: ColoredBox(color: color)
        ),
      );
  }

  void changeColorAndSize() {
    setState(() {
      final rnd = Random();
      _color = Colors.primaries[rnd.nextInt(Colors.primaries.length)];
      final newSize  = 50 + 50 * rnd.nextDouble();
      final delta = (newSize - _size) / 2;
      _x -= delta;
      _y -= delta;
      _size = newSize;
    });
  }
  
  void rotate() {
    _controller.reset();
    _controller.forward();
  }

  void drag(DragUpdateDetails details) {
    setState(() {
      _x += details.delta.dx;
      _y += details.delta.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: 
          LayoutBuilder( // to get constrains of the parent to initialize x and y at the first time
            builder: (context, constrains) {
              if (!_isInitialized) {
                _x = constrains.maxWidth / 2 - _size / 2;
                _y = constrains.maxHeight / 2 - _size / 2;
                _isInitialized = true;
              }
              return Stack(            
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: Colors.yellow,)
                  ),
                  Positioned(
                    left: _x, 
                    top: _y,
                    child: myWidget(_color)
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: changeColorAndSize,
                      onLongPress: rotate,
                      onPanUpdate: drag,
                    )
                  ),
                ]
              );
            }
          )
    );
  }  
}
