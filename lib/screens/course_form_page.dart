import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/student_identity.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

/// TAHAP 6-7 (P7): form tambah dan edit course. Screen tidak memanggil package http;
/// data dikirim lewat CourseProvider -> CourseRepository -> CourseApiService.
class CourseFormPage extends StatefulWidget {
  /// Jika diisi, form berada pada mode edit.
  final Course? course;

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _status = 'planned';

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    // TAHAP 7: isi form dengan data lama saat mode edit
    final c = widget.course;
    if (c != null) {
      _codeController.text = c.code;
      _titleController.text = c.title;
      _creditsController.text = c.credits.toString();
      _status = c.status;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CourseProvider>();
    if (provider.isSaving) return; // guard submit ganda

    final course = Course(
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    // Mode edit memakai PUT, mode tambah memakai POST
    final ok = _isEdit
        ? await provider.updateCourse(widget.course!.id!, course)
        : await provider.createCourse(course);

    // Setelah await, pastikan widget masih terpasang sebelum memakai context
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (_isEdit ? 'Course berhasil diperbarui' : 'Course berhasil dibuat')
              : 'Gagal menyimpan course: ${provider.saveError}',
        ),
      ),
    );

    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Course' : 'Tambah Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '$studentId - $studentName',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                // Kode read-only saat edit karena dipakai sebagai kunci favorites
                readOnly: _isEdit,
                decoration: InputDecoration(
                  labelText: 'Kode',
                  border: const OutlineInputBorder(),
                  helperText: _isEdit ? 'Kode tidak dapat diubah' : null,
                  filled: _isEdit,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Kode wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'SKS', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'SKS wajib diisi';
                  final n = int.tryParse(v.trim());
                  if (n == null) return 'SKS harus berupa angka';
                  if (n <= 0) return 'SKS harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('planned')),
                  DropdownMenuItem(value: 'active', child: Text('active')),
                  DropdownMenuItem(value: 'done', child: Text('done')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'planned'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  // Tombol dinonaktifkan selama request berjalan
                  onPressed: isSaving ? null : _submit,
                  icon: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}