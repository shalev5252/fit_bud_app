import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/design_features.dart';
import 'package:untitled1/widgets/animated_toggle_switch.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _isSwitchedOn = false;
  bool addNewEquipment = false;
  String? _selectedValue;
  final TextEditingController _equipmentController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? errorMessage;
  List<String> _equipmentNames = [];

  @override
  void initState() {
    super.initState();
    _fetchEquipmentNames();
  }

  void _handleToggleSwitchChanged(bool newValue) {
    setState(() {
      _isSwitchedOn = newValue;
    });
  }

  void _fetchEquipmentNames() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('equipment').get();
      final names = querySnapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        _equipmentNames = names;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching equipment names: $e';
      });
    }
  }

  void _handleToggle(int index) {
    setState(() {
      _isSwitchedOn = index == 1;
    });
  }

  Future<void> _handleSubmit() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final equipmentName =
          addNewEquipment ? _equipmentController.text : _selectedValue;
      final quantityStr = _quantityController.text;
      if (equipmentName == null || equipmentName.isEmpty) {
        setState(() {
          errorMessage = 'שם הציוד לא יכול להיות ריק';
        });
        return;
      }
      final quantity = int.tryParse(quantityStr);
      if (quantity == null || quantity < 0) {
        setState(() {
          errorMessage = 'כמות לא תקינה';
        });
        return;
      }

      Map<String, dynamic> data = {
        "quantity": FieldValue.increment(_isSwitchedOn ? -quantity : quantity),
        "current_quantity":
            FieldValue.increment(_isSwitchedOn ? -quantity : quantity)
      };
      await firestore
          .collection("equipment")
          .doc(equipmentName)
          .set(data, SetOptions(merge: true));
      _quantityController.clear();
      // Refresh the equipment names list after adding new equipment
      if (addNewEquipment) {
        _fetchEquipmentNames();
        _equipmentController.clear();
        setState(() {
          addNewEquipment = false;
          _selectedValue = null;
        });
      }

      setState(() {
        errorMessage = null;
      });
      print('Operation successful');
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _equipmentController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Hero(
              tag: "add storage eq",
              child: Center(
                  child: Text('הוספת ציוד לאחסון', style: labelTextStyle))),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                        child: ToggleSwitch(
                            onChanged: _handleToggleSwitchChanged)),
                    // Text(_isSwitchedOn ? "הסרת ציוד" : "הוספת ציוד"),
                    const SizedBox(height: 30),
                    Container(
                        decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: DropdownMenu(
                          menuHeight: 300,
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          label: Text("בחר אפשרות", style: labelTextStyle),
                          textStyle: labelTextStyle,
                          dropdownMenuEntries:
                              _equipmentNames.map((String value) {
                                    return DropdownMenuEntry(
                                        style: MenuItemButton.styleFrom(
                                            backgroundColor: appBarColor,
                                            textStyle: labelTextStyle,
                                            foregroundColor: Colors.black),
                                        value: value,
                                        label: value);
                                  }).toList() +
                                  [
                                    DropdownMenuEntry(
                                        style: MenuItemButton.styleFrom(
                                            backgroundColor: appBarColor,
                                            textStyle: labelTextStyle,
                                            foregroundColor: Colors.black),
                                        value: 'Other',
                                        label: 'אחר')
                                  ],
                          onSelected: (value) {
                            setState(() {
                              _selectedValue = value;
                              addNewEquipment = value == 'Other';
                            });
                          },
                        )),
                    addNewEquipment ? SizedBox(height: 10) : SizedBox(),
                    if (addNewEquipment)
                      TextField(
                        style: inputTextStyle,
                        controller: _equipmentController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'הכנס שם ציוד',
                        ),
                      )
                    else if (_selectedValue != null)
                      Text('ציוד נבחר: $_selectedValue'),

                    const SizedBox(height: 10),
                    TextField(
                      style: inputTextStyle,
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'הכנס כמות',
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(appBarColor)),
                      onPressed: _handleSubmit,
                      child: Text('אישור',style: labelTextStyle),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
