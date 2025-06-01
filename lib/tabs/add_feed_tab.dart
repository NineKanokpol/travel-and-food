import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:travel_and_food/appManager/image_manager.dart';
import 'package:travel_and_food/widget/loading_widget.dart';

class AddFeedTab extends StatefulWidget {
  const AddFeedTab({super.key});

  @override
  State<AddFeedTab> createState() => _AddFeedTabState();
}

class _AddFeedTabState extends State<AddFeedTab> {
  final List<String> _topics = [
    'ฟีดของฉัน',
    'ร้านอาหาร',
    'สถานที่ท่องเที่ยว',
  ];
  String? _selectedTopic = 'ฟีดของฉัน';
  String imagePath = '';
  String? _downloadUrl;
  bool _uploading = false;
  Uint8List? _pickedBytes;
  String? _docId;

  TextEditingController _detailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _detailController.dispose();
    _nameController.dispose();
    _pickedBytes = null;
    _selectedTopic = null;
    _docId = null;
    imagePath = '';
    super.dispose();
  }

  Future<void> _uploadBytesToFirestore() async {
    checkDataNull();
    if (_pickedBytes == null) return;

    setState(() {
      _uploading = true;
    });

    Uint8List? compressed = await compressImage(_pickedBytes ?? Uint8List(0));

    if (compressed == null) {
      debugPrint('Compression failed');
      return;
    }

    try {
      // Create a new document in "images" collection
      final docRef = await FirebaseFirestore.instanceFor(app: Firebase.app())
          .collection('Images')
          .add({
        'uploaded_at': FieldValue.serverTimestamp(),
        'image_bytes': compressed,
        'header': _selectedTopic,
        'name': _nameController.text,
        'detail': _detailController.text,
      });
      setState(() {
        _docId = docRef.id;
      });
    } catch (e) {
      debugPrint('Error uploading to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed.')),
      );
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  checkDataNull() {
    if ((_selectedTopic?.isEmpty ?? true) &&
        _nameController.text.isEmpty &&
        _detailController.text.isEmpty &&
        imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return false;
    }
  }

  Future<Uint8List?> compressImage(Uint8List data) async {
    return await FlutterImageCompress.compressWithList(
      data,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
      format: CompressFormat.jpeg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // ====== ส่วน gradient ด้านบน ======
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD3D3), Color(0xFFEE7373)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedTopic ?? _topics[0],
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.deepPurple),
                        items: _topics.map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(
                              t,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedTopic = v),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  ImageManager.pickImage().then((image) {
                    if (image.path.isNotEmpty) {
                      setState(() {
                        imagePath = image.path;
                        _pickedBytes = image.readAsBytesSync();
                      });
                    }
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ช่องกรอกชื่อร้านหรือสถานที่
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'ชื่อร้านอาหารหรือชื่อสถานที่...',
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // placeholder รูป
                        Center(
                          child: imagePath.isNotEmpty
                              ? Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.image_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                        ),

                        const SizedBox(height: 32),

                        // ข้อความอธิบาย
                        Text(
                          'แนะนำร้านอาหารที่คุณชื่นชอบหรือสถานที่ที่ท่านอยากจะแนะนำให้เป็นที่รู้จัก ...',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16, bottom: 16),
                          child: TextFormField(
                              controller: _detailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'รายละเอียดของคุณ',
                                hintText: 'เนื้อหาในการรีวิว',
                                prefixIcon: const Icon(Icons.edit),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                // ปุ่ม Cancel
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        imagePath = '';
                        _detailController.clear();
                        _nameController.clear();
                        _selectedTopic = _topics[0];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                // ปุ่ม Post
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _uploadBytesToFirestore();
                      _detailController.clear();
                      _nameController.clear();
                      _pickedBytes = null;
                      _selectedTopic = _topics[0];
                      _docId = '';
                      imagePath = '';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD3D3),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: _uploading ? BaseLoadingAnimation() : Text('Post'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
