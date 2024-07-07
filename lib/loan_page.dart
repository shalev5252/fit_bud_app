import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/widgets/date_picker.dart';

import 'classes/Equipment_counter.dart';
import 'classes/Loaner.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  late TextEditingController first_name_controller;
  late TextEditingController last_name_controller;
  late TextEditingController phone_number_controller;
  late TextEditingController id_controller;
  DateTime? _selectedDate;

  String _name = '';

  List<Equipment_counter> equip = [];

  @override
  void initState() {
    super.initState();
    first_name_controller = TextEditingController();
    last_name_controller = TextEditingController();
    phone_number_controller = TextEditingController();
    id_controller = TextEditingController();
  }

  @override
  void dispose() {
    first_name_controller.dispose();
    last_name_controller.dispose();
    phone_number_controller.dispose();
    id_controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('החתמת ציוד'),
      ),
      body: Column(
        children: [
          Text(_selectedDate != null ? 'Selected Date: $_selectedDate' : 'No date selected'),
          Text(_name),
    SizedBox(height: 10),
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: GestureDetector(
          onTap: () async{
            final name = await open_dialog ();
            if (name == null || name.isEmpty) {return;}
            setState(() {
              _name = name;
            });
          },
          child: Text(
            "Fill Human Details",
            textAlign: TextAlign.center, // Align text to center within the container
            style: TextStyle(
              fontSize: 16.0, // Adjust font size as needed
              color: Colors.white, // Change text color to white
            ),
          ),
        ),
        ),// Set to true for smaller button, false for larger button),
    SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                print("pressed");
              },
              child: Icon(Icons.add),
            ),
          ),
    ]
            ),
    );
  }

  Future<String?> open_dialog() {
    {
      return showDialog(context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Name"),
                content:
                Column(
                  children: [
                    TextField(
                      controller: first_name_controller,
                      autofocus: true,
                      decoration:
                      InputDecoration(hintText: 'enter firstName'),),
                    SizedBox(height: 10),
                    TextField(
                      controller: last_name_controller,
                      autofocus: true,
                      decoration:
                      InputDecoration(hintText: 'enter lastName'),),
                    SizedBox(height: 10),
                    TextField(
                      controller: id_controller,
                      autofocus: true,
                      decoration:
                      InputDecoration(hintText: 'enter id'),),

                    SizedBox(height: 10),
                    TextField(
                      controller: phone_number_controller,
                      autofocus: true,
                      decoration:
                      InputDecoration(hintText: 'enter phone number'),),
                    SizedBox(height: 10),
                    DateOfBirthPicker(
                      onDateSelected: (DateTime selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate; // Update selected date
                        });
                      },
                    ),                  ],
                ),
              actions: [TextButton(onPressed: submit, child: Text('submit'))],));
    }
  }

  void submit() {
    final person = Loaner(first_name_controller.text,last_name_controller.text,id_controller.text,phone_number_controller.text,_selectedDate!);
    setState(() {
      _name = person.first_name + " " + person.last_name + " " + person.id + " " + person.phone_number + " " + person.req_date.toString();
    });
    Navigator.of(context).pop();
    first_name_controller.clear();
    last_name_controller.clear();
    id_controller.clear();
    phone_number_controller.clear();

    print(person.last_name);
  }
}
