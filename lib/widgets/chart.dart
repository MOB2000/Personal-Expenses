import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (final transaction in recentTransactions) {
        final txDate = transaction.date;
        if (txDate.day == weekDay.day &&
            txDate.month == weekDay.month &&
            txDate.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending =>
      groupedTransactionsValues.fold(0.0, (sum, item) => sum + item['amount']);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ...groupedTransactionsValues
                .map(
                  (tx) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      tx['day'],
                      tx['amount'],
                      totalSpending == 0.0
                          ? 0.0
                          : (tx['amount'] as double) / totalSpending,
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
