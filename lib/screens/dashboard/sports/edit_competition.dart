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
  final ScrollController _scrollController = ScrollController();

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
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      appBar: AppBar(
        title: const Text(
          "Edit Race Event",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Update Competition Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Event Name
                    _buildTextField(
                      controller: _nameController,
                      label: "Event Name",
                      icon: Icons.event,
                      validatorText: "Please enter an event name",
                    ),
                    const SizedBox(height: 20),

                    // Distance
                    _buildTextField(
                      controller: _distanceController,
                      label: "Distance",
                      icon: Icons.straighten,
                      validatorText: "Please enter the distance",
                    ),
                    const SizedBox(height: 20),

                    // Date
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: _inputDecoration("Date", Icons.calendar_today),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a date' : null,
                    ),
                    const SizedBox(height: 20),

                    // Dropdown
                    DropdownButtonFormField<CompetitionType>(
                      value: _selectedType,
                      decoration: _inputDecoration("Competition Type", Icons.directions_run),
                      items: CompetitionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                          _scrollController.animateTo(
                            200.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      validator: (value) =>
                          value == null ? 'Please select a competition type' : null,
                    ),
                    const SizedBox(height: 30),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                        ),
                        ElevatedButton(
                          onPressed: _saveCompetition,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Save", style: TextStyle(fontSize: 16)),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      validator: (value) => value == null || value.isEmpty ? validatorText : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue.shade700),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.blue[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    );
  }
}
