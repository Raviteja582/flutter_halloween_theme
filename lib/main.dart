import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Game',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  final List<String> _assets = [
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/pumpkin.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/ball.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/scary.jpg',
    'assets/skull.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/bat.jpg',
    'assets/ball.jpg',
    'assets/scary.jpg',
  ];
  
  final List<Offset> _positions = [];
  final List<double> _rotations = [];
  final Random _random = Random();
  late Timer _timer;

  // AudioPlayer instance for background music
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Start the background music
    _playBackgroundMusic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_positions.isEmpty) {
        // Initialize _positions and _rotations with the same length as _assets
        for (int i = 0; i < _assets.length; i++) {
          _positions.add(Offset(_getRandomXPosition(), _getRandomYPosition()));
          _rotations.add(0.0); // Initialize rotation angles
        }
      }

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          for (int i = 0; i < _positions.length; i++) {
            // Random movement direction
            double dx = (_random.nextDouble() - 0.5) * 10;
            double dy = (_random.nextDouble() - 0.5) * 10;

            // Update positions with random movement
            _positions[i] = Offset(
              _positions[i].dx + dx,
              _positions[i].dy + dy,
            );

            // Apply rotation
            _rotations[i] += 0.1;

            // Ensure objects stay within the screen bounds
            if (_positions[i].dx < 0) {
              _positions[i] = Offset(0, _positions[i].dy);
            } else if (_positions[i].dx > MediaQuery.of(context).size.width - 50) {
              _positions[i] = Offset(MediaQuery.of(context).size.width - 50, _positions[i].dy);
            }

            if (_positions[i].dy < 0) {
              _positions[i] = Offset(_positions[i].dx, 0);
            } else if (_positions[i].dy > MediaQuery.of(context).size.height - 50) {
              _positions[i] = Offset(_positions[i].dx, MediaQuery.of(context).size.height - 50);
            }
          }
        });
      });
    });
  }

  // Function to play background music in loop
  void _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.LOOP); // Ensure looping
    await _audioPlayer.play('assets/scary_bgm.mp3');
  }

  // Function to reset the game
  void _resetGame() {
    setState(() {
      _positions.clear();
      _rotations.clear();

      // Re-initialize positions and rotations
      for (int i = 0; i < _assets.length; i++) {
        _positions.add(Offset(_getRandomXPosition(), _getRandomYPosition()));
        _rotations.add(0.0);
      }
    });
  }

  // Function to show Congratulations dialog
  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You clicked on the pumpkin!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _resetGame(); // Restart the game
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.stop(); // Stop the music when disposing the app
    super.dispose();
  }

  double _getRandomXPosition() {
    return _random.nextDouble() * MediaQuery.of(context).size.width;
  }

  double _getRandomYPosition() {
    return _random.nextDouble() * MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halloween Game'),
      ),
      body: Stack(
        children: _assets.asMap().entries.map((entry) {
          int index = entry.key;
          String asset = entry.value;

          // Ensure index is valid before accessing the lists
          if (index < _positions.length && index < _rotations.length) {
            return Positioned(
              left: _positions[index].dx,
              top: _positions[index].dy,
              child: GestureDetector(
                onTap: () {
                  if (asset.contains('pumpkin')) {
                    _showCongratulationsDialog(); // Show the congratulations alert if pumpkin clicked
                  }
                },
                child: Transform.rotate(
                  angle: _rotations[index], // Apply rotation
                  child: Image.asset(
                    asset,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink(); // Return an empty widget if index is out of range
          }
        }).toList(),
      ),
    );
  }
}
