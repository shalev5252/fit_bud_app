import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'classes/Equipment_counter.dart';

class EquipSumPage extends StatefulWidget {
  const EquipSumPage({super.key});

  @override
  State<EquipSumPage> createState() => _EquipSumPageState();
}

class _EquipSumPageState extends State<EquipSumPage> {
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
    DataColumn(label: Text('quantity left in storage')),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('מעקב ציוד'),
      ),
      body:
      HorizontalDataTable(
        leftHandSideColumnWidth: MediaQuery.sizeOf(context).width * 0.2,
        rightHandSideColumnWidth: (MediaQuery.sizeOf(context).width - 100),
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
    double width1 = (MediaQuery.sizeOf(context).width - 100)/3;
    return [
      _getTitleItemWidget('Name', 100),
      _getTitleItemWidget('quantity is storage', width1),
      _getTitleItemWidget('quantity in use', width1),
      _getTitleItemWidget('quantity left', width1),

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
    double width1 = (MediaQuery.sizeOf(context).width - 100)/3;

    return Row(
      children: <Widget>[
        Container(
          width: width1,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text(items[index].quantity_in_storage.toString()),
        ),

        Container(
          width: width1,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text(items[index].quantity_in_use.toString()),
        ),

        Container(
          width: width1,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text((items[index].quantity_in_storage - items[index].quantity_in_use).toString()),
        ),
      ],
    );
  }

}
