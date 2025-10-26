// import 'package:flutter/material.dart';
// import '../models/expense_model.dart';
// class AddExpenseScreen extends StatefulWidget {
//   const AddExpenseScreen({super.key});

//   @override
//   State<AddExpenseScreen> createState() => _AddExpenseState();
// }

// class _AddExpenseState extends State<AddExpenseScreen> {
//   final _titleController = TextEditingController();
//   final _amountController = TextEditingController();
//   DateTime? _selectedDate;
//   final _formKey = GlobalKey<FormState>();

//   void showDatepicker() async {
//     final pickeddate = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
//     );
//     setState(() {
//       _selectedDate = pickeddate;
//     });
//   }

//   void submitForm() {
//     if ((_formKey.currentState?.validate() ?? false) && _selectedDate != null) {
//       final title = _titleController.text;
//       final amount = double.parse(_amountController.text);
//       final newExpense = ExpenseModel(title:title,amount: amount, date:_selectedDate);
//       Navigator.pop(context, newExpense);
//       setState(() {
//         _selectedDate = null;
//       });
//     }
//   }

//   void reset() {
//     _formKey.currentState?.reset();
//     _titleController.clear();
//     _amountController.clear();
//     setState(() {
//       _selectedDate = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return (Scaffold(
//       appBar: AppBar(title: Text("Add Expense")),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _titleController,
//               decoration: InputDecoration(label: Text("Title")),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Title is Required";
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _amountController,
//               decoration: InputDecoration(label: Text("Amount")),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Amount is Required";
//                 }
//                 if (double.tryParse(value) == null) {
//                   return "Enter the number";
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 6),
//             Text(
//               _selectedDate == null
//                   ? "No Date Selected"
//                   : "Date : ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
//             ),
//             SizedBox(height: 6),
//             TextButton(
//               onPressed: () => showDatepicker(),
//               child: Text("Select Date"),
//             ),
//             SizedBox(height: 6),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => submitForm(),
//                   child: Text("Add Expense"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigoAccent,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 5.0),
//                 ElevatedButton(
//                   onPressed: () => reset(),
//                   child: Text("Reset"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }


import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  void showDatepicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: _selectedDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.indigoAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void submitForm() {
    if ((_formKey.currentState?.validate() ?? false) && _selectedDate != null) {
      final title = _titleController.text.trim();
      final amount = double.parse(_amountController.text);
      final newExpense =
          ExpenseModel(title: title, amount: amount, date: _selectedDate);
      Navigator.pop(context, newExpense);
      reset();
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a date!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void reset() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _amountController.clear();
    setState(() => _selectedDate = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text(
          "Add Expense 💸",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER CARD
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.indigoAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigoAccent.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Track Your Spending Wisely",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Add a New Expense",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // TITLE INPUT
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "e.g. Grocery, Transport, Rent",
                    prefixIcon: const Icon(Icons.title_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Title is required" : null,
                ),
                const SizedBox(height: 20),

                // AMOUNT INPUT
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "e.g. 250.00",
                    prefixIcon: const Icon(Icons.currency_rupee_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Amount is required";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // DATE PICKER SECTION
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? "No Date Selected"
                            : "📅  ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey.shade600
                              : Colors.indigoAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: showDatepicker,
                        icon: const Icon(Icons.calendar_month),
                        label: const Text("Pick Date"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: submitForm,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Add Expense"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: reset,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
