import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance/app_theme.dart';
import 'package:personal_finance/blocs/income_expense/income_expense_bloc.dart';
import 'package:personal_finance/blocs/income_expense/income_expense_event.dart';
import 'package:personal_finance/models/income_expense_model.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AppThemes.greenFinanceTheme.dividerColor,
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTabSelected,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppThemes.greenFinanceTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Spending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),

        // Botón flotante en el centro
        Positioned(
          top: -30,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: FloatingActionButton(
            backgroundColor: AppThemes.greenFinanceTheme.primaryColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  final TextEditingController amountController =
                      TextEditingController();
                  final TextEditingController descriptionController =
                      TextEditingController();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                          ),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description (optional)',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _addTransaction(
                                  context,
                                  amountController.text,
                                  descriptionController.text,
                                  'income',
                                );
                              },
                              child: const Text('Add Income'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _addTransaction(
                                  context,
                                  amountController.text,
                                  descriptionController.text,
                                  'expense',
                                );
                              },
                              child: const Text('Add Expense'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _addTransaction(
    BuildContext context,
    String amount,
    String description,
    String type,
  ) {
    final parsedAmount = double.tryParse(amount);

    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final transaction = IncomeExpense(
      amount: parsedAmount.toInt(),
      description: description.isEmpty ? 'no description' : description,
      date: DateTime.now(),
      type: type,
    );

    context.read<IncomeExpenseBloc>().add(AddTransaction(transaction));

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction added successfully')),
    );
  }
}
