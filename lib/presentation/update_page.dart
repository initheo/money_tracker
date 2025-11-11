import 'package:flutter/material.dart';
import 'package:money_tracker/data/model/transaction.dart';
import 'package:money_tracker/data/repository/money_repository.dart';

class UpdatePage extends StatefulWidget {
  final Transaction ts;

  const UpdatePage({super.key, required this.ts});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  List<String> categories = [
    'Gaji',
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Tagihan',
    'Belanja',
    'Lainnya',
  ];
  final _formKey = GlobalKey<FormState>();
  final _categoryCtr = TextEditingController();
  final _descCtr = TextEditingController();
  final _amountCtr = TextEditingController();
  String _type = 'income';
  DateTime _selectedDate = DateTime.now();
  final _repo = MoneyRepository();

  @override
  void dispose() {
    _categoryCtr.dispose();
    _descCtr.dispose();
    _amountCtr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _type = widget.ts.type;
    _categoryCtr.text = widget.ts.category;
    _descCtr.text = widget.ts.description;
    _amountCtr.text = widget.ts.amount.toString();
    _selectedDate = DateTime.parse(widget.ts.date);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtr.text) ?? 0.0;

    final tx = Transaction(
      id: widget.ts.id,
      type: _type,
      category: _categoryCtr.text.trim(),
      description: _descCtr.text.trim(),
      amount: amount,
      date: _selectedDate.toIso8601String(),
    );

    await _repo.updateTransaction(widget.ts.id!, tx);
    // return true to caller so it can refresh list if needed
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Tipe'),
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'income'),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Kategori'),
                value: _categoryCtr.text,
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (v) => _categoryCtr.text = v ?? '',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Pilih kategori' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descCtr,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Masukkan deskripsi'
                    : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _amountCtr,
                decoration: const InputDecoration(labelText: 'Nominal'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Masukkan nominal';
                  final n = double.tryParse(v);
                  if (n == null) return 'Masukkan angka yang valid';
                  if (n <= 0) return 'Nominal harus lebih besar dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal: ${_selectedDate.toLocal().toString().split(' ').first}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pilih Tanggal'),
                  ),
                  const SizedBox(width: 20),

                  ElevatedButton(onPressed: _save, child: const Text('Update')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
