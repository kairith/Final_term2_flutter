import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_final/models/competition.dart';

class EditCompetitionScreen extends StatefulWidget {
  final Competition competition;

  const EditCompetitionScreen({super.key, required this.competition});

  @override
  _EditCompetitionScreenState createState() => _EditCompetitionScreenState();
}

class _EditCompetitionScreenState extends State<EditCompetitionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _distanceController;
  late TextEditingController _dateController;
  late CompetitionType _selectedType;
  late DateTime _selectedDate;
  final ScrollController _scrollController = ScrollController(); // Scroll controller

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.competition.name);
    _distanceController = TextEditingController(text: widget.competition.distance);
    _dateController = TextEditingController();
    _selectedType = widget.competition.type;
    _selectedDate = _parseDate(widget.competition.date);
    _dateController.text = DateFormat('MMMM d, yyyy').format(_selectedDate);
  }

  DateTime _parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _distanceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  void _saveCompetition() {
    if (_formKey.currentState!.validate()) {
      final updatedCompetition = Competition(
        name: _nameController.text,
        distance: _distanceController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        type: _selectedType,
      );
      Navigator.pop(context, updatedCompetition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 132, 192, 241),
      appBar: AppBar(
        title: const Text(
          "Edit Race Event",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,  // Attach the scroll controller
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Event Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.event, color: Colors.blue.shade700),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an event name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Distance field
                    TextFormField(
                      controller: _distanceController,
                      decoration: InputDecoration(
                        labelText: 'Distance',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.straighten, color: Colors.blue.shade700),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the distance';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Date field
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Competition Type dropdown
                    DropdownButtonFormField<CompetitionType>(
                      value: _selectedType,
                      decoration: InputDecoration(
                        labelText: 'Competition Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.directions_run, color: Colors.blue.shade700),
                      ),
                      items: CompetitionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedType = value;
                          });
                          // Scroll to the next section (or move as required)
                          _scrollController.animateTo(
                            200.0, // Adjust scroll position based on where you want to move
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a competition type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _saveCompetition,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
