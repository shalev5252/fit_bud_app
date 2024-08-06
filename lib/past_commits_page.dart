import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'classes/Loans.dart';

class PastCommitPage extends StatefulWidget {
  const PastCommitPage({super.key});

  @override
  State<PastCommitPage> createState() => _PastCommitPageState();
}

class _PastCommitPageState extends State<PastCommitPage> {
  List<Loan> loans = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndFetchLoans();
  }
  Future<void> _initializeFirebaseAndFetchLoans() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized');
      List<Loan> fetchedLoans = await getLast50Loans();
      setState(() {
        loans = fetchedLoans;
        _loading = false;
      });
      print('Loans fetched: ${loans.length}');
    } catch (e) {
      print('Error initializing Firebase or fetching loans: $e');
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Last 50 Loans')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Date: ${loans[index].date}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loaner: ${loans[index].loanerName} (${loans[index].loanerId})'),
                Text('Logistics: ${loans[index].logistics}'),
                Text('Products: ${loans[index].products.toString()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}