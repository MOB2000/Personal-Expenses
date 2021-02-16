import 'package:flutter/material.dart';

import './transaction_card.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function deleteTx;

  TransactionList(this._userTransactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return _userTransactions.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) => TransactionCard(
              key: ValueKey(_userTransactions[index].id),
              transaction: _userTransactions[index],
              deleteTx: deleteTx,
            ),
            itemCount: _userTransactions.length,
          )
        : LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * .6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
  }
}
