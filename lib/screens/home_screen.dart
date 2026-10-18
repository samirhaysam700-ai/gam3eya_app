import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/gam3eya.dart';
import '../services/widget_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Gam3eya> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Gam3eya>('gam3eyaBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جمعياتي'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Gam3eya> b, _) {
          if (b.isEmpty) {
            return const Center(child: Text('لا توجد جمعيات بعد'));
          }
          return ListView.builder(
            itemCount: b.length,
            itemBuilder: (_, i) {
              final g = b.getAt(i)!;
              final percent = g.totalAmount == 0
                  ? 0.0
                  : (g.paidAmount / g.totalAmount).clamp(0.0, 1.0);
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(g.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مدفوع: ${g.paidAmount} / ${g.totalAmount}'),
                      Text('متبقي: ${g.remaining}'),
                      LinearProgressIndicator(value: percent),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() async {
    final nameCtrl = TextEditingController();
    final totalCtrl = TextEditingController();
    final installCtrl = TextEditingController();
    final dayCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('جمعية جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الجمعية')),
              TextField(controller: totalCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ الإجمالي')),
              TextField(controller: installCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'قيمة القسط')),
              TextField(controller: dayCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'يوم القسط (1-28)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              final g = Gam3eya(
                name: nameCtrl.text,
                totalAmount: double.parse(totalCtrl.text),
                installmentValue: double.parse(installCtrl.text),
                installmentDay: int.parse(dayCtrl.text),
                startDate: DateTime.now(),
              );
              await box.add(g);
              await WidgetService.updateAllWidgets();
              await WidgetService.scheduleReminder(g);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
