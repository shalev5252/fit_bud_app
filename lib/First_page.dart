import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _isSwitchedOn = false;
  bool add_new_equipment = false;
  String? _selectedValue;

  void _handleToggle(int index) {
    setState(() {
      _isSwitchedOn = index == 1; // Assuming index 1 is "On" and index 0 is "Off"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add equipment to storage'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            DropdownButton<String>(
              hint: Text('Select an option'),
              value: _selectedValue,
              items: <String>['A', 'B', 'C', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                  if (value == 'Other') {
                    // Implement your logic here
                    add_new_equipment = true;
                  }
                  else{
                    add_new_equipment = false;
                  }
                });
              },
            ),
            SizedBox(height: 30),

            ToggleSwitch(
              minWidth: 90.0,
              initialLabelIndex: _isSwitchedOn ? 1 : 0,
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: ['Add', 'Remove'],
              activeBgColors: [[Colors.blue],[Colors.pink]],
              onToggle: (index) {
                _handleToggle(index!);
              },
            ),
            Text('${_isSwitchedOn} - ${_isSwitchedOn ? "subtruct equipment" : "add equipment"}'),

            add_new_equipment ?
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter equipment name',
              ),
            ) : Container( child: Text('$_selectedValue'),),

            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter quantity',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Implement your add/remove logic here
                print('confirm button pressed');
              },
              child: const Text('Add/Remove'),
            ),
          ],
        )

      ),
    );
  }
}
