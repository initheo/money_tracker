import 'package:flutter/material.dart';
import 'package:money_tracker/data/model/transaction.dart';

class DetailPage extends StatelessWidget {
  final Transaction ts;

  const DetailPage({super.key, required this.ts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text('Tipe: ${ts.type}'),
            const SizedBox(height: 8),
            Text('Kategori: ${ts.category}'),
            const SizedBox(height: 8),
            Text('Deskripsi: ${ts.description}'),
            const SizedBox(height: 8),
            Text('Jumlah: Rp${ts.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Tanggal: ${ts.date}'),
            Row(
              spacing: 10,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Delete'),
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: ElevatedButton(onPressed: () {}, child: Text('Edit')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
