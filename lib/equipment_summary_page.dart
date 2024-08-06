import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'classes/Equipment_counter.dart';
import 'design_features.dart';

class EquipSumPage extends StatefulWidget {
  const EquipSumPage({super.key});

  @override
  State<EquipSumPage> createState() => _EquipSumPageState();
}

class _EquipSumPageState extends State<EquipSumPage> {
  List<Equipment_summary> items = [];
  int? sortColumnIndex;
  bool isAscending = false;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEquipmentSummaries();
  }

  void _fetchEquipmentSummaries() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('equipment').get();
      final summaries = querySnapshot.docs.map((doc) {
        return Equipment_summary.fromDocument(doc.data(), doc.id);
      }).toList();
      setState(() {
        items = summaries;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching equipment summaries: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Hero(
            tag: "equipment state",
            child: Center(
                child: Text('מציבת ציוד', style: labelTextStyle))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))

          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: sortColumnIndex,
                sortAscending: isAscending,

                headingRowColor: MaterialStateColor.resolveWith(
                      (states) {
                    return appBarColor;
                  },
                ),
                border: TableBorder.all(width: 2.0, color: Colors.white),
                columns: [
                  DataColumn(label: Text("במחסן",style: userMenuTextStyle),onSort: sortTable),
                  DataColumn(label: Text("בחוץ",style: userMenuTextStyle),onSort: sortTable),
                  DataColumn(label: Text("סך הכל",style: userMenuTextStyle),onSort: sortTable),
                  DataColumn(label: Text("ציוד",style: userMenuTextStyle), onSort: sortTable),
                ],
                rows: items.asMap().entries.map((entry) {
                  Equipment_summary item = entry.value;
                  return DataRow(
                    onLongPress: () => _showAlertDialog(context, item),
                    cells: [
                      DataCell(Text(item.current_quantity.toString(),style: tableTextStyle)),
                      DataCell(Text((item.quantity_total - item.current_quantity).toString(),style: tableTextStyle)),
                      DataCell(Text(item.quantity_total.toString(),style: tableTextStyle)),
                      DataCell(Text(item.name,style: tableTextStyle)),
                    ],
                  );
                }).toList(),
                dividerThickness: 3,
              ),
            ),
        ],),
        )
    );
  }

  void _showAlertDialog(BuildContext context, Equipment_summary item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Row Tapped'),
          content: Text('You double-tapped on: ${item.name}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void sortTable(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
      if (columnIndex == 0) {
        items.sort((a, b) => (a.quantity_total - a.current_quantity).compareTo(b.quantity_total - b.current_quantity));
      } else if (columnIndex == 1) {
        items.sort((a, b) => a.current_quantity.compareTo(b.current_quantity));
      } else if (columnIndex == 2) {
        items.sort((a, b) => a.quantity_total.compareTo(b.quantity_total));
      } else if (columnIndex == 3) {
        items.sort((a, b) => a.name.compareTo(b.name));
      }
      if (!ascending) {
        items = items.reversed.toList();
      }
    });
  }
}
