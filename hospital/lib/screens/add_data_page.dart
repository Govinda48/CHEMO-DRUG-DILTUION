import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/widgets/custom_appbar.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _minValController = TextEditingController();
  final TextEditingController _maxValController = TextEditingController();

  Future<void> _submitData() async {
    String name = _nameController.text;

    // Parse the min and max values
    double? minVal = double.tryParse(_minValController.text);
    double? maxVal = double.tryParse(_maxValController.text);

    // Check for empty fields and invalid values
    if (name.isEmpty || minVal == null || maxVal == null) {
      // Show an error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid values!')),
      );
      return; // Stop further execution
    }

    // Store data in Firestore
    await FirebaseFirestore.instance.collection('add_data').add({
      'name': name,
      'minVal': minVal,
      'maxVal': maxVal,
    });

    // Clear the text fields
    _nameController.clear();
    _minValController.clear();
    _maxValController.clear();

    // Show a custom success message using awesome design
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white), // Success icon
            SizedBox(width: 10),
            Text(
              'Data submitted successfully!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.green, // Success background color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        margin: EdgeInsets.all(16), // Margin around the SnackBar
        duration: Duration(seconds: 3), // Duration to show the SnackBar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Drug Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Border radius
                ),
              ),
            ),
            SizedBox(height: 16), // Spacing between TextFields

            // Min Value TextField
            TextField(
              controller: _minValController,
              decoration: InputDecoration(
                labelText: 'Min Value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Border radius
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16), // Spacing between TextFields

            // Max Value TextField
            TextField(
              controller: _maxValController,
              decoration: InputDecoration(
                labelText: 'Max Value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Border radius
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton.icon(
              onPressed: _submitData,
              icon: Icon(Icons.send), // Icon before text
              label: Text('Submit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // Button text color
                minimumSize: Size(double.infinity, 50), // Width double infinity
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Border radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
