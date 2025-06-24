import 'package:flutter/material.dart';
import 'package:personal_finance/widgets/balance_card.dart';
import 'package:personal_finance/widgets/transaction_list.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.appBarTheme.foregroundColor,
      appBar: AppBar(
        title: const Text('Wallet',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de Balance
            const BalanceCard(
              title: 'Available Balance',
              amount: '\$3,578',
              subtitle: 'See details',
            ),
            const SizedBox(height: 16),

            // Lista de transacciones recientes
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Expanded(
              child: TransactionList(),
            ),
          ],
        ),
      ),
    );
  }
}