import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterScreen(),
    );
  }
}

class SprinklerButton extends StatelessWidget {
  final String sprinklerType;
  final String imagePath;
  final Function(String) onPressed;
  final bool isHighlighted;

  const SprinklerButton({
    required this.sprinklerType,
    required this.imagePath,
    required this.onPressed,
    required this.isHighlighted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onPressed(sprinklerType);
          },
          highlightColor: Colors.transparent, // Add this line
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isHighlighted
                    ? const Color.fromARGB(84, 76, 175, 79)
                    : Colors.transparent,
                width: 3.0,
              ),
              color: isHighlighted
                  ? const Color.fromARGB(84, 76, 175, 79)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(isHighlighted ? 12.0 : 0.0),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double imageSize = constraints.maxWidth * 0.15;
                return FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                    imagePath,
                    width: imageSize,
                    height: imageSize,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          getSprinklerName(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Irrigate ${getMinimumRange()} tiles',
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 49, 94, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String getSprinklerName() {
    switch (sprinklerType) {
      case 'Normal':
        return 'Normal sprinkler';
      case 'Quality':
        return 'Quality sprinkler';
      case 'Iridium':
        return 'Iridium sprinkler';
      default:
        return 'Unknown sprinkler';
    }
  }

  int getMinimumRange() {
    switch (sprinklerType) {
      case 'Normal':
        return 4;
      case 'Quality':
        return 8;
      case 'Iridium':
        return 24;
      default:
        return 0;
    }
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  CounterScreenState createState() => CounterScreenState();
}

class CounterScreenState extends State<CounterScreen> {
  String _counterValue = '0';
  String selectedSprinkler = '';
  bool isNormalHighlighted = false;
  bool isQualityHighlighted = false;
  bool isIridiumHighlighted = false;
  String seedsToBuyResult = '';
  TextEditingController counterController = TextEditingController();

  void _setCounterValue(String value) {
    try {
      int parsedValue = int.parse(value);

      setState(() {
        _counterValue = parsedValue.toString();
        seedsToBuyResult = '';
      });
    } catch (forException) {
      debugPrint('Invalid input. Please enter a valid number.');
    }
  }

  void _setSelectedSprinkler(String sprinklerType) {
    setState(() {
      if (selectedSprinkler == sprinklerType) {
        selectedSprinkler = '';
        isNormalHighlighted = false;
        isQualityHighlighted = false;
        isIridiumHighlighted = false;
        seedsToBuyResult = '';
      } else {
        selectedSprinkler = sprinklerType;
        isNormalHighlighted = sprinklerType == 'Normal';
        isQualityHighlighted = sprinklerType == 'Quality';
        isIridiumHighlighted = sprinklerType == 'Iridium';
      }
    });
  }

  int calculateSeeds() {
    int seedsPerTile;
    switch (selectedSprinkler) {
      case 'Normal':
        seedsPerTile = 4;
        break;
      case 'Quality':
        seedsPerTile = 8;
        break;
      case 'Iridium':
        seedsPerTile = 24;
        break;
      default:
        seedsPerTile = 1;
    }

    return int.parse(_counterValue) * seedsPerTile;
  }

  void _resetSelection() {
    setState(() {
      selectedSprinkler = '';
      isNormalHighlighted = false;
      isQualityHighlighted = false;
      isIridiumHighlighted = false;
      counterController.text = '0';
      seedsToBuyResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 255, 253, 250),
            Color.fromARGB(255, 81, 225, 100),
          ],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                const SizedBox(height: 60),
                const Text(
                  'Select your sprinkler:',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      SprinklerButton(
                        sprinklerType: 'Normal',
                        imagePath: 'assets/images/normal_sprinkler.png',
                        onPressed: _setSelectedSprinkler,
                        isHighlighted: isNormalHighlighted,
                      ),
                      SprinklerButton(
                        sprinklerType: 'Quality',
                        imagePath: 'assets/images/quality_sprinkler.png',
                        onPressed: _setSelectedSprinkler,
                        isHighlighted: isQualityHighlighted,
                      ),
                      SprinklerButton(
                        sprinklerType: 'Iridium',
                        imagePath: 'assets/images/iridium_sprinkler.png',
                        onPressed: _setSelectedSprinkler,
                        isHighlighted: isIridiumHighlighted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment:
                        WrapCrossAlignment.center, // Add this line
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      const Text(
                        'Type the number of Sprinklers: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 80,
                        child: TextField(
                          controller: counterController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                          onChanged: _setCounterValue,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 15,
                  children: [
                    TextButton.icon(
                      icon: const Icon(
                        Icons.restore,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const Text(''),
                      onPressed: _resetSelection,
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.zero, // Remove any padding around the icon
                        alignment:
                            Alignment.center, // Center the icon within the button
                      ),
                    ),
                    SizedBox(
                      width: 280,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {
                            int seedsToBuy = calculateSeeds();
                            setState(() {
                              seedsToBuyResult =
                                  'You need to buy $seedsToBuy seeds.';
                            });
                          },
                          child: const Text(
                            'Calculate Seeds to Buy',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  seedsToBuyResult,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(
                      255,
                      32,
                      72,
                      33,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
