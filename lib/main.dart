import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

void main() {
  runApp(const AmazighApp());
}

class AmazighApp extends StatelessWidget {
  const AmazighApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamazight Awal Inu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal.shade50,
        fontFamily: 'Arial',
      ),
      home: const LevelsScreen(),
    );
  }
}

// ==========================================
// 1. البيانات (الحروف والمستويات والكلمات)
// ==========================================

final List<String> tifinaghLetters = [
  'ⴰ', 'ⴱ', 'ⵛ', 'ⴷ', 'ⴹ', 'ⴻ', 'ⴼ', 'ⴳ', 'ⴳⵯ', 'ⵀ', 'ⵃ', 'ⵉ', 'ⵊ', 'ⴽ', 'ⴽⵯ',
  'ⵍ', 'ⵎ', 'ⵏ', 'ⵓ', 'ⵇ', 'ⵖ', 'ⵔ', 'ⵕ', 'ⵙ', 'ⵚ', 'ⵜ', 'ⵟ', 'ⵡ', 'ⵅ', 'ⵢ', 'ⵣ', 'ⵥ'
];

// قاموس مصغر لاختبار الكلمات (يجب أن يحتوي على كلمات حقيقية)
final List<String> dictionary = [
  'ⴰⵎⴰⵏ', 'ⴰⴼⵔⵓⵅ', 'ⵜⴰⴼⵓⴽⵜ', 'ⴰⵖⵢⵓⵍ', 'ⴰⴷⵔⴰⵔ', 'ⵉⵙⵍⵎ', 'ⴰⵖⵔⵓⵎ',
  'ⴰⵔⴳⴰⵣ', 'ⵜⴰⵎⵖⴰⵔⵜ', 'ⴰⵖⵏⵊⴰ', 'ⵜⵉⵟⵟ', 'ⴰⴹⴰⵕ', 'ⴰⴼⵓⵙ', 'ⵉⵎⵉ',
  'ⴰⵅⵅⴰⵎ', 'ⴰⵢⴷⵉ', 'ⴱⴰⴱⴰ', 'ⵎⴰⵎⴰ', 'ⵙⵉⵏ', 'ⴽⵔⴰⴹ'
];

// ==========================================
// 2. شاشة المستويات (16 مستوى)
// ==========================================
class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  int unlockedLevel = 1; // المستوى الأول مفتوح افتراضياً

  void unlockNextLevel(int currentLevel) {
    if (currentLevel == unlockedLevel && unlockedLevel < 16) {
      setState(() {
        unlockedLevel++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستويات - ⵜⵉⵙⴽⴼⴰⵍ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            int levelNum = index + 1;
            bool isUnlocked = levelNum <= unlockedLevel;
            
            // تحديد حروف المستوى (حرفين لكل مستوى، والأخير حرف واحد)
            int letterIndex1 = index * 2;
            int letterIndex2 = letterIndex1 + 1;
            String levelLetters = "";
            if (letterIndex1 < tifinaghLetters.length) {
              levelLetters += tifinaghLetters[letterIndex1];
            }
            if (letterIndex2 < tifinaghLetters.length) {
              levelLetters += " - ${tifinaghLetters[letterIndex2]}";
            }

            return GestureDetector(
              onTap: isUnlocked
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LetterStagesScreen(
                            levelNum: levelNum,
                            letter1: letterIndex1 < tifinaghLetters.length ? tifinaghLetters[letterIndex1] : '',
                            letter2: letterIndex2 < tifinaghLetters.length ? tifinaghLetters[letterIndex2] : '',
                            onLevelComplete: () => unlockNextLevel(levelNum),
                          ),
                        ),
                      );
                    }
                  : null,
              child: Card(
                color: isUnlocked ? Colors.white : Colors.grey.shade300,
                elevation: isUnlocked ? 4 : 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'مستوى $levelNum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.teal : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      isUnlocked
                          ? Text(levelLetters, style: const TextStyle(fontSize: 20, color: Colors.orange))
                          : const Icon(Icons.lock, color: Colors.grey, size: 30),
                    ],
                  ),
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
// 3. شاشة المراحل الأربعة للحرف
// ==========================================
class LetterStagesScreen extends StatefulWidget {
  final int levelNum;
  final String letter1;
  final String letter2;
  final VoidCallback onLevelComplete;

  const LetterStagesScreen({
    super.key,
    required this.levelNum,
    required this.letter1,
    required this.letter2,
    required this.onLevelComplete,
  });

  @override
  State<LetterStagesScreen> createState() => _LetterStagesScreenState();
}

class _LetterStagesScreenState extends State<LetterStagesScreen> {
  int currentStage = 0; // 0: الاستماع, 1: المشاهدة, 2: الكتابة, 3: التقويم
  bool isFirstLetterCompleted = false;
  late String currentLetter;

  @override
  void initState() {
    super.initState();
    currentLetter = widget.letter1;
  }

  void nextStage() {
    if (currentStage < 3) {
      setState(() {
        currentStage++;
      });
    } else {
      // إنهاء الحرف الحالي
      if (!isFirstLetterCompleted && widget.letter2.isNotEmpty) {
        setState(() {
          isFirstLetterCompleted = true;
          currentLetter = widget.letter2;
          currentStage = 0; // العودة للمرحلة الأولى للحرف الثاني
        });
      } else {
        // إنهاء المستوى
        widget.onLevelComplete();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 أحسنت! أكملت المستوى ${widget.levelNum} بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget stageWidget;
    switch (currentStage) {
      case 0:
        stageWidget = Stage1Listening(letter: currentLetter, onNext: nextStage);
        break;
      case 1:
        stageWidget = Stage2Watching(letter: currentLetter, onNext: nextStage);
        break;
      case 2:
        stageWidget = Stage3Writing(letter: currentLetter, onNext: nextStage);
        break;
      case 3:
        stageWidget = Stage4Evaluation(letter: currentLetter, onNext: nextStage);
        break;
      default:
        stageWidget = const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('تعلم الحرف: $currentLetter'),
        backgroundColor: Colors.teal,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: stageWidget,
      ),
    );
  }
}

// --- المرحلة 1: الاستماع ---
class Stage1Listening extends StatelessWidget {
  final String letter;
  final VoidCallback onNext;

  const Stage1Listening({super.key, required this.letter, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('استمع لصوت الحرف 🔊', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
            ),
            child: Text(letter, style: const TextStyle(fontSize: 100, color: Colors.teal)),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              // هنا يوضع كود تشغيل الصوت مستقبلاً
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تشغيل الصوت (تجريبي)')));
            },
            icon: const Icon(Icons.volume_up, size: 30),
            label: const Text('استمع', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            child: const Text('التالي ➡️', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}

// --- المرحلة 2: المشاهدة (مع التصحيح البرمجي) ---
class Stage2Watching extends StatefulWidget {
  final String letter;
  final VoidCallback onNext;

  const Stage2Watching({super.key, required this.letter, required this.onNext});

  @override
  State<Stage2Watching> createState() => _Stage2WatchingState();
}

class _Stage2WatchingState extends State<Stage2Watching> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // مسار افتراضي بسيط للتجربة (يمكنك استبداله بمسارات الحروف الحقيقية)
    Path dummyPath = Path()
      ..moveTo(50, 50)
      ..lineTo(150, 50)
      ..lineTo(100, 150)
      ..lineTo(50, 50);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('شاهد كيف يُرسم الحرف ✍️', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedPenPainter(
                    progress: _controller.value,
                    letterPath: dummyPath,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _controller.reset();
                  _controller.forward();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة العرض'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('التالي ➡️'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// --- الكلاس المصحح (AnimatedPenPainter) ---
class AnimatedPenPainter extends CustomPainter {
  final double progress;
  final Path letterPath;

  AnimatedPenPainter({required this.progress, required this.letterPath});

  @override
  void paint(Canvas canvas, Size size) {
    // 🔴 تم التصحيح هنا: استخدام النقطتين المتتابعتين (..) بدلاً من النقطتين الرأسيتين (:)
    final Paint guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint drawPaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // رسم المسار الباهت كدليل
    canvas.drawPath(letterPath, guidePaint);

    // رسم المسار المتحرك
    ui.PathMetrics pathMetrics = letterPath.computeMetrics();
    for (ui.PathMetric metric in pathMetrics) {
      Path extractPath = metric.extractPath(0.0, metric.length * progress);
      canvas.drawPath(extractPath, drawPaint);
      
      // رسم القلم (نقطة حمراء) في رأس المسار
      if (progress > 0.0 && progress < 1.0) {
        var metricData = metric.getTangentForOffset(metric.length * progress);
        if (metricData != null) {
          canvas.drawCircle(metricData.position, 10, Paint()..color = Colors.red);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedPenPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// --- المرحلة 3: الكتابة الحرّة (مع زر المسح) ---
class Stage3Writing extends StatefulWidget {
  final String letter;
  final VoidCallback onNext;

  const Stage3Writing({super.key, required this.letter, required this.onNext});

  @override
  State<Stage3Writing> createState() => _Stage3WritingState();
}

class _Stage3WritingState extends State<Stage3Writing> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('ارسم الحرف بإصبعك ✏️', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.teal, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // الحرف الباهت في الخلفية
                Text(widget.letter, style: TextStyle(fontSize: 200, color: Colors.grey.shade200)),
                // مساحة الرسم
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      points.add(renderBox.globalToLocal(details.globalPosition));
                    });
                  },
                  onPanEnd: (details) => setState(() => points.add(null)),
                  child: CustomPaint(
                    painter: DrawingPainter(points: points),
                    size: Size.infinite,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() => points.clear()),
                icon: const Icon(Icons.delete),
                label: const Text('مسح 🗑️'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: widget.onNext,
                icon: const Icon(Icons.check),
                label: const Text('تأكيد ✅'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.teal
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- المرحلة 4: التقويم (كلمة واحدة صحيحة) ---
class Stage4Evaluation extends StatefulWidget {
  final String letter;
  final VoidCallback onNext;

  const Stage4Evaluation({super.key, required this.letter, required this.onNext});

  @override
  State<Stage4Evaluation> createState() => _Stage4EvaluationState();
}

class _Stage4EvaluationState extends State<Stage4Evaluation> {
  List<String> options = [];
  String? selectedWord;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  void _generateOptions() {
    // 1. جلب الكلمات التي تحتوي على الحرف
    List<String> correctWords = dictionary.where((w) => w.contains(widget.letter)).toList();
    // 2. جلب الكلمات التي لا تحتوي على الحرف
    List<String> incorrectWords = dictionary.where((w) => !w.contains(widget.letter)).toList();

    String correctWord = correctWords.isNotEmpty ? correctWords[Random().nextInt(correctWords.length)] : widget.letter + 'ⴰⵎⴰⵏ';
    incorrectWords.shuffle();
    List<String> chosenIncorrect = incorrectWords.take(3).toList();

    options = [correctWord, ...chosenIncorrect];
    options.shuffle();
  }

  void _checkAnswer(String word) {
    setState(() {
      selectedWord = word;
      isCorrect = word.contains(widget.letter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('أين يوجد الحرف [ ${widget.letter} ] ؟ 🔍', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: options.map((word) {
              bool isSelected = selectedWord == word;
              Color cardColor = Colors.white;
              if (isSelected) {
                cardColor = isCorrect! ? Colors.green.shade200 : Colors.red.shade200;
              }

              return GestureDetector(
                onTap: selectedWord == null ? () => _checkAnswer(word) : null,
                child: Container(
                  width: 150,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.teal, width: 2),
                  ),
                  child: Text(word, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          if (isCorrect == true)
            ElevatedButton(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text('ممتاز! استمر 🌟', style: TextStyle(fontSize: 20)),
            ),
          if (isCorrect == false)
            ElevatedButton(
              onPressed: () => setState(() { selectedWord = null; isCorrect = null; }),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('حاول مرة أخرى 🔄'),
            ),
        ],
      ),
    );
  }
}
