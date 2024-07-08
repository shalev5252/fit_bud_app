import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/widgets/date_picker.dart';
import 'package:untitled1/widgets/equip_list_tile.dart';

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

  late TextEditingController equipment_name_controller;
  late TextEditingController equipment_quantity_controller;

  DateTime? _selectedDate;

  String _name = '';

  List<Equipment_counter> items = [
    Equipment_counter('Item 1', 1),
    Equipment_counter('Item 2', 2),
    Equipment_counter('Item 3', 3),
  ];

  @override
  void initState() {
    super.initState();
    first_name_controller = TextEditingController();
    last_name_controller = TextEditingController();
    phone_number_controller = TextEditingController();
    id_controller = TextEditingController();
    equipment_name_controller = TextEditingController();
    equipment_quantity_controller = TextEditingController();
  }

  @override
  void dispose() {
    first_name_controller.dispose();
    last_name_controller.dispose();
    phone_number_controller.dispose();
    id_controller.dispose();
    equipment_name_controller.dispose();
    equipment_quantity_controller.dispose();
    super.dispose();
  }

  void _editItem(int index) {
    setState(() {
      equipment_name_controller= TextEditingController(text: items[index].name);
      equipment_quantity_controller = TextEditingController(text: items[index].quantity.toString());
    });
    openEditDialog(items[index],index);
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
        title: const Text('החתמת ציוד'),
      ),
      body: Column(
        children: [
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
                openAddDialog();
              },
              child: Icon(Icons.add),
            ),
          ),

            Container(
              height: MediaQuery.sizeOf(context).height * 0.4,
            child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
    final item = items[index];
    return Container(
    decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
    ),
    child: ListTile(
    title: Row(
    children: [
    Expanded(child: Text(item.name)),
    Expanded(child: Text(item.quantity.toString())),
    ],),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _editItem(index),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteItem(index),
        ),
      ],
    ),));}),
    ),
SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () {
              //Todo - add functionality to add the list to the database
              Navigator.pop(context);
            },
            child: Text('Confirm'),
          ),
    ],


      ),
    );
  }

  void openEditDialog(Equipment_counter item, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'name' , hintText: item.name),
                controller: equipment_name_controller,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'quantity' , hintText: item.quantity.toString()),
                controller: equipment_quantity_controller,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

                try {
                  int.parse(equipment_quantity_controller.text);
                  setState(() {
        items[index] = Equipment_counter(equipment_name_controller.text, int.parse(equipment_quantity_controller.text));
        });
                  Navigator.of(context).pop();
                  if (int.parse(equipment_quantity_controller.text) == 0){
                    _deleteItem(index);
                  }

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Quantity is not a Numerical Value: ${equipment_quantity_controller.text}')),
                  );}


              },
              child: Text('Save'),
            ),
          ],
        );
      },
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
      _name = person.first_name + " " + person.last_name + " " + person.id + " " + person.phone_number + " " + DateFormat('dd/MM/yyyy').format(person.req_date);
    });
    Navigator.of(context).pop();
    first_name_controller.clear();
    last_name_controller.clear();
    id_controller.clear();
    phone_number_controller.clear();

    print(person.last_name);
  }

  void openAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'name'),
                controller: equipment_name_controller,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'quantity'),
                controller: equipment_quantity_controller,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  int.parse(equipment_quantity_controller.text);
                  setState(() {
                    if (int.parse(equipment_quantity_controller.text) > 0) {
                      items.add(Equipment_counter(equipment_name_controller.text,
                          int.parse(equipment_quantity_controller.text)));
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Quantity is not a Numerical Value: ${equipment_quantity_controller.text}')),
                      );}


                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
    equipment_name_controller.clear();
    equipment_quantity_controller.clear();
  }


}
