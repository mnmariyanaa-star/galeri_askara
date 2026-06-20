import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  XFile? _imageFile;     // Untuk path/file fisik
  Uint8List? _imageBytes; // Untuk Web: simpan bytes
  Uint8List? _editedImage;

  double _brightness = 0;
  double _contrast = 1;
  double _rotation = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<String> selectedCategories = [];
  List<String> allCategories = [
    'Impresionisme', 'Realisme', 'Surealisme', 'Ekspresionisme',
    'Lukisan Digital', 'Foto', 'Ilustrasi'
  ];

  String? _visibility = "Publik";
  bool _commentsEnabled = true;
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  // --- Gambar ---
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _imageBytes = null;
        _editedImage = null;
        _brightness = 0;
        _contrast = 1;
        _rotation = 0;
      });
      if (kIsWeb) {
        // Untuk web, ambil bytes-nya
        _imageBytes = await pickedFile.readAsBytes();
      }
    }
  }

  // --- Basic Edit (Image ^4.x) ---
  Future<void> _editImage() async {
    Uint8List? imgBytes;
    if (kIsWeb && _imageBytes != null) {
      imgBytes = _imageBytes;
    } else if (!kIsWeb && _imageFile != null) {
      imgBytes = await File(_imageFile!.path).readAsBytes();
    }
    if (imgBytes == null) return;
    img.Image? image = img.decodeImage(imgBytes);
    if (image != null) {
      image = img.adjustColor(
        image,
        brightness: _brightness,
        contrast: _contrast,
      );
      if (_rotation != 0) {
        image = img.copyRotate(image, angle: _rotation.toInt());
      }
      setState(() {
        _editedImage = Uint8List.fromList(img.encodeJpg(image!));
      });
    }
  }

  // --- Reset Edit ---
  void _resetEdit() {
    setState(() {
      _editedImage = null;
      _brightness = 0;
      _contrast = 1;
      _rotation = 0;
    });
  }

  // --- Tanggal Picker ---
  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1800),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Karya berhasil ditambahkan!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showImage = _editedImage != null
        ? Image.memory(_editedImage!, width: double.infinity, height: 220, fit: BoxFit.cover)
        : (kIsWeb
        ? (_imageBytes != null
        ? Image.memory(_imageBytes!, width: double.infinity, height: 220, fit: BoxFit.cover)
        : null)
        : (_imageFile != null
        ? Image.file(File(_imageFile!.path), width: double.infinity, height: 220, fit: BoxFit.cover)
        : null));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Karya"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PILIH / TAMBAH GAMBAR ---
              Center(
                child: Column(
                  children: [
                    if (showImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: showImage,
                      ),
                    if (showImage == null)
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.grey[200],
                        ),
                        child: const Center(child: Text("Belum ada gambar")),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Kamera"),
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Galeri"),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // --- BASIC EDIT ---
              if ((_imageFile != null || _imageBytes != null) && (showImage != null))
                ExpansionTile(
                  title: const Text("Edit Gambar (opsional)"),
                  initiallyExpanded: false,
                  children: [
                    Row(
                      children: [
                        const Text("Brightness"),
                        Expanded(
                          child: Slider(
                            value: _brightness,
                            min: -1,
                            max: 1,
                            divisions: 20,
                            label: _brightness.toStringAsFixed(2),
                            onChanged: (val) => setState(() => _brightness = val),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Contrast"),
                        Expanded(
                          child: Slider(
                            value: _contrast,
                            min: 0,
                            max: 2,
                            divisions: 20,
                            label: _contrast.toStringAsFixed(2),
                            onChanged: (val) => setState(() => _contrast = val),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Rotate"),
                        Expanded(
                          child: Slider(
                            value: _rotation,
                            min: -180,
                            max: 180,
                            divisions: 12,
                            label: _rotation.toStringAsFixed(0),
                            onChanged: (val) => setState(() => _rotation = val),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _editImage,
                          child: const Text("Terapkan Edit"),
                        ),
                        TextButton(
                          onPressed: _resetEdit,
                          child: const Text("Reset"),
                        ),
                      ],
                    )
                  ],
                ),
              const SizedBox(height: 18),

              // --- JUDUL KARYA (Opsional) ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Karya (Opsional)",
                  hintText: "Contoh: Senja di Tengah Keramaian",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // --- DESKRIPSI KARYA ---
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi / Cerita Karya",
                  hintText: "Tuliskan inspirasi atau cerita di balik karya ini...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) =>
                (val == null || val.isEmpty) ? "Deskripsi wajib diisi!" : null,
              ),
              const SizedBox(height: 12),

              // --- KATEGORI ---
              const Text("Kategori / Aliran Seni", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: allCategories.map((cat) {
                  final selected = selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (isSel) {
                      setState(() {
                        if (isSel) {
                          selectedCategories.add(cat);
                        } else {
                          selectedCategories.remove(cat);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // --- LOKASI (Opsional) ---
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Lokasi (Opsional)",
                  hintText: "Tulis lokasi pembuatan jika ada",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // --- VISIBILITY ---
              const Text("Privasi / Visibility", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 16,
                children: [
                  ChoiceChip(
                    label: const Text("Publik"),
                    selected: _visibility == "Publik",
                    onSelected: (_) => setState(() => _visibility = "Publik"),
                  ),
                  ChoiceChip(
                    label: const Text("Pribadi"),
                    selected: _visibility == "Pribadi",
                    onSelected: (_) => setState(() => _visibility = "Pribadi"),
                  ),
                  ChoiceChip(
                    label: const Text("Unlisted"),
                    selected: _visibility == "Unlisted",
                    onSelected: (_) => setState(() => _visibility = "Unlisted"),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- KOMENTAR ---
              Row(
                children: [
                  const Text("Izinkan Komentar?"),
                  Switch(
                    value: _commentsEnabled,
                    onChanged: (val) => setState(() => _commentsEnabled = val),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- TANGGAL PEMBUATAN ---
              Row(
                children: [
                  const Text("Tanggal Karya: "),
                  Text(_selectedDate == null
                      ? "Belum dipilih"
                      : DateFormat("dd MMMM yyyy").format(_selectedDate!)),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _selectDate,
                    child: const Text("Pilih Tanggal"),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // --- SUBMIT ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt),
                  label: const Text("Simpan Karya"),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
