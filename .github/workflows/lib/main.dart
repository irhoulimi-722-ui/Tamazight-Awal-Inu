import 'package:flutter/material.dart';

void main() {
  runApp(const AmazighApp());
}

class AmazighApp extends StatelessWidget {
  const AmazighApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ⴰⵎⴰⵣⵉⵖ Amazigh Learn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // القائمة الكاملة للصفحات الستة بعد دمج قسم الحروف التفاعلي
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeTab(),
      const AgmmayPathScreen(), // قسم الحروف التفاعلي والمدمج بالكامل
      const Center(child: Text('📚 ⵜⵉⴳⵓⵔⵉⵡⵉⵏ - قسم المفردات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      const Center(child: Text('🎮 ⵓⵔⴰⵔⵏ - قسم الألعاب', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      const Center(child: Text('📊 ⴰⵙⵓⵜⴳ - قسم التقييم والنتائج', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      const Center(child: Text('👤 ⴰⵙⵍⵎⴰⴷ - فضاء الأستاذ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // شريط التنقل السفلي بالأمازيغية والأيقونات
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedFontSize: 13,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ⴰⵙⵏⵓⴱⴱⴳ'),
          BottomNavigationBarItem(icon: Icon(Icons.sort_by_alpha), label: 'ⴰⴳⵎⵎⴰⵢ'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'ⵜⵉⴳⵓⵔⵉⵡⵉⵏ'),
          BottomNavigationBarItem(icon: Icon(Icons.extension), label: 'ⵓⵔⴰⵔⵏ'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'ⴰⵙⵓⵜⴳ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ⴰⵙⵍⵎⴰⴷ'),
        ],
      ),
    );
  }
}

// 🏠 1. الشاشة الرئيسية (ⴰⵙⵏⵓⴱⴱⴳ)
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text(
          'ⴰⵎⴰⵣⵉⵖ',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // بطاقة الترحيب البصرية
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.teal.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    'ⴰⵣⵓⵍ !',
                    style: TextStyle(fontSize: 52, color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'ⵣ',
                    style: TextStyle(fontSize: 42, color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // شبكة البطاقات الرئيسية للأطفال
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.1,
                children: [
                  _buildMainCard(
                    title: 'ⴰⴳⵎⵎⴰⵢ',
                    icon: Icons.sort_by_alpha,
                    color: Colors.orange,
                  ),
                  _buildMainCard(
                    title: 'ⵜⵉⴳⵓⵔⵉⵡⵉⵏ',
                    icon: Icons.menu_book,
                    color: Colors.blue,
                  ),
                  _buildMainCard(
                    title: 'ⵓⵔⴰⵔⵏ',
                    icon: Icons.extension,
                    color: Colors.purple,
                  ),
                  _buildMainCard(
                    title: 'ⴰⵙⵓⵜⴳ',
                    icon: Icons.assessment,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMainCard({required String title, required IconData icon, required MaterialColor color}) {
    return Container(
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade400, width: 2.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 6, offset: const Offset(1, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 55, color: color.shade700),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔤 2. شاشة مسار الحروف (نظام الوحدات التدريجية)
class AgmmayPathScreen extends StatelessWidget {
  const AgmmayPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text('🔤 ⴰⴳⵎⵎⴰⵢ (مسار التعلم)'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildUnitSection(
            context,
            unitTitle: 'الوحدة 1 (مفتوحة)',
            letters: ['ⴰ', 'ⴱ', 'ⴳ'],
            isLocked: false,
          ),
          const SizedBox(height: 30),
          _buildUnitSection(
            context,
            unitTitle: 'الوحدة 2 (مقفلة 🔒)',
            letters: ['ⴷ', 'ⴼ', 'ⴽ'],
            isLocked: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSection(BuildContext context, {required String unitTitle, required List<String> letters, required bool isLocked}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          unitTitle,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isLocked ? Colors.grey : Colors.teal.shade800),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: letters.map((letter) {
            return GestureDetector(
              onTap: isLocked ? null : () {
                // فتح رحلة الحرف عند الضغط
                Navigator.push(context, MaterialPageRoute(builder: (context) => LetterJourneyScreen(letter: letter)));
              },
              child: Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey.shade300 : Colors.orange.shade300,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isLocked ? Colors.grey : Colors.orange.shade700, width: 3),
                  boxShadow: isLocked ? [] : [const BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 4))],
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(Icons.lock, size: 40, color: Colors.grey)
                      : Text(letter, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 🎯 3. شاشة رحلة الحرف (التدرج البيداغوجي الـ 5 خطوات)
class LetterJourneyScreen extends StatefulWidget {
  final String letter;
  const LetterJourneyScreen({super.key, required this.letter});

  @override
  State<LetterJourneyScreen> createState() => _LetterJourneyScreenState();
}

class _LetterJourneyScreenState extends State<LetterJourneyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextStep() {
    if (_currentPage < 4) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      // إنهاء الحرف بنجاح والعودة للمسار
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('تعلم الحرف: ${widget.letter}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / 5,
            backgroundColor: Colors.teal.shade200,
            color: Colors.orange,
            minHeight: 10,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // منع السحب اليدوي
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildIdentifyAndListenStep(),
          _buildObserveWritingStep(),
          _buildTraceStep(),
          _buildIndependentWritingStep(),
          _buildQuizStep(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: _nextStep,
          child: Text(
            _currentPage == 4 ? '🎉 إنهاء وحفظ النقطة' : 'التالي ➡️',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // الخطوة 1: التعرف والاستماع
  Widget _buildIdentifyAndListenStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.letter, style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: Colors.orange)),
        IconButton(
          iconSize: 60,
          color: Colors.teal,
          icon: const Icon(Icons.volume_up),
          onPressed: () {},
        ),
        const SizedBox(height: 30),
        const Icon(Icons.water_drop, size: 80, color: Colors.blue),
        const SizedBox(height: 10),
        const Text('ⴰⵎⴰⵏ', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.teal)),
        IconButton(
          iconSize: 40,
          color: Colors.orange,
          icon: const Icon(Icons.volume_up),
          onPressed: () {},
        ),
      ],
    );
  }

  // الخطوة 2: ألاحظ طريقة الكتابة
  Widget _buildObserveWritingStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('👀 ⵥⵕ ⵜⵉⵔⵔⴰ (ألاحظ)', style: TextStyle(fontSize: 28, color: Colors.grey)),
        const SizedBox(height: 20),
        Container(
          width: 200, height: 200,
          decoration: BoxDecoration(color: Colors.teal.shade50, border: Border.all(color: Colors.teal, width: 3)),
          child: Center(
            child: Text('${widget.letter} ✍️', style: const TextStyle(fontSize: 80, color: Colors.teal)),
          ),
        ),
        const SizedBox(height: 20),
        const Text('شاهد نقطة البداية واتجاه القلم', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  // الخطوة 3: أتتبع
  Widget _buildTraceStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('👆 ⴹⴼⵕ (أتتبع)', style: TextStyle(fontSize: 28, color: Colors.grey)),
        const SizedBox(height: 20),
        Container(
          width: 250, height: 250,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.orange, width: 4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.letter,
              style: TextStyle(fontSize: 120, color: Colors.grey.shade400, decorationStyle: TextDecorationStyle.dashed),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('مرر إصبعك فوق الحرف المنقط!', style: TextStyle(fontSize: 20, color: Colors.teal)),
      ],
    );
  }

  // الخطوة 4: أكتب بنفسي
  Widget _buildIndependentWritingStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('✍️ ⴰⵔⴰ (أكتب بنفسي)', style: TextStyle(fontSize: 28, color: Colors.grey)),
        const SizedBox(height: 20),
        Container(
          width: 250, height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.teal, width: 4),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.teal.shade100, blurRadius: 10)],
          ),
          child: const Center(
            child: Icon(Icons.draw, size: 50, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
        const Text('الآن اكتب الحرف بنفسك!', style: TextStyle(fontSize: 20, color: Colors.orange)),
      ],
    );
  }

  // الخطوة 5: التقييم المصغر
  Widget _buildQuizStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🎯 ⴰⵙⴰⴷⴰⵙ (أين الحرف؟)', style: TextStyle(fontSize: 28, color: Colors.grey)),
        const SizedBox(height: 30),
        Text('أين يوجد حرف ( ${widget.letter} ) ؟', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        _buildQuizButton('ⵜⴰⴷⴰⵔⵜ', false),
        _buildQuizButton('ⴰⵎⴰⵏ', true),
        _buildQuizButton('ⴼⵓⵙ', false),
      ],
    );
  }

  Widget _buildQuizButton(String word, bool isCorrect) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          side: const BorderSide(color: Colors.teal, width: 2),
        ),
        onPressed: () {
          if (isCorrect) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⭐ أحسنت! إجابة صحيحة'), backgroundColor: Colors.green));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔄 حاول مرة أخرى'), backgroundColor: Colors.red));
          }
        },
        child: Text(word, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
