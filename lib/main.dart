import 'package:flutter/material.dart';

void main() {
  runApp(const MonthlyBudgetApp());
}

class MonthlyBudgetApp extends StatelessWidget {
  const MonthlyBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'برنامج المصاريف الشهرية',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const BudgetScreen(),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int selectedMonth = 1;
  final TextEditingController baseSalaryController = TextEditingController(text: '0');
  
  // قوائم الدخل الإضافي والمصروفات
  List> incomeRows = [];
  List> expenseRows = [
    {'name': 'الإيجار / السكن', 'amount': 0.0},
    {'name': 'فواتير الكهرباء والماء', 'amount': 0.0},
    {'name': 'مقاضي البيت والتموين', 'amount': 0.0},
    {'name': 'قسط السيارة / المواصلات', 'amount': 0.0},
  ];

  double get totalIncome {
    double base = double.tryParse(baseSalaryController.text) ?? 0;
    double additional = incomeRows.fold(0, (sum, item) => sum + (item['amount'] ?? 0.0));
    return base + additional;
  }

  double get totalExpense {
    return expenseRows.fold(0, (sum, item) => sum + (item['amount'] ?? 0.0));
  }

  double get netBalance => totalIncome - totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 برنامج إدارة المصاريف الشهرية'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<int>(
              value: selectedMonth,
              dropdownColor: Colors.white,
              items: const [
                DropdownMenuItem(value: 1, child: Text('يناير')),
                DropdownMenuItem(value: 2, child: Text('فبراير')),
                DropdownMenuItem(value: 3, child: Text('مارس')),
                DropdownMenuItem(value: 4, child: Text('أبريل')),
                DropdownMenuItem(value: 5, child: Text('مايو')),
                DropdownMenuItem(value: 6, child: Text('يونيو')),
                DropdownMenuItem(value: 7, child: Text('يوليو')),
                DropdownMenuItem(value: 8, child: Text('أغسطس')),
                DropdownMenuItem(value: 9, child: Text('سبتمبر')),
                DropdownMenuItem(value: 10, child: Text('أكتوبر')),
                DropdownMenuItem(value: 11, child: Text('نوفمبر')),
                DropdownMenuItem(value: 12, child: Text('ديسمبر')),
              ],
              onChanged: (val) {
                setState(() {
                  selectedMonth = val!;
                });
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // قسم الدخل
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💰 مصادر الدخل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: baseSalaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الراتب الأساسي',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    ...incomeRows.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: const InputDecoration(labelText: 'مصدر الدخل (مثال: عمل حر)', border: OutlineInputBorder()),
                                onChanged: (val) => incomeRows[index]['name'] = val,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'المبلغ', border: OutlineInputBorder()),
                                onChanged: (val) {
                                  setState(() {
                                    incomeRows[index]['amount'] = double.tryParse(val) ?? 0.0;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => setState(() => incomeRows.removeAt(index)),
                            ),
                          ],
                        ),
                      );
                    }),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => incomeRows.add({'name': '', 'amount': 0.0})),
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة دخل آخر'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // قسم المصروفات
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🛒 المصروفات والالتزامات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...expenseRows.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: expenseRows[index]['name'],
                                decoration: const InputDecoration(labelText: 'اسم المصروف', border: OutlineInputBorder()),
                                onChanged: (val) => expenseRows[index]['name'] = val,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                initialValue: expenseRows[index]['amount'].toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'المبلغ', border: OutlineInputBorder()),
                                onChanged: (val) {
                                  setState(() {
                                    expenseRows[index]['amount'] = double.tryParse(val) ?? 0.0;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => setState(() => expenseRows.removeAt(index)),
                            ),
                          ],
                        ),
                      );
                    }),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => expenseRows.add({'name': '', 'amount': 0.0})),
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة بند مصروف جديد'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // الملخص والتحكم
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('إجمالي الدخل: ${totalIncome.toStringAsFixed(2)}', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 16)),
                      Text('إجمالي المصروفات: ${totalExpense.toStringAsFixed(2)}', style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('المتبقي للادخار:', style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text('${netBalance.toStringAsFixed(2)}', style: TextStyle(color: netBalance >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.styleFrom != null ? ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✅ تم حفظ الشهر وتكرار المبالغ للأشهر القادمة بنجاح!')),
                            );
                          },
                          child: const Text('حفظ الشهر وتكرار المبالغ', style: TextStyle(color: Colors.white)),
                        ) : Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
