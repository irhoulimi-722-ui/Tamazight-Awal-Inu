import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const AmazighLearnApp());
}

class AmazighLearnApp extends StatelessWidget {
  const AmazighLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ⴰⵎⴰⵣⵉⵖ Learn - Amazigh Learn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const AlphabetSectionScreen(),
    );
  }
}

// ==========================================
// 1. DATA MODELS & IRCAM 31 ALPHABET DATA
// ==========================================

class LetterModel {
  final String symbol; // Tifinagh Symbol
  final String name; // Name / Sound
  final String exampleWord; // Word with letter
  final String wordMeaning; // Word meaning in Arabic
  final List<Offset> pathPoints; // Normalized path points for stroke animation

  LetterModel({
    required this.symbol,
    required this.name,
    required this.exampleWord,
    required this.wordMeaning,
    required this.pathPoints,
  });
}

class LevelModel {
  final int levelNumber;
  final List<LetterModel> letters;
  bool isUnlocked;

  LevelModel({
    required this.levelNumber,
    required this.letters,
    this.isUnlocked = false,
  });
}

// Master pool of distractor words that don't contain targeted letters
const List<Map<String, String>> masterWordPool = [
  {'word': 'ⵜⵉⵜⵜ', 'meaning': 'عين'},
  {'word': 'ⵢⵓⵍ', 'meaning': 'قمر'},
  {'word': 'ⵉⵎⵉ', 'meaning': 'فم'},
  {'word': 'ⴰⴷⵔⴰⵔ', 'meaning': 'جبل'},
  {'word': 'ⵜⴰⴳⵯⵔⵜ', 'meaning': 'باب'},
  {'word': 'ⴰⴹⴰⵕ', 'meaning': 'قدم'},
  {'word': 'ⵜⴰⴳⴰⵏⵜ', 'meaning': 'غابة'},
  {'word': 'ⵜⵉⵖⵔⵎⵜ', 'meaning': 'قلعة'},
  {'word': 'ⵜⴰⵙⴳⴰ', 'meaning': 'جهة'},
  {'word': 'ⵜⵉⵎⵉⵣⴰⵔ', 'meaning': 'بلاد'},
  {'word': 'ⴰⵙⵉⴼ', 'meaning': 'نهر'},
];

// Helper to standard IRCAM 31 Tifinagh letters
List<LevelModel> generateIrcamLevels() {
  final List<LetterModel> all31Letters = [
    // Level 1
    LetterModel(
      symbol: 'ⴰ',
      name: 'Yaf (أ)',
      exampleWord: 'ⴰⵎⴰⵏ',
      wordMeaning: 'ماء',
      pathPoints: const [
        Offset(0.2, 0.8),
        Offset(0.5, 0.2),
        Offset(0.8, 0.8),
        Offset(0.35, 0.55),
        Offset(0.65, 0.55),
      ],
    ),
    LetterModel(
      symbol: 'ⴱ',
      name: 'Yab (ب)',
      exampleWord: 'ⴱⴰⴱⴰ',
      wordMeaning: 'أبي',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.2, 0.8),
        Offset(0.8, 0.8),
        Offset(0.8, 0.2),
        Offset(0.2, 0.2),
      ],
    ),
    // Level 2
    LetterModel(
      symbol: 'ⴳ',
      name: 'Yag (ج/گ)',
      exampleWord: 'ⴳⴰⴷⵉⵔ',
      wordMeaning: 'سور',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⴳⵯ',
      name: 'Yagw (گو)',
      exampleWord: 'ⵜⴰⴳⵯⵔⵜ',
      wordMeaning: 'باب',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.6, 0.2),
        Offset(0.4, 0.2),
        Offset(0.4, 0.8),
        Offset(0.8, 0.5),
      ],
    ),
    // Level 3
    LetterModel(
      symbol: 'ⴷ',
      name: 'Yad (د)',
      exampleWord: 'ⴷⴰⴷⴰ',
      wordMeaning: 'أخ أكبر',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.8, 0.8),
        Offset(0.2, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⴹ',
      name: 'Yaḍ (ض)',
      exampleWord: 'ⴰⴹⴰⵕ',
      wordMeaning: 'رجل/قدم',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.8, 0.8),
        Offset(0.2, 0.8),
        Offset(0.2, 0.2),
        Offset(0.8, 0.8),
      ],
    ),
    // Level 4
    LetterModel(
      symbol: 'ⴻ',
      name: 'Yey (أصغر)',
      exampleWord: 'ⴻⵍⵍⵉ',
      wordMeaning: 'ابنتي',
      pathPoints: const [
        Offset(0.5, 0.3),
        Offset(0.5, 0.7),
      ],
    ),
    LetterModel(
      symbol: 'ⴼ',
      name: 'Yaf (ف)',
      exampleWord: 'ⴼⵓⵙ',
      wordMeaning: 'يد',
      pathPoints: const [
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
        Offset(0.2, 0.5),
        Offset(0.8, 0.5),
      ],
    ),
    // Level 5
    LetterModel(
      symbol: 'ⴽ',
      name: 'Yak (ك)',
      exampleWord: 'ⴽⵜⴰⴱ',
      wordMeaning: 'كتاب',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.8),
        Offset(0.8, 0.2),
        Offset(0.2, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⴽⵯ',
      name: 'Yakw (كو)',
      exampleWord: 'ⴽⵯⵜⵉ',
      wordMeaning: 'تذكر',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.7, 0.7),
        Offset(0.7, 0.2),
        Offset(0.2, 0.7),
        Offset(0.8, 0.5),
      ],
    ),
    // Level 6
    LetterModel(
      symbol: 'ⵀ',
      name: 'Yah (هـ)',
      exampleWord: 'ⵀⴰⵜⵉ',
      wordMeaning: 'ها هو',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.2, 0.8),
        Offset(0.8, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⵃ',
      name: 'Yaḥ (ح)',
      exampleWord: 'ⵃⴰⴷⴰ',
      wordMeaning: 'قرب',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.8),
        Offset(0.5, 0.5),
        Offset(0.2, 0.8),
        Offset(0.8, 0.2),
      ],
    ),
    // Level 7
    LetterModel(
      symbol: 'ⵄ',
      name: 'Yaʿ (ع)',
      exampleWord: 'ⵄⴰⵔⵉ',
      wordMeaning: 'جبل',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.8, 0.8),
        Offset(0.2, 0.8),
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⵅ',
      name: 'Yakh (خ)',
      exampleWord: 'ⵅⴰⵍⵉ',
      wordMeaning: 'خالي',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.8),
        Offset(0.2, 0.8),
        Offset(0.8, 0.2),
      ],
    ),
    // Level 8
    LetterModel(
      symbol: 'ⵇ',
      name: 'Yaq (ق)',
      exampleWord: 'ⵇⴰⵔⵉ',
      wordMeaning: 'اقرأ',
      pathPoints: const [
        Offset(0.3, 0.3),
        Offset(0.7, 0.3),
        Offset(0.7, 0.7),
        Offset(0.3, 0.7),
        Offset(0.3, 0.3),
      ],
    ),
    LetterModel(
      symbol: 'ⵉ',
      name: 'Yi (ي)',
      exampleWord: 'ⵉⵎⵉ',
      wordMeaning: 'فم',
      pathPoints: const [
        Offset(0.2, 0.5),
        Offset(0.8, 0.5),
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
      ],
    ),
    // Level 9
    LetterModel(
      symbol: 'ⵊ',
      name: 'Yaj (ج)',
      exampleWord: 'ⵊⵊⵉ',
      wordMeaning: 'شفاء',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
        Offset(0.2, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⵍ',
      name: 'Yal (ل)',
      exampleWord: 'ⵍⴰⵥ',
      wordMeaning: 'جوع',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.2, 0.8),
        Offset(0.8, 0.8),
      ],
    ),
    // Level 10
    LetterModel(
      symbol: 'ⵎ',
      name: 'Yam (م)',
      exampleWord: 'ⵎⴰⵎⴰ',
      wordMeaning: 'أمي',
      pathPoints: const [
        Offset(0.2, 0.8),
        Offset(0.2, 0.2),
        Offset(0.5, 0.6),
        Offset(0.8, 0.2),
        Offset(0.8, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⵏ',
      name: 'Yan (ن)',
      exampleWord: 'ⵏⴽⴽⵉ',
      wordMeaning: 'أنا',
      pathPoints: const [
        Offset(0.2, 0.8),
        Offset(0.2, 0.2),
        Offset(0.8, 0.8),
        Offset(0.8, 0.2),
      ],
    ),
    // Level 11
    LetterModel(
      symbol: 'ⵓ',
      name: 'Yu (و/أو)',
      exampleWord: 'ⵓⵍ',
      wordMeaning: 'قلب',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.5, 0.8),
      ],
    ),
    LetterModel(
      symbol: 'ⵔ',
      name: 'Yar (ر)',
      exampleWord: 'ⵔⴰⵢ',
      wordMeaning: 'رأي',
      pathPoints: const [
        Offset(0.5, 0.5),
        Offset(0.8, 0.5),
        Offset(0.8, 0.2),
        Offset(0.2, 0.2),
        Offset(0.2, 0.8),
        Offset(0.8, 0.8),
      ],
    ),
    // Level 12
    LetterModel(
      symbol: 'ⵕ',
      name: 'Yaṛ (ر مفخمة)',
      exampleWord: 'ⵕⴱⴱⵉ',
      wordMeaning: 'ربي',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.8, 0.8),
        Offset(0.2, 0.8),
        Offset(0.5, 0.5),
      ],
    ),
    LetterModel(
      symbol: 'ⵙ',
      name: 'Yas (س)',
      exampleWord: 'ⵙⵉⵏ',
      wordMeaning: 'اثنان',
      pathPoints: const [
        Offset(0.8, 0.2),
        Offset(0.2, 0.2),
        Offset(0.2, 0.5),
        Offset(0.8, 0.5),
        Offset(0.8, 0.8),
        Offset(0.2, 0.8),
      ],
    ),
    // Level 13
    LetterModel(
      symbol: 'ⵚ',
      name: 'Yaṣ (ص)',
      exampleWord: 'ⵚⵃⴰ',
      wordMeaning: 'صحة',
      pathPoints: const [
        Offset(0.8, 0.2),
        Offset(0.2, 0.2),
        Offset(0.2, 0.8),
        Offset(0.8, 0.8),
        Offset(0.5, 0.5),
      ],
    ),
    LetterModel(
      symbol: 'ⵛ',
      name: 'Yash (ش)',
      exampleWord: 'ⵛⵀⴰ',
      wordMeaning: 'شهية',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.2, 0.8),
        Offset(0.8, 0.8),
        Offset(0.5, 0.2),
      ],
    ),
    // Level 14
    LetterModel(
      symbol: 'ⵜ',
      name: 'Yat (ت)',
      exampleWord: 'ⵜⵉⵜⵜ',
      wordMeaning: 'عين',
      pathPoints: const [
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
        Offset(0.2, 0.5),
        Offset(0.8, 0.5),
      ],
    ),
    LetterModel(
      symbol: 'ⵟ',
      name: 'Yaṭ (ط)',
      exampleWord: 'ⵟⵟⴰⴱⵍⴰ',
      wordMeaning: 'طاولة',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.2),
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
        Offset(0.2, 0.8),
        Offset(0.8, 0.8),
      ],
    ),
    // Level 15
    LetterModel(
      symbol: 'ⵡ',
      name: 'Yaw (و)',
      exampleWord: 'ⵡⴰⵍⵓ',
      wordMeaning: 'لا شيء',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.5, 0.8),
        Offset(0.8, 0.2),
      ],
    ),
    LetterModel(
      symbol: 'ⵢ',
      name: 'Yay (ي)',
      exampleWord: 'ⵢⵓⵍ',
      wordMeaning: 'قمر',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.5, 0.5),
        Offset(0.8, 0.2),
        Offset(0.5, 0.5),
        Offset(0.5, 0.8),
      ],
    ),
    // Level 16
    LetterModel(
      symbol: 'ⵥ',
      name: 'Yaẓ (ز مفخمة)',
      exampleWord: 'ⵥⴰⵕ',
      wordMeaning: 'انظر',
      pathPoints: const [
        Offset(0.2, 0.2),
        Offset(0.8, 0.8),
        Offset(0.8, 0.2),
        Offset(0.2, 0.8),
        Offset(0.5, 0.2),
        Offset(0.5, 0.8),
      ],
    ),
  ];

  final List<LevelModel> levels = [];
  int levelCounter = 1;

  for (int i = 0; i < all31Letters.length; i += 2) {
    final pair = [
      all31Letters[i],
      if (i + 1 < all31Letters.length) all31Letters[i + 1],
    ];

    levels.add(
      LevelModel(
        levelNumber: levelCounter,
        letters: pair,
        isUnlocked: levelCounter == 1, // Level 1 unlocked by default
      ),
    );
    levelCounter++;
  }

  return levels;
}

// ==========================================
// 2. MAIN ALPHABET SCREEN (LEVELS LIST)
// ==========================================

class AlphabetSectionScreen extends StatefulWidget {
  const AlphabetSectionScreen({super.key});

  @override
  State<AlphabetSectionScreen> createState() => _AlphabetSectionScreenState();
}

class _AlphabetSectionScreenState extends State<AlphabetSectionScreen> {
  late List<LevelModel> levels;

  @override
  void initState() {
    super.initState();
    levels = generateIrcamLevels();
  }

  void _openLetterJourney(LetterModel letter, int levelIdx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InteractiveLetterJourneyScreen(
          letter: letter,
          onComplete: () {
            setState(() {
              if (levelIdx + 1 < levels.length) {
                levels[levelIdx + 1].isUnlocked = true;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ⴰⴳⵎⵎⴰⵢ - الأبجدية الأمازيغية (31 حرفاً)'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.orange.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final level = levels[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: level.isUnlocked ? Colors.white : Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المستوى ${level.levelNumber} (ⴰⵙⵡⵉⵔ ${level.levelNumber})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: level.isUnlocked
                                ? Colors.teal.shade800
                                : Colors.grey.shade600,
                          ),
                        ),
                        Icon(
                          level.isUnlocked
                              ? Icons.lock_open_rounded
                              : Icons.lock_rounded,
                          color: level.isUnlocked ? Colors.green : Colors.grey,
                          size: 28,
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: level.letters.map((letter) {
                        return ElevatedButton(
                          onPressed: level.isUnlocked
                              ? () => _openLetterJourney(letter, index)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: level.isUnlocked
                                ? Colors.orange.shade400
                                : Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                letter.symbol,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                letter.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// 3. THE 4-STEP INTERACTIVE LETTER JOURNEY
// ==========================================

class InteractiveLetterJourneyScreen extends StatefulWidget {
  final LetterModel letter;
  final VoidCallback onComplete;

  const InteractiveLetterJourneyScreen({
    super.key,
    required this.letter,
    required this.onComplete,
  });

  @override
  State<InteractiveLetterJourneyScreen> createState() =>
      _InteractiveLetterJourneyScreenState();
}

class _InteractiveLetterJourneyScreenState
    extends State<InteractiveLetterJourneyScreen>
    with SingleTickerProviderStateMixin {
  int currentStage = 0; // 0: Listen, 1: Animated Watch, 2: Write, 3: Quiz

  // Stage 1 Animation
  late AnimationController _penAnimationController;

  // Stage 2 Interactive Drawing
  List<Offset?> userDrawingPoints = [];

  // Stage 3 Quiz Options (Exactly 1 contains target letter)
  late List<Map<String, dynamic>> quizOptions;
  int? selectedOptionIndex;
  bool isAnswerCorrect = false;

  @override
  void initState() {
    super.initState();

    // Pen animation setup
    _penAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _setupQuizOptions();
  }

  @override
  void dispose() {
    _penAnimationController.dispose();
    super.dispose();
  }

  // Generate 4 options: EXACTLY 1 correct word containing target letter!
  void _setupQuizOptions() {
    final String targetLetter = widget.letter.symbol;

    // Filter master pool to find distractors that DO NOT contain target letter
    List<Map<String, String>> validDistractors = masterWordPool.where((w) {
      return !w['word']!.contains(targetLetter) &&
          w['word'] != widget.letter.exampleWord;
    }).toList();

    validDistractors.shuffle();

    // Pick top 3 distractors
    List<Map<String, dynamic>> options = [];

    // Add target word (Correct)
    options.add({
      'word': widget.letter.exampleWord,
      'meaning': widget.letter.wordMeaning,
      'isCorrect': true,
    });

    // Add 3 distractors
    for (int i = 0; i < 3 && i < validDistractors.length; i++) {
      options.add({
        'word': validDistractors[i]['word']!,
        'meaning': validDistractors[i]['meaning']!,
        'isCorrect': false,
      });
    }

    options.shuffle(); // Randomize order
    quizOptions = options;
  }

  void _nextStage() {
    if (currentStage < 3) {
      setState(() {
        currentStage++;
        if (currentStage == 1) {
          _penAnimationController.reset();
          _penAnimationController.forward();
        }
      });
    } else {
      widget.onComplete();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 ممتاز! أتممت إتقان الحرف بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('رحلة الحرف: ${widget.letter.symbol} (${widget.letter.name})'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Stage Progress Indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.teal.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressBadge(0, '🔊 الاستماع'),
                _buildProgressBadge(1, '✍️ المشاهدة'),
                _buildProgressBadge(2, '✏️ الكتابة'),
                _buildProgressBadge(3, '🔍 التمييز'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStageContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBadge(int stageIndex, String title) {
    final bool isActive = currentStage == stageIndex;
    final bool isDone = currentStage > stageIndex;

    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isDone
              ? Colors.green
              : (isActive ? Colors.teal : Colors.grey.shade300),
          child: isDone
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : Text(
                  '${stageIndex + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.teal.shade900 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStageContent() {
    switch (currentStage) {
      case 0:
        return _buildStage0Listening();
      case 1:
        return _buildStage1AnimatedDrawing();
      case 2:
        return _buildStage2InteractiveWriting();
      case 3:
        return _buildStage3WordDiscrimination();
      default:
        return Container();
    }
  }

  // STAGE 0: LISTENING
  Widget _buildStage0Listening() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'استمع إلى صوت الحرف جيداً:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🔊 صوت الحرف: ${widget.letter.name}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.orange.shade300,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Text(
              widget.letter.symbol,
              style: const TextStyle(
                fontSize: 80,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🔊 تشغيل الصوت: ${widget.letter.name}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          icon: const Icon(Icons.volume_up, size: 28),
          label: const Text('إعادة الاستماع للصوت', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _nextStage,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('المرحلة التالية ➔', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // STAGE 1: ANIMATED WATCHING (PEN FOLLOWING PATH)
  Widget _buildStage1AnimatedDrawing() {
    return Column(
      children: [
        const Text(
          'شاهد كيف يُرسم الحرف بالقلم (لاحظ نقطة البداية والنهاية):',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal, width: 2),
            ),
            child: AnimatedBuilder(
              animation: _penAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedPenPainter(
                    points: widget.letter.pathPoints,
                    progress: _penAnimationController.value,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _penAnimationController.reset();
                _penAnimationController.forward();
              },
              icon: const Icon(Icons.replay),
              label: const Text('إعادة رسم الحرف القلم'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _nextStage,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('انتقل للتجربة بنفسك ➔', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // STAGE 2: INTERACTIVE WRITING (CANVAS WITH CLEAR / RETRY OPPORTUNITIES)
  Widget _buildStage2InteractiveWriting() {
    return Column(
      children: [
        const Text(
          'تدرّب على رسم الحرف فوق الشكل الشفاف:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.shade300, width: 2),
            ),
            child: Stack(
              children: [
                // Background Guide Letter
                Center(
                  child: Text(
                    widget.letter.symbol,
                    style: TextStyle(
                      fontSize: 220,
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // User Touch Canvas
                GestureDetector(
                  onPanUpdate: (details) {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    setState(() {
                      userDrawingPoints.add(renderBox.globalToLocal(details.globalPosition));
                    });
                  },
                  onPanEnd: (details) {
                    userDrawingPoints.add(null);
                  },
                  child: CustomPaint(
                    painter: UserDrawingPainter(points: userDrawingPoints),
                    size: Size.infinite,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Retry / Clear Button as requested
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  userDrawingPoints.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم المسح! حاول مرة أخرى بكل هدوء 👍'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep),
              label: const Text('🗑️ مسح وإعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: userDrawingPoints.isNotEmpty
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('أحسنت! كتابة ممتازة ومطابقة!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.check),
              label: const Text('تأكيد الرسم'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: userDrawingPoints.isNotEmpty ? _nextStage : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: const Text('مرحلة التقويم والتمييز ➔', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // STAGE 3: WORD DISCRIMINATION / QUIZ (EXACTLY 1 WORD HAS THE TARGET LETTER)
  Widget _buildStage3WordDiscrimination() {
    return Column(
      children: [
        Text(
          'اختر الكلمة الوحيدة التي تحتوي على الحرف ( ${widget.letter.symbol} ):',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: quizOptions.length,
            itemBuilder: (context, index) {
              final option = quizOptions[index];
              final bool isSelected = selectedOptionIndex == index;

              Color cardColor = Colors.white;
              if (isSelected) {
                cardColor = option['isCorrect']
                    ? Colors.green.shade100
                    : Colors.red.shade100;
              }

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedOptionIndex = index;
                    isAnswerCorrect = option['isCorrect'];
                  });

                  if (option['isCorrect']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('إجابة صحيحة برافو! 🌟'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('حاول مرة أخرى! هذه الكلمة لا تحتوي على الحرف المطلوبة.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: Card(
                  elevation: 4,
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? (option['isCorrect'] ? Colors.green : Colors.red)
                          : Colors.teal.shade200,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option['word'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '(${option['meaning']})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isAnswerCorrect ? _nextStage : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: const Text('إتمام الحرف والعودة للقائمة 🎉', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. CUSTOM PAINTERS (PEN & DRAWING)
// ==========================================

class AnimatedPenPainter extends CustomPainter {
  final List<Offset> points;
  final double progress;

  AnimatedPenPainter({required this.points, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Convert normalized points to canvas dimensions
    List<Offset> scaledPoints = points.map((p) {
      return Offset(p.dx * size.width, p.dy * size.height);
    }).toList();

    // 1. Draw guide full stroke (Light Gray)
    final Paint guidePaint = Paint()
      :color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path fullPath = Path();
    fullPath.moveTo(scaledPoints[0].dx, scaledPoints[0].dy);
    for (int i = 1; i < scaledPoints.length; i++) {
      fullPath.lineTo(scaledPoints[i].dx, scaledPoints[i].dy);
    }
    canvas.drawPath(fullPath, guidePaint);

    // 2. Start & End Markers
    final Paint startPaint = Paint()..color = Colors.green;
    final Paint endPaint = Paint()..color = Colors.red;

    canvas.drawCircle(scaledPoints.first, 12, startPaint);
    canvas.drawCircle(scaledPoints.last, 12, endPaint);

    // 3. Draw animated stroke progressively
    final Paint activePaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path animatedPath = Path();
    animatedPath.moveTo(scaledPoints[0].dx, scaledPoints[0].dy);

    int totalSegments = scaledPoints.length - 1;
    double currentProgress = progress * totalSegments;
    int currentSegment = currentProgress.floor();
    double segmentFactor = currentProgress - currentSegment;

    for (int i = 0; i < currentSegment && i < totalSegments; i++) {
      animatedPath.lineTo(scaledPoints[i + 1].dx, scaledPoints[i + 1].dy);
    }

    Offset currentPenPos = scaledPoints.first;

    if (currentSegment < totalSegments) {
      Offset p1 = scaledPoints[currentSegment];
      Offset p2 = scaledPoints[currentSegment + 1];
      currentPenPos = Offset(
        p1.dx + (p2.dx - p1.dx) * segmentFactor,
        p1.dy + (p2.dy - p1.dy) * segmentFactor,
      );
      animatedPath.lineTo(currentPenPos.dx, currentPenPos.dy);
    } else {
      currentPenPos = scaledPoints.last;
    }

    canvas.drawPath(animatedPath, activePaint);

    // 4. Draw Animated Pen / Pencil Icon at moving point
    final Paint penBodyPaint = Paint()..color = Colors.orange;
    canvas.drawCircle(currentPenPos, 16, penBodyPaint);

    TextPainter tp = TextPainter(
      text: const TextSpan(
        text: '✏️',
        style: TextStyle(fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(currentPenPos.dx - 10, currentPenPos.dy - 12),
    );
  }

  @override
  bool shouldRepaint(covariant AnimatedPenPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class UserDrawingPainter extends CustomPainter {
  final List<Offset?> points;

  UserDrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.deepOrange
      ..strokeCap = StrokeCap.round;
      strokeWidth: 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant UserDrawingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
