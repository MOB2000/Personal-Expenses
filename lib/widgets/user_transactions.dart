import 'package:flutter/material.dart';

import './chart.dart';
import './transaction_list.dart';
import '../models/transaction.dart';

class UserTransactions extends StatefulWidget {
  final List<Transaction> _userTransactions;
  final Function deleteTransaction;
  final double appBarHeight;

  UserTransactions(
    this.appBarHeight,
    this._userTransactions,
    this.deleteTransaction,
  );

  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  List<Transaction> get _recentTransactions {
    return widget._userTransactions
        .where(
          (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))),
        )
        .toList();
  }

  bool _showChart = true;

  List<Widget> _portraitContent(MediaQueryData mediaQuery, Widget txList) {
    return [
      Container(
        height: (mediaQuery.size.height - widget.appBarHeight) * 0.3,
        child: Chart(_recentTransactions),
      ),
      txList,
    ];
  }

  List<Widget> _landscapeContent(MediaQueryData mediaQuery, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (newValue) {
              setState(() {
                _showChart = newValue;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height - widget.appBarHeight) * 0.7,
              child: Chart(_recentTransactions),
            )
          : txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final txList = Container(
      height: (mediaQuery.size.height - widget.appBarHeight) * 0.7,
      child: TransactionList(
        widget._userTransactions,
        widget.deleteTransaction,
      ),
    );
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: isLandscape
              ? _landscapeContent(mediaQuery, txList)
              : _portraitContent(mediaQuery, txList),
        ),
      ),
    );
  }
}
