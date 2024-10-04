import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/widgets/custom_appbar.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class DrugListScreen extends StatefulWidget {
  const DrugListScreen({super.key});

  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  double? drugValue;
  double? minVolume;
  double? maxVolume;
  String? selectedDrug;
  double? minVal; // Min concentration from Firestore
  double? maxVal; // Max concentration from Firestore

  List<Map<String, dynamic>> filteredDrugs = [];
  bool isSearching = false;

  // List to store search history
  List<Map<String, String>> searchHistory = [];

  @override
  void initState() {
    super.initState();
  }

  // Function to calculate min and max volume
  void calculateVolumes() {
    setState(() {
      if (_controller.text.isNotEmpty && selectedDrug != null) {
        drugValue = double.tryParse(_controller.text);
        if (drugValue != null) {
          final drug = filteredDrugs.firstWhere(
            (drug) => drug['name'] == selectedDrug,
            orElse: () => {
              'minFormula': (double value) => 0.0,
              'maxFormula': (double value) => 0.0
            },
          );
          minVolume = drug['minFormula'](drugValue!);
          maxVolume = drug['maxFormula'](drugValue!);
          minVal = drug['minVal']; // Set minVal from Firestore
          maxVal = drug['maxVal']; // Set maxVal from Firestore
        }
      }
    });
  }

  // Function to fetch drugs from Firestore based on search input
  Future<void> _fetchDrugs(String query) async {
    if (query.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection('add_data')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name',
              isLessThanOrEqualTo:
                  query + '\uf8ff') // To match all related items
          .get();

      setState(() {
        filteredDrugs = snapshot.docs.map((doc) {
          return {
            'name': doc['name'],
            'minFormula': (double value) => value / doc['minVal'],
            'maxFormula': (double value) => value / doc['maxVal'],
            'minVal': doc['minVal'], // Store original minVal
            'maxVal': doc['maxVal'], // Store original maxVal
          };
        }).toList();
      });
    } else {
      setState(() {
        filteredDrugs = [];
      });
    }
  }

  // Function to add search to history
  void _addToSearchHistory(String drugName) {
    final now = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Add the search to the history
    setState(() {
      searchHistory.insert(0, {'name': drugName, 'time': formattedTime});

      // Keep only the last 3 searches
      if (searchHistory.length > 10) {
        searchHistory.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Drug Volume Calculator for Dilution",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Search bar
            if (isSearching) ...[
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Search Drug...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _fetchDrugs(value);
                },
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: filteredDrugs.length,
                  itemBuilder: (context, index) {
                    final drug = filteredDrugs[index];
                    return ListTile(
                      title: Text(drug['name']),
                      onTap: () {
                        setState(() {
                          selectedDrug = drug['name'];
                          calculateVolumes();
                          isSearching = false;
                          _searchController.clear(); // Clear the search text

                          // Add selected drug to history
                          _addToSearchHistory(drug['name']);
                        });
                      },
                    );
                  },
                ),
              ),
            ] else ...[
              // Dropdown button
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSearching = true; // Open search when tapped
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedDrug ?? "Select Drug",
                          style: const TextStyle(fontSize: 16)),
                      const Icon(Icons.search),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            // Input for Drug in Mg
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Drug in Mg",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                calculateVolumes();
              },
            ),
            const SizedBox(height: 20),
            // Table to display the calculated data
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Drug in Mg',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Min Volume (ML)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Max Volume (ML)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(drugValue?.toStringAsFixed(1) ?? 'Enter Value'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(minVolume?.toStringAsFixed(0) ?? '-'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(maxVolume?.toStringAsFixed(0) ?? '-'),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            // Display concentration range
            if (minVal != null && maxVal != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 2.0, // Border width
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Text(
                      "Final Concentration range: ${minVal!.toStringAsFixed(1)} - ${maxVal!.toStringAsFixed(1)} mg/ml",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        // fontSize:
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            // Display search history
            if (searchHistory.isNotEmpty) ...[
              const Text(
                "Previous Searches:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300, // Set a fixed height for the scrollable area
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Add padding around the ListView
                child: ListView.builder(
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    final search = searchHistory[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0), // Gap between items
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color of the item
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.3), // Shadow color
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(search['name']!),
                          subtitle: Text(search['time']!),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
