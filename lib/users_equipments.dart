import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class LoanerEquipmentSummary {
  String loanerId;
  Map<String, int> loaned;
  LoanerEquipmentSummary(this.loanerId, this.loaned);
}

class UserEquipmentPage extends StatefulWidget {
  const UserEquipmentPage({super.key});

  @override
  State<UserEquipmentPage> createState() => _UserEquipmentPageState();
}

class _UserEquipmentPageState extends State<UserEquipmentPage> {
  List<LoanerEquipmentSummary> items = [];
  List<String> equipmentNames = [];
  bool _loading = true;
  bool _ascendingOrder = true; // State variable to track sorting order

  @override
  void initState() {
    super.initState();
    _fetchEquipmentNames().then((_) => _fetchLoanerData());
  }

  Future<void> _fetchEquipmentNames() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('equipment').get();
      List<String> names = querySnapshot.docs.map((doc) => doc.id).toList();

      // Sort equipment names lexicographically
      names.sort();

      setState(() {
        equipmentNames = names;
      });
    } catch (e) {
      print('Error fetching equipment names: $e');
    }
  }

  Future<void> _fetchLoanerData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('loaners').get();
      List<LoanerEquipmentSummary> summaries = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, int> loaned = {};
        if (data['equipment'] != null) {
          loaned = (data['equipment'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as int));
        }
        return LoanerEquipmentSummary("${data['first_name']} ${data['last_name']}\n${doc.id}", loaned);
      }).toList();

      // Sort loaner summaries lexicographically by loanerId
      _sortItems(summaries);

      setState(() {
        items = summaries;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching loaner data: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void _sortItems(List<LoanerEquipmentSummary> summaries) {
    if (_ascendingOrder) {
      summaries.sort((a, b) => a.loanerId.compareTo(b.loanerId));
    } else {
      summaries.sort((a, b) => b.loanerId.compareTo(a.loanerId));
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _ascendingOrder = !_ascendingOrder;
      _sortItems(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('החתמת ציוד'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : HorizontalDataTable(
        leftHandSideColumnWidth: MediaQuery.sizeOf(context).width * 0.2,
        rightHandSideColumnWidth: 150.0 * equipmentNames.length,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: items.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black38,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
        itemExtent: 55,
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> widgets = [
      GestureDetector(
        onLongPress: _toggleSortOrder,
        child: _getTitleItemWidget(
          'Name',
          100,
          icon: _ascendingOrder ? Icons.arrow_upward : Icons.arrow_downward,
        ),
      ),
    ];

    for (String name in equipmentNames) {
      widgets.add(_getTitleItemWidget(name, 150));
    }

    return widgets;
  }

  Widget _getTitleItemWidget(String label, double width, {IconData? icon}) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (icon != null) ...[
            const SizedBox(width: 5),
            Icon(icon, size: 16),
          ],
        ],
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Text(items[index].loanerId),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: equipmentNames.map((name) {
        int quantity = 0;

        if (items[index].loaned.containsKey(name)) {
          quantity = items[index].loaned[name]!;
        }

        return Container(
          width: 150,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text(quantity.toString()),
        );
      }).toList(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserEquipmentPage(),
  ));
}
