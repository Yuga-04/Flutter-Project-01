// import 'package:expense_tracker/models/expense_model.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<ExpenseModel> get expenses => expenseBox.values.toList();

//   final expenseBox = Hive.box<ExpenseModel>("expenses");

//   final double totalBudget = 5000;
//   double get totalExpense =>
//       expenses.fold(0.0, (sum, item) => sum + item.amount);
//   double get balance => totalBudget - totalExpense;

//   confirmDelete(index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Delete Expense"),
//         content: Text("Are you sure want to delete"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final expenseBox = Hive.box<ExpenseModel>("expenses");
//               await expenseBox.deleteAt(index);
//               Navigator.pop(context);
//               setState(() {
                
//               });
//             },
//             child: Text("Delete"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final newExpense =
//               await Navigator.pushNamed(context, "/add-expense")
//                   as ExpenseModel;
//           setState(() {
//             // expenses.add(newExpense);
//             expenseBox.add(newExpense);
//           });
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.indigoAccent,
//         foregroundColor: Colors.white,
//       ),
//       appBar: AppBar(title: Text("Expense Tracker")),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text.rich(
//                   TextSpan(
//                     text: "Total Expenses: ",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     children: [
//                       TextSpan(
//                         text: totalExpense.toStringAsFixed(2),
//                         style: TextStyle(fontSize: 14, color: Colors.red),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: "Balance : ",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     children: [
//                       TextSpan(
//                         text: balance.toStringAsFixed(2),
//                         style: TextStyle(fontSize: 14, color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: expenses.length,
//               itemBuilder: (context, index) {
//                 final expense = expenses[index];
//                 return ExpenseCard(
//                   title: expense.title,
//                   amount: expense.amount,
//                   date: expense.date,
//                   onDelete: ()=>confirmDelete(index),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ExpenseCard extends StatelessWidget {
//   final String title;
//   final DateTime? date;
//   final double amount;
//   final VoidCallback onDelete;

//   const ExpenseCard({
//     required this.title,
//     required this.date,
//     required this.amount,
//     required this.onDelete,
//     super.key,
//   });

//   String get formattedDate {
//     return date == null
//         ? "No Date"
//         : DateFormat("MMM d, y").format(date!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       // color: Colors.grey[200],
//       margin: EdgeInsets.all(20.0),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   title.length > 12
//                       ? '${title.substring(0, 10)}...'
//                       : title,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 6),
//                 Text(
//                   formattedDate,
//                   style: TextStyle(fontSize: 16, color: Colors.red[300]),
//                 ),
//               ],
//             ),
//             Container(
//               child: Text(
//                 "₹ " + amount.toStringAsFixed(2),
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue),
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             ),
//             Container(
//               padding: EdgeInsetsDirectional.only(start: 8),
//               child: IconButton(
//                 onPressed: onDelete,
//                 icon: Icon(Icons.delete, color: Colors.red),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:ExpenseTracker/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final expenseBox = Hive.box<ExpenseModel>("expenses");

  List<ExpenseModel> get expenses => expenseBox.values.toList();

  double totalBudgetValue = 5000; // editable total budget
  double get totalBudget => totalBudgetValue;

  double get totalExpense =>
      expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get balance => totalBudget - totalExpense;

  double get progress => (totalExpense / totalBudget).clamp(0.0, 1.0);

  // --- DELETE INDIVIDUAL EXPENSE ---
  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Expense"),
        content: const Text("Are you sure want to delete this expense?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await expenseBox.deleteAt(index);
              Navigator.pop(context);
              setState(() {});
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text("Delete"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- EDIT TOTAL BUDGET ---
  void editBudgetDialog() {
    final _budgetController =
        TextEditingController(text: totalBudget.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Total Budget"),
        content: TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Enter new total budget",
            prefixIcon: Icon(Icons.currency_rupee_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newBudget = double.tryParse(_budgetController.text);
              if (newBudget != null && newBudget > 0) {
                setState(() {
                  totalBudgetValue = newBudget;
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a valid number"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // --- RESET ALL EXPENSES + BUDGET ---
  void resetAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Reset All Data"),
        content: const Text(
            "This will delete all expenses and reset the total budget. Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await expenseBox.clear();
              setState(() {
                totalBudgetValue = 5000; // reset default budget
              });
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text("Reset All"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newExpense =
              await Navigator.pushNamed(context, "/add-expense") as ExpenseModel?;
          if (newExpense != null) {
            setState(() {
              expenseBox.add(newExpense);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Expense"),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      appBar: AppBar(
        title: const Text(
          "Expense Tracker 💰",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // HEADER CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigoAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with edit and reset icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Monthly Overview",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: editBudgetDialog,
                            icon: const Icon(Icons.edit, color: Colors.white),
                            tooltip: "Edit Total Budget",
                          ),
                          IconButton(
                            onPressed: resetAllDialog,
                            icon: const Icon(Icons.delete_forever,
                                color: Colors.white),
                            tooltip: "Reset Everything",
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${totalExpense.toStringAsFixed(2)} / ₹${totalBudget.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 0.8 ? Colors.redAccent : Colors.greenAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Balance: ₹${balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // EXPENSE LIST
            Expanded(
              child: expenses.isEmpty
                  ? const Center(
                      child: Text(
                        "No expenses added yet 💸",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: ExpenseCard(
                            title: expense.title,
                            amount: expense.amount,
                            date: expense.date,
                            onDelete: () => confirmDelete(index),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String title;
  final DateTime? date;
  final double amount;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.onDelete,
  });

  String get formattedDate {
    return date == null ? "No Date" : DateFormat("MMM d, y").format(date!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TITLE + DATE
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.length > 15 ? '${title.substring(0, 13)}...' : title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            // AMOUNT + DELETE
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "₹${amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: "Delete Expense",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
