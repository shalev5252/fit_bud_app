import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'classes/Equipment_counter.dart';
import 'classes/Loaner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'design_features.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  bool _isSwitchedOn = false;

  String? _selectedLoanerId;
  List<Loaner> _loaners = [];
  bool _loading = true;

  late TextEditingController first_name_controller;
  late TextEditingController last_name_controller;
  late TextEditingController phone_number_controller;
  late TextEditingController id_controller;

  String? equipment_chosen;
  String? logistic_chosen;

  late TextEditingController equipment_quantity_controller;
  String? errorMessage;

  String _name = '';
  bool add_loaner = false;
  List<Equipment_counter> items = [];

  List<String> _equipmentNames = [];
  List<String> _logisticNames = [];
  final firestore = FirebaseFirestore.instance;
  late Loaner? person;

  void _fetchEquipmentNames() async {
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
  void _fetchLogisticsNames() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('logistics').get();
      final names = querySnapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        _logisticNames = names;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching logistic fellows names: $e';
      });
    }
  }
  void _fetchLoaners() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('loaners').get();
      List<Loaner> loaners = querySnapshot.docs.map((doc) {
        return Loaner.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      setState(() {
        _loaners = loaners;
        _loading = false;
      });
    } catch (e) {
      ('Error fetching loaners: $e');
      setState(() {
        _loading = false;
      });
    }
  }
  void _handleToggle(int index) {
    setState(() {
      _isSwitchedOn = index == 1;
    });
  }

  @override
  void initState() {
    super.initState();
    first_name_controller = TextEditingController();
    last_name_controller = TextEditingController();
    phone_number_controller = TextEditingController();
    id_controller = TextEditingController();
    equipment_quantity_controller = TextEditingController();
    _fetchLoaners();
    _fetchEquipmentNames();
    _fetchLogisticsNames();
  }

  @override
  void dispose() {
    first_name_controller.dispose();
    last_name_controller.dispose();
    phone_number_controller.dispose();
    id_controller.dispose();
    equipment_quantity_controller.dispose();
    super.dispose();
  }

  void _editItem(int index) {
    setState(() {
      equipment_quantity_controller =
          TextEditingController(text: items[index].quantity.toString());
    });
    openEditDialog(items[index], index);
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Hero(
                  tag: "loan equipment",
                  child: Center(
                      child: Text('החתמה/זיכוי', style: labelTextStyle))),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
        body: Directionality(textDirection: ui.TextDirection.rtl
            , child: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
    child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: DropdownMenu(
                          menuHeight: 300,
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          label: Text('החייל החותם', style: userMenuTextStyle),
                          textStyle: userMenuTextStyle,
                          dropdownMenuEntries: [
                            ..._loaners.map((loaner) {
                              return DropdownMenuEntry(
                                style: MenuItemButton.styleFrom(
                                    backgroundColor: appBarColor,
                                    textStyle: userMenuTextStyle,
                                    foregroundColor: Colors.black),
                                value: loaner.id,
                                label:
                                    '${loaner.get_id()} ${loaner.first_name ?? ''} ${loaner.last_name ?? ''}',
                              );
                            }).toList(),
                            DropdownMenuEntry(
                              style: MenuItemButton.styleFrom(
                                  backgroundColor: appBarColor,
                                  textStyle: userMenuTextStyle,
                                  foregroundColor: Colors.black),
                              value: 'add_new',
                              label: 'Add New Loaner',
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'add_new') {
                              setState(() {
                                add_loaner = true;
                              });
                            } else {
                              setState(() {
                                _selectedLoanerId = value;
                                add_loaner = false;
                                _name = value!;
                              });
                            }
                          },
                        )),
                    _selectedLoanerId != null ? Text(_selectedLoanerId!,style: TextStyle(color: Colors.white),) : SizedBox(),

                    if (add_loaner) ...[
                      SizedBox(height: 10),
                      Container(
                        height: 300, width: MediaQuery.sizeOf(context).width * 0.7
                          ,child: SingleChildScrollView( child:Column(
                        children: [
                          Container (
                              padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius: BorderRadius.circular(10)),
                              child: TextField(
                            controller: first_name_controller,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: 'שם פרטי'),
                            style: inputTextStyleUserdata,
                          )),
                          const SizedBox(height: 10),
                        Container (
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: appBarColor,
                              borderRadius: BorderRadius.circular(10)), child:
                          TextField(
                            controller: last_name_controller,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: 'שם משפחה'),
                            style: inputTextStyleUserdata,
                          )),
                          const SizedBox(height: 10),
                        Container (
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: appBarColor,
                              borderRadius: BorderRadius.circular(10)), child:
                          TextField(
                            controller: id_controller,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: 'מספר אישי'),
                            style: inputTextStyleUserdata,

                          )),
                          const SizedBox(height: 10),
                        Container (
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: appBarColor,
                              borderRadius: BorderRadius.circular(10)), child:
                          TextField(
                            controller: phone_number_controller,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                color: const Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                                hintText: 'מספר טלפון'),
                            style: inputTextStyleUserdata,
                          )),
                          const SizedBox(height: 10),
                        ],
                      ),),)],
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(appBarColor)),
                        onPressed: () {
                          openAddDialog();
                        },
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.35,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]!)),
                                ),
                                child: ListTile(
                                  textColor: item.switch_on
                                      ? Colors.red
                                      : Colors.green,
                                  title: Row(
                                    children: [
                                      Expanded(child: Text(item.name)),
                                      Expanded(
                                          child:
                                              Text(item.quantity.toString())),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _editItem(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _deleteItem(index),
                                      ),
                                    ],
                                  ),
                                ));
                          }),
                    ),


                    Container(
              decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: BorderRadius.circular(10)),
              padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child:
                    DropdownMenu(
                      menuHeight: 300,
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      label: Text("חייל הימח", style: userMenuTextStyle),
                      textStyle: userMenuTextStyle,
                      dropdownMenuEntries: _logisticNames.map((String value) {
                        return DropdownMenuEntry(
                            style: MenuItemButton.styleFrom(
                                backgroundColor: appBarColor,
                                textStyle: userMenuTextStyle,
                                foregroundColor: Colors.black),value: value, label: value);
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          logistic_chosen = value;
                        });
                      },
                    )),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(appBarColor)),
                      onPressed: () async {
                        try {
                          await setNewLoaner();
                          if (person == null) {
                            setState(() {
                              errorMessage = 'No loaner selected';
                            });
                            return;
                          }

                          String dateFormat = DateFormat('dd-MM-yyyy-H:m:s')
                              .format(DateTime.now())
                              .toString();
                          Map<String, int> itemMap = {
                            for (var item in items)
                              item.name: item.switch_on
                                  ? -item.quantity
                                  : item.quantity
                          };
                          await firestore
                              .collection('loans')
                              .doc(dateFormat)
                              .set({
                            'loaner': person!.get_id(),
                            'logistic': logistic_chosen,
                            'items': itemMap,
                            'created_at': FieldValue.serverTimestamp(),
                          });
                          updateLoanerEquipment(person!, items);
                          updateEquipment(person!, items);
                        } catch (e) {
                          setState(() {
                            errorMessage = 'Error publishing changes: $e';
                          });
                        }
                      },
                        child: Text('אישור',style: labelTextStyle),
                    ),
                  ],
                ),
        ))));
  }

  void openEditDialog(Equipment_counter item, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              toggle_switch(),
              SizedBox(height: 10),
              DropdownMenu(
                label: Text("סוג הציוד"),
                dropdownMenuEntries: _equipmentNames.map((String value) {
                  return DropdownMenuEntry(value: value, label: value);
                }).toList(),
                onSelected: (value) {
                  setState(() {
                    equipment_chosen = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'quantity', hintText: item.quantity.toString()),
                controller: equipment_quantity_controller,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  int.parse(equipment_quantity_controller.text);
                  if (equipment_chosen == null) {
                    throw 'No Equipment Chosen';
                  }
                  setState(() {
                    items[index] = Equipment_counter(
                        equipment_chosen!,
                        int.parse(equipment_quantity_controller.text),
                        _isSwitchedOn);
                  });
                  Navigator.of(context).pop();
                  if (int.parse(equipment_quantity_controller.text) == 0) {
                    _deleteItem(index);
                  }
                } catch (e) {
                  if (equipment_chosen == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No Equipment Chosen')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Quantity is not a Numerical Value: ${equipment_quantity_controller.text}')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Future<String?> openDialog() {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text("Name"),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 DropdownMenu(
  //                   label: Text('Select Loaner'),
  //                   dropdownMenuEntries: [
  //                     ..._loaners.map((loaner) {
  //                       return DropdownMenuEntry(
  //                         value: loaner.id,
  //                         label:
  //                             '${loaner.get_id()} : ${loaner.first_name ?? ''} ${loaner.last_name ?? ''}',
  //                       );
  //                     }).toList(),
  //                     DropdownMenuEntry(
  //                       value: 'add_new',
  //                       label: 'Add New Loaner',
  //                     ),
  //                   ],
  //                   onSelected: (value) {
  //                     if (value == 'add_new') {
  //                       print("value is add_new");
  //                       setState(() {
  //                         add_loaner = true;
  //                       });
  //                     } else {
  //                       print("loaner id is $value");
  //                       setState(() {
  //                         _selectedLoanerId = value;
  //                         add_loaner = false;
  //                       });
  //                     }
  //                   },
  //                 ),
  //                 if (add_loaner) ...[
  //                   TextField(
  //                     controller: first_name_controller,
  //                     decoration:
  //                         const InputDecoration(hintText: 'Enter first name'),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextField(
  //                     controller: last_name_controller,
  //                     decoration:
  //                         const InputDecoration(hintText: 'Enter last name'),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextField(
  //                     controller: id_controller,
  //                     decoration: const InputDecoration(hintText: 'Enter ID'),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextField(
  //                     controller: phone_number_controller,
  //                     decoration:
  //                         const InputDecoration(hintText: 'Enter phone number'),
  //                   ),
  //                   const SizedBox(height: 10),
  //                 ],
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () async {
  //                   Map<String, dynamic> loanerData = {};
  //                   if (add_loaner) {
  //                     if (first_name_controller.text.isNotEmpty) {
  //                       loanerData['first_name'] = first_name_controller.text;
  //                     }
  //                     if (last_name_controller.text.isNotEmpty) {
  //                       loanerData['last_name'] = last_name_controller.text;
  //                     }
  //                     if (phone_number_controller.text.isNotEmpty) {
  //                       loanerData['phone_number'] =
  //                           phone_number_controller.text;
  //                     }
  //
  //                     if (loanerData.isNotEmpty) {
  //                       FirebaseFirestore.instance
  //                           .collection('loaners')
  //                           .doc(id_controller.text)
  //                           .set(loanerData, SetOptions(merge: true))
  //                           .then((_) {
  //                         setState(() {
  //                           person = Loaner(
  //                             id_controller.text,
  //                             first_name_controller.text,
  //                             last_name_controller.text,
  //                             phone_number_controller.text,
  //                           );
  //                           _selectedLoanerId = id_controller.text;
  //                         });
  //                         Navigator.of(context).pop();
  //                       });
  //                     }
  //                   } else {
  //                     if (first_name_controller.text.isNotEmpty) {
  //                       loanerData['first_name'] = first_name_controller.text;
  //                     }
  //                     if (last_name_controller.text.isNotEmpty) {
  //                       loanerData['last_name'] = last_name_controller.text;
  //                     }
  //                     if (phone_number_controller.text.isNotEmpty) {
  //                       loanerData['phone_number'] =
  //                           phone_number_controller.text;
  //                     }
  //
  //                     if (loanerData.isNotEmpty) {
  //                       try {
  //                         await FirebaseFirestore.instance
  //                             .collection('loaners')
  //                             .doc(_selectedLoanerId)
  //                             .update(loanerData);
  //                       } catch (e) {
  //                         await FirebaseFirestore.instance
  //                             .collection('loaners')
  //                             .doc(_selectedLoanerId)
  //                             .set(loanerData, SetOptions(merge: true));
  //                       }
  //                     }
  //
  //                     setState(() {
  //                       person = Loaner.withId(_selectedLoanerId!);
  //                     });
  //                     Navigator.of(context).pop();
  //                   }
  //                 },
  //                 child: const Text('Submit'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> setNewLoaner() async {
    print("entered setNewLoaner");
  Map<String, dynamic> loanerData = {};
  if (add_loaner) {
  if (first_name_controller.text.isNotEmpty) {
  loanerData['first_name'] = first_name_controller.text;
  }
  if (last_name_controller.text.isNotEmpty) {
  loanerData['last_name'] = last_name_controller.text;
  }
  if (phone_number_controller.text.isNotEmpty) {
  loanerData['phone_number'] =
  phone_number_controller.text;
  }
  if (loanerData.isNotEmpty) {
  FirebaseFirestore.instance
      .collection('loaners')
      .doc(id_controller.text)
      .set(loanerData, SetOptions(merge: true));
  setState(() {
  person = Loaner(
  id_controller.text,
  first_name_controller.text,
  last_name_controller.text,
  phone_number_controller.text,
  );
  _selectedLoanerId = id_controller.text;
  });
  print("created person");
  // Navigator.of(context).pop();
  }
  }

  else {
  if (first_name_controller.text.isNotEmpty) {
  loanerData['first_name'] = first_name_controller.text;
  }
  if (last_name_controller.text.isNotEmpty) {
  loanerData['last_name'] = last_name_controller.text;
  }
  if (phone_number_controller.text.isNotEmpty) {
  loanerData['phone_number'] =
  phone_number_controller.text;
  }

  if (loanerData.isNotEmpty) {
  try {
  await FirebaseFirestore.instance
      .collection('loaners')
      .doc(_selectedLoanerId)
      .update(loanerData);
  } catch (e) {
  await FirebaseFirestore.instance
      .collection('loaners')
      .doc(_selectedLoanerId)
      .set(loanerData, SetOptions(merge: true));
  }
  }

  setState(() {
  person = Loaner.withId(_selectedLoanerId!);
  });
  Navigator.of(context).pop();
  }
}

  void submit() {
    Loaner loaner;
    if (id_controller.text.isEmpty && _selectedLoanerId == null) {
      return;
    }
    if (first_name_controller.text.isEmpty ||
        last_name_controller.text.isEmpty ||
        phone_number_controller.text.isEmpty) {
      if (_selectedLoanerId != null) {
        loaner = Loaner.withId(_selectedLoanerId!);
      } else {
        throw 'Missing Fields';
      }
    } else {
      loaner = Loaner(id_controller.text, first_name_controller.text,
          last_name_controller.text, phone_number_controller.text);
    }
    setState(() {
      person = loaner;
    });
    Navigator.of(context).pop();
    first_name_controller.clear();
    last_name_controller.clear();
    id_controller.clear();
    phone_number_controller.clear();
  }

  ToggleSwitch toggle_switch() {
    return ToggleSwitch(
      minWidth: 90.0,
      initialLabelIndex: _isSwitchedOn ? 1 : 0,
      cornerRadius: 20.0,
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: const ['הוסף', 'הסר'],
      activeBgColors: const [
        [Colors.blue],
        [Colors.pink]
      ],
      onToggle: (index) {
        _handleToggle(index!);
      },
    );
  }

  void openAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("עדכון ציוד"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              toggle_switch(),
              SizedBox(height: 10),
              DropdownMenu(
                label: Text("סוג הציוד"),
                dropdownMenuEntries: _equipmentNames.map((String value) {
                  return DropdownMenuEntry(value: value, label: value);
                }).toList(),
                onSelected: (value) {
                  setState(() {
                    equipment_chosen = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'quantity'),
                controller: equipment_quantity_controller,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  int.parse(equipment_quantity_controller.text);
                  if (equipment_chosen == null) {
                    throw 'No Equipment Chosen';
                  }
                  setState(() {
                    if (int.parse(equipment_quantity_controller.text) > 0) {
                      items.add(Equipment_counter(
                          equipment_chosen!,
                          int.parse(equipment_quantity_controller.text),
                          _isSwitchedOn));
                    }
                  });
                } catch (e) {
                  if (equipment_chosen == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No Equipment Chosen')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Quantity is not a Numerical Value: ${equipment_quantity_controller.text}')),
                    );
                  }
                }

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    equipment_quantity_controller.clear();
  }

  Future<void> updateLoanerEquipment(
      Loaner person, List<Equipment_counter> items) async {
    try {
      // Reference to the loaner document
      String loanerId = person.get_id();
      DocumentReference loanerDoc =
          firestore.collection('loaners').doc(loanerId);

      // Get the current data of the loaner document
      DocumentSnapshot loanerSnapshot = await loanerDoc.get();

      Map<String, dynamic> currentData =
          loanerSnapshot.data() as Map<String, dynamic>? ?? {};
      Map<String, dynamic> equipmentMap =
          currentData['equipment'] as Map<String, dynamic>? ?? {};

      // Update the equipment quantities
      for (var item in items) {
        if (equipmentMap.containsKey(item.name)) {
          equipmentMap[item.name] +=
              item.switch_on ? -item.quantity : item.quantity;
        } else {
          equipmentMap[item.name] = item.quantity;
        }
      }

      // Update the loaner document with the new equipment data and non-empty fields from the Loaner object
      await loanerDoc.set({
        ...person.toMap(),
        'equipment': equipmentMap,
      }, SetOptions(merge: true));

      print('Equipment updated successfully.');
    } catch (e) {
      print('Error updating equipment: $e');
    }
  }

  Future<void> updateEquipment(
      Loaner person, List<Equipment_counter> items) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      String loanerId = person.get_id();
      print("Changing equipment for $loanerId");

      for (var item in items) {
        DocumentReference equipmentDoc =
            firestore.collection('equipment').doc(item.name);
        DocumentSnapshot equipmentSnapshot = await equipmentDoc.get();

        if (!equipmentSnapshot.exists) {
          throw Exception("Document for ${item.name} does not exist!");
        }

        Map<String, dynamic> currentData =
            equipmentSnapshot.data() as Map<String, dynamic>;
        int currentQuantity = currentData['current_quantity'];

        if (currentQuantity < item.quantity) {
          throw Exception("Not enough inventory for ${item.name}");
        }

        Map<String, dynamic> loanedMap =
            currentData['loaned'] as Map<String, dynamic>? ?? {};

        if (loanedMap.containsKey(loanerId)) {
          loanedMap[loanerId] += item.quantity;
        } else {
          loanedMap[loanerId] = item.quantity;
        }

        await equipmentDoc.set({
          'loaned': loanedMap,
          'current_quantity': currentQuantity -
              (item.switch_on ? -item.quantity : item.quantity),
        }, SetOptions(merge: true));
      }

      print('Equipment updated successfully.');
    } catch (e) {
      print('Error updating equipment: $e');
    }
  }
}
