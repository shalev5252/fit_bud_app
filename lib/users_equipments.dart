import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'classes/Equipment_counter.dart';

class EquipmentSummary {
  String name;
  int quantityInStorage;
  int quantityInUse;

  EquipmentSummary(this.name, this.quantityInStorage, this.quantityInUse);
}

class UserEquipmentPage extends StatefulWidget {
  const UserEquipmentPage({super.key});

  @override
  State<UserEquipmentPage> createState() => _UserEquipmentPageState();
}

class _UserEquipmentPageState extends State<UserEquipmentPage> {
  List<Equipment_summary> items = [
    Equipment_summary('Item 1', 100, 50),
    Equipment_summary('Item 2',30 , 12),
    Equipment_summary('Item 3', 90 , 67),
    Equipment_summary('Item 1', 100, 50),
    Equipment_summary('Item 2',30 , 12),
    Equipment_summary('Item 3', 90 , 67),
    Equipment_summary('Item 1', 100, 50),
    Equipment_summary('Item 2',30 , 12),
    Equipment_summary('Item 3', 90 , 67),

  ];

  List<DataColumn> list_column = [
    DataColumn(label: Text('name')),
    DataColumn(label: Text('storage quantity')),
    DataColumn(label: Text('loaned quantity')),
    DataColumn(label: Text('name')),
    DataColumn(label: Text('storage quantity')),
    DataColumn(label: Text('loaned quantity')),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('החתמת ציוד'),
      ),
      body:
      HorizontalDataTable(
        leftHandSideColumnWidth: MediaQuery.sizeOf(context).width * 0.2,
        rightHandSideColumnWidth: 200.0 * (list_column.length-1),
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
    return [
      _getTitleItemWidget('Name', 100),
      _getTitleItemWidget('quantity is storage', 200),
      _getTitleItemWidget('quantity in use', 200),
      _getTitleItemWidget('quantity in use', 200),
      _getTitleItemWidget('quantity in use', 200),
      _getTitleItemWidget('quantity in use', 200),

    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Text(items[index].name),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text(items[index].quantity_in_storage.toString()),
        ),

        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text(items[index].quantity_in_use.toString()),
        ),

        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text("hello"),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text("hello"),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text("hello"),
        ),

      ],
    );
  }

}
