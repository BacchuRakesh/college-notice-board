import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/departments.dart';
import '../models/notice.dart';
import '../services/notice_provider.dart';

/// Form for posting a notice. Every field is checked before saving.
class NoticeFormScreen extends StatefulWidget {
  const NoticeFormScreen({super.key});

  @override
  State<NoticeFormScreen> createState() => _NoticeFormScreenState();
}

class _NoticeFormScreenState extends State<NoticeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _postedByController = TextEditingController();

  String? _department;
  DateTime? _date;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _postedByController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(FormFieldState<DateTime> field) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      field.didChange(picked);
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    if (_saving) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    final provider = context.read<NoticeProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await provider.addNotice(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      department: _department!,
      date: _date!,
      postedBy: _postedByController.text.trim(),
    );

    if (!mounted) {
      return;
    }
    if (ok) {
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Notice posted')));
    } else {
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not save the notice. Try again.')),
      );
    }
  }

  String? _validateText(String? value, String label, int minLength) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter $label';
    }
    if (text.length < minLength) {
      return 'Use at least $minLength characters for $label';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post notice')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      maxLength: 80,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => _validateText(value, 'a title', 3),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLength: 1000,
                      minLines: 3,
                      maxLines: 6,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          _validateText(value, 'a description', 10),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _department,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final department in departmentOptions)
                          DropdownMenuItem(
                            value: department,
                            child: Text(
                              department,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() => _department = value),
                      validator: (value) =>
                          value == null ? 'Select a department' : null,
                    ),
                    const SizedBox(height: 24),
                    FormField<DateTime>(
                      validator: (value) =>
                          value == null ? 'Choose a date' : null,
                      builder: (field) {
                        return InkWell(
                          onTap: () => _pickDate(field),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                              errorText: field.errorText,
                            ),
                            child: Text(
                              _date == null
                                  ? 'Tap to choose a date'
                                  : Notice.formatDate(_date!),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _postedByController,
                      maxLength: 40,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Posted by',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          _validateText(value, 'who is posting', 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('saveNoticeButton'),
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save notice'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
