import 'package:flutter/material.dart';

class AddMenuForm extends StatefulWidget {
  final void Function({
    required String namaMakanan,
    required int harga,
    required String deskripsi,
    required String kategori,
    required int stok,
  }) onSubmit;

  const AddMenuForm({super.key, required this.onSubmit});

  @override
  _AddMenuFormState createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  String _kategori = 'food'; 

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        namaMakanan: _namaController.text,
        harga: int.parse(_hargaController.text),
        deskripsi: _deskripsiController.text,
        kategori: _kategori,
        stok: int.parse(_stokController.text),
      );

      _formKey.currentState!.reset();
      _namaController.clear();
      _hargaController.clear();
      _deskripsiController.clear();
      _stokController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Makanan'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama makanan tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Harga'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _stokController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Stok'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Stok tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _kategori,
              items: ['food', 'beverage']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _kategori = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
