
import 'package:flutter/material.dart';

void main() => runApp(const RibhniApp());

class RibhniApp extends StatelessWidget {
  const RibhniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ربحني',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087A55),
          primary: const Color(0xFF087A55),
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int points = 0;
  int selectedIndex = 0;
  bool dailyClaimed = false;
  final List<String> history = [];

  void addPoints(int amount, String reason) {
    setState(() {
      points += amount;
      history.insert(0, '$reason: +$amount نقطة');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('أُضيفت $amount نقطة إلى رصيدك التجريبي')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeContent(),
      _tasksContent(),
      _walletContent(),
      _historyContent(),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF087A55),
          foregroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.stars_rounded),
              SizedBox(width: 8),
              Text('ربحني', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'التنبيهات',
              onPressed: () => _showInfo('التنبيهات', 'ستظهر هنا تنبيهات المكافآت وطلبات السحب.'),
              icon: const Icon(Icons.notifications_none),
            )
          ],
        ),
        body: SafeArea(child: pages[selectedIndex]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (i) => setState(() => selectedIndex = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.task_alt), label: 'المهام'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'المحفظة'),
            NavigationDestination(icon: Icon(Icons.receipt_long), label: 'السجل'),
          ],
        ),
      ),
    );
  }

  Widget _homeContent() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF087A55), Color(0xFF13A477)]),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('رصيدك الحالي', style: TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('$points', style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)),
            const Padding(padding: EdgeInsets.only(bottom: 7, right: 8), child: Text('نقطة', style: TextStyle(color: Colors.white))),
          ]),
          const SizedBox(height: 6),
          const Text('الأوقية الموريتانية • قيمة التحويل تحددها الإدارة لاحقاً', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 18),
      const Text('مرحباً بك في ربحني 👋', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('اجمع النقاط من المهام المؤهلة واستبدلها بالمكافآت عند توفرها.', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 18),
      _featureCard(
        icon: Icons.calendar_month,
        title: 'مكافأة الدخول اليومي',
        subtitle: dailyClaimed ? 'استلمت مكافأة اليوم' : 'احصل على 10 نقاط تجريبية',
        buttonText: dailyClaimed ? 'تم الاستلام' : 'استلام المكافأة',
        enabled: !dailyClaimed,
        onTap: () {
          if (!dailyClaimed) {
            setState(() => dailyClaimed = true);
            addPoints(10, 'مكافأة الدخول اليومي');
          }
        },
      ),
      const SizedBox(height: 12),
      _featureCard(
        icon: Icons.play_circle_outline,
        title: 'إعلانات المكافآت',
        subtitle: 'سيتم تفعيل الإعلانات بعد ربط حساب AdMob والموافقة على التطبيق',
        buttonText: 'قريباً',
        enabled: false,
        onTap: () {},
      ),
      const SizedBox(height: 12),
      _featureCard(
        icon: Icons.assignment_outlined,
        title: 'المهام',
        subtitle: 'اكتشف المهام المتاحة واجمع النقاط',
        buttonText: 'عرض المهام',
        onTap: () => setState(() => selectedIndex = 1),
      ),
      const SizedBox(height: 18),
      const _Notice(),
    ],
  );

  Widget _tasksContent() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('المهام المتاحة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('هذه مهام توضيحية في النسخة التجريبية. ستُربط المهام الحقيقية بالخادم لاحقاً.', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 16),
      _taskTile(Icons.person_add_alt, 'أكمل ملفك الشخصي', 'مكافأة تجريبية لمرة واحدة', 5),
      _taskTile(Icons.lightbulb_outline, 'تعرّف على طريقة الاستخدام', 'اقرأ إرشادات التطبيق', 5),
      _taskTile(Icons.share_outlined, 'دعوة صديق', 'تُفعّل بعد إضافة نظام إحالة موثوق', 0, locked: true),
    ],
  );

  Widget _taskTile(IconData icon, String title, String subtitle, int reward, {bool locked = false}) =>
    Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFFE2F2EB), child: Icon(icon, color: const Color(0xFF087A55))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: locked
          ? const Chip(label: Text('قريباً'))
          : TextButton(onPressed: () => addPoints(reward, title), child: Text('+$reward نقطة')),
      ),
    );

  Widget _walletContent() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('المحفظة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      Card(child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('رصيد النقاط', style: TextStyle(color: Colors.black54)),
          Text('$points نقطة', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF087A55))),
          const Divider(height: 28),
          const Row(children: [Icon(Icons.account_balance, color: Color(0xFF087A55)), SizedBox(width: 8), Text('وسيلة الدفع المختارة: بنكيلي')]),
          const SizedBox(height: 12),
          const Text('السحب غير مفعّل في هذه النسخة. يجب ربط واجهة دفع معتمدة والتحقق من هوية الطلبات قبل إرسال أي أموال.', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: () => _showInfo('طلبات السحب', 'سيتم تفعيل طلب السحب إلى بنكيلي بعد إعداد الربط الرسمي، وتحديد الحد الأدنى وسعر تحويل النقاط. لا توجد تحويلات مالية حقيقية في النسخة التجريبية.'),
            child: const Text('طلب سحب (قريباً)'),
          )),
        ]),
      )),
    ],
  );

  Widget _historyContent() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('سجل النقاط', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      if (history.isEmpty)
        const Center(child: Padding(padding: EdgeInsets.all(30), child: Text('لا توجد عمليات بعد')))
      else
        ...history.map((item) => Card(child: ListTile(leading: const Icon(Icons.add_circle, color: Color(0xFF087A55)), title: Text(item)))),
    ],
  );

  Widget _featureCard({required IconData icon, required String title, required String subtitle, required String buttonText, required VoidCallback onTap, bool enabled = true}) =>
    Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          CircleAvatar(radius: 25, backgroundColor: const Color(0xFFE2F2EB), child: Icon(icon, color: const Color(0xFF087A55))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ])),
          const SizedBox(width: 6),
          FilledButton.tonal(onPressed: enabled ? onTap : null, child: Text(buttonText)),
        ]),
      ),
    );

  void _showInfo(String title, String message) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
    ));
  }
}

class _Notice extends StatelessWidget {
  const _Notice();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFFFFF4D8), borderRadius: BorderRadius.circular(12)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.info_outline, color: Color(0xFF986500)),
      SizedBox(width: 8),
      Expanded(child: Text('نسخة أولية تجريبية: النقاط المعروضة محلية وليست أموالاً حقيقية. لا يوجد دفع أو إعلان فعلي قبل إعداد الخادم وربط مزودي الخدمة.', style: TextStyle(fontSize: 12))),
    ]),
  );
}
