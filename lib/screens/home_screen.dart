import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/new_transaction.dart';
import '../widgets/user_transactions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _userTransactions = [];

  void _showAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NewTransaction(_addNewTransaction),
    );
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    setState(() {
      _userTransactions.add(
        Transaction(
          id: DateTime.now().toString(),
          title: title,
          amount: amount,
          date: date,
        ),
      );
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  PreferredSizeWidget _adaptiveAppBar() => Platform.isIOS
      ? CupertinoNavigationBar(
          middle: Text(
            'Personal Expenses',
            style: TextStyle(
                fontSize: 20 * MediaQuery.of(context).textScaleFactor),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () {
                  _showAddNewTransaction(context);
                },
              )
            ],
          ),
        )
      : AppBar(
          title: Text(
            'Personal Expenses',
            style: TextStyle(
                fontSize: 20 * MediaQuery.of(context).textScaleFactor),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddNewTransaction(context);
                }),
          ],
        );

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = _adaptiveAppBar();
    final body = UserTransactions(
      appBar.preferredSize.height + MediaQuery.of(context).padding.top,
      _userTransactions,
      _deleteTransaction,
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showAddNewTransaction(context);
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
