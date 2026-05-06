import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../../models/event.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/log_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class EventFormScreen extends StatefulWidget {
  final Event? event;
  const EventFormScreen({Key? key, this.event}) : super(key: key);

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _location;
  String? _selectedClassId;
  int? _maxParticipants;
  EventVisibility _visibility = EventVisibility.public;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _urlController = TextEditingController();
  
  late DateTime _startTime;
  late DateTime _endTime;
  bool _isPaid = false;
  double? _price;

  @override
  void initState() {
    super.initState();
    _title = widget.event?.title ?? '';
    _description = widget.event?.description ?? '';
    _location = widget.event?.location ?? '';
    _selectedClassId = widget.event?.assignedClassId;
    _maxParticipants = widget.event?.maxParticipants;
    _visibility = widget.event?.visibility ?? EventVisibility.public;
    _isPaid = (widget.event?.price ?? 0) > 0;
    _price = widget.event?.price;
    
    _startTime = widget.event?.startTime ?? DateTime.now().add(const Duration(days: 1));
    _endTime = widget.event?.endTime ?? _startTime.add(const Duration(hours: 2));
    _urlController.text = widget.event?.imageUrl ?? '';
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _imageFile = pickedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error picking image')));
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startTime : _endTime;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: apexPrimary),
        ),
        child: child!,
      ),
    );
    
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: apexPrimary),
          ),
          child: child!,
        ),
      );
      
      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 
            pickedTime.hour, pickedTime.minute
          );
          if (isStart) {
            _startTime = newDateTime;
            if (_endTime.isBefore(_startTime)) _endTime = _startTime.add(const Duration(hours: 2));
          } else {
            if (newDateTime.isBefore(_startTime)) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End time cannot be before start time')));
            } else {
              _endTime = newDateTime;
            }
          }
        });
      }
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final eventData = Event(
        id: widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        location: _location,
        startTime: _startTime,
        endTime: _endTime,
        assignedClassId: _selectedClassId,
        maxParticipants: _maxParticipants,
        visibility: _visibility,
        imageUrl: _imageFile?.path ?? (_urlController.text.isNotEmpty ? _urlController.text : widget.event?.imageUrl),
        price: _isPaid ? _price : 0,
        createdByUsername: authProvider.currentUser?.username ?? 'Admin',
        isPublished: true,
      );

      if (widget.event == null) {
        eventProvider.addEvent(eventData);
        Provider.of<LogProvider>(context, listen: false).addLog(
          event: 'Event Created',
          user: authProvider.currentUser?.username ?? 'Admin',
          status: 'Success',
          severity: 'low',
        );
      } else {
        eventProvider.updateEvent(widget.event!.id, eventData);
        Provider.of<LogProvider>(context, listen: false).addLog(
          event: 'Event Updated',
          user: authProvider.currentUser?.username ?? 'Admin',
          status: 'Success',
          severity: 'low',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.event == null ? 'Event Created Successfully!' : 'Event Updated Successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final myClasses = classProvider.getClassesForTeacher(authProvider.currentUser?.email ?? '');

    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        title: Text(widget.event == null ? 'Create Event' : 'Edit Event', 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: apexPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Image URL (Optional)',
                controller: _urlController,
                icon: Icons.link,
                onChanged: (val) => setState(() {}),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('General Information'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Event Title',
                initialValue: _title,
                icon: Icons.title,
                onSaved: (val) => _title = val!,
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Location',
                initialValue: _location,
                icon: Icons.location_on_outlined,
                onSaved: (val) => _location = val!,
                validator: (val) => val!.isEmpty ? 'Please enter a location' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Description',
                initialValue: _description,
                icon: Icons.description_outlined,
                maxLines: 4,
                onSaved: (val) => _description = val!,
                validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Date & Time'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDateTimePicker('Starts', _startTime, true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Ends', _endTime, false)),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Pricing & Tickets'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    const Icon(Icons.payments_outlined, color: apexPrimary, size: 20),
                    const SizedBox(width: 12),
                    const Text('Event Price Type', style: TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    ChoiceChip(
                      label: const Text('Free'),
                      selected: !_isPaid,
                      onSelected: (val) => setState(() => _isPaid = !val),
                      selectedColor: apexPrimary.withOpacity(0.2),
                      labelStyle: TextStyle(color: !_isPaid ? apexPrimary : Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Paid'),
                      selected: _isPaid,
                      onSelected: (val) => setState(() => _isPaid = val),
                      selectedColor: apexPrimary.withOpacity(0.2),
                      labelStyle: TextStyle(color: _isPaid ? apexPrimary : Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (_isPaid) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Price (USD)',
                  initialValue: _price?.toString(),
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  onSaved: (val) => _price = val != null && val.isNotEmpty ? double.parse(val) : 0,
                ),
              ],
              const SizedBox(height: 32),
              _buildSectionTitle('Settings'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<EventVisibility>(
                      value: _visibility,
                      decoration: _inputDecoration('Visibility', Icons.visibility_outlined),
                      items: EventVisibility.values.map((v) => DropdownMenuItem(
                        value: v, child: Text(v.toString().split('.').last.toUpperCase(), style: const TextStyle(fontSize: 12)),
                      )).toList(),
                      onChanged: (val) => setState(() => _visibility = val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Max Capacity',
                      initialValue: _maxParticipants?.toString(),
                      icon: Icons.people_outline,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _maxParticipants = val != null && val.isNotEmpty ? int.parse(val) : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                value: _selectedClassId,
                decoration: _inputDecoration('Assigned Class (Optional)', Icons.class_outlined),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No Class / General', style: TextStyle(fontSize: 13))),
                  ...myClasses.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, style: const TextStyle(fontSize: 13)))),
                ],
                onChanged: (val) => setState(() => _selectedClassId = val),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: apexPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  shadowColor: apexPrimary.withOpacity(0.3),
                ),
                child: Text(widget.event == null ? 'Create Event' : 'Save Changes', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText));
  }

  Widget _buildTextField({required String label, String? initialValue, TextEditingController? controller, required IconData icon, int maxLines = 1, FormFieldSetter<String>? onSaved, FormFieldValidator<String>? validator, TextInputType? keyboardType, ValueChanged<String>? onChanged}) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon),
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: apexPrimary, size: 20),
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: apexPrimary, width: 1.5)),
    );
  }

  Widget _buildDateTimePicker(String label, DateTime value, bool isStart) {
    return InkWell(
      onTap: () => _selectDateTime(context, isStart),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(DateFormat('MMM dd, HH:mm').format(value), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: _imageFile != null
              ? (kIsWeb ? Image.network(_imageFile!.path, fit: BoxFit.cover) : Image.file(File(_imageFile!.path), fit: BoxFit.cover))
              : (widget.event?.imageUrl != null || _urlController.text.isNotEmpty
                  ? Image.network(_urlController.text.isNotEmpty ? _urlController.text : widget.event!.imageUrl!, fit: BoxFit.cover, 
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey)))
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 48, color: apexPrimary.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          const Text('Add Event Banner', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )),
        ),
      ),
    );
  }
}

