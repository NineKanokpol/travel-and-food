// lib/home_tab.dart

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  // กรณีอยากใช้ TabController ตรง initState (optional)
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    // หากต้องการจับ listener ตอนเปลี่ยนแท็บ ให้เปิดคอมเมนต์โค้ดนี้
    // tabController = TabController(vsync: this, length: 3)
    //   ..addListener(() {
    //     setState(() {});
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // จำนวนแท็บ
      child: Scaffold(
        backgroundColor: const Color(0xFFFFD3D3),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ====== TabBar ======
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  // ถ้าคุณใช้ TabController ของตัวเอง ให้ใส่ controller: tabController,
                  padding: const EdgeInsets.all(8),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    color: const Color(0xFFEE7373),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelColor: Colors.red.shade900,
                  unselectedLabelColor: Colors.black54,
                  tabs: const [
                    Tab(text: 'ฟีดของฉัน'),
                    Tab(text: 'ร้านอาหาร'),
                    Tab(text: 'สถานที่ท่องเที่ยว'),
                  ],
                ),
              ),

              // ====== TabBarView ======
              Expanded(
                child: TabBarView(
                  // ถ้าใช้ TabController: controller: tabController,
                  children: [
                    feedbackTab("ฟีดของฉัน"),
                    feedbackTab("ร้านอาหาร"),
                    feedbackTab("สถานที่ท่องเที่ยว"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feedbackTab(String type) {
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instanceFor(app: Firebase.app())
            .collection('Images')
            .where('header', isEqualTo: type)
            .orderBy('uploaded_at', descending: true)
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        // กำลังโหลด
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // เกิด error ระหว่างดึงข้อมูล
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // ถ้าไม่มีเอกสารเลย
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('ไม่พบโพสต์'),
          );
        }

        // ดึง List ของ QueryDocumentSnapshot
        final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

        return SingleChildScrollView(
          child: Column(
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final dynamic rawBytes = data['image_bytes'];
              Uint8List? bytes;
              if (rawBytes is Uint8List) {
                bytes = rawBytes;
              } else if (rawBytes is List<dynamic>) {
                bytes = Uint8List.fromList(List<int>.from(rawBytes));
              } else if (rawBytes is List<int>) {
                bytes = Uint8List.fromList(rawBytes);
              }

              final String name = data['name'] as String? ?? '';
              final String detail = data['detail'] as String? ?? '';

              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // บรรทัดบน: รูป avatar + ชื่อ (ใช้ name)
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              'https://www.w3schools.com/howto/img_avatar.png',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ถ้ามีภาพให้แสดง
                    if (bytes != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            bytes,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    // แสดงข้อความ detail
                    Text(
                      detail,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // แสดงปุ่มกดถูกใจ-ไม่ถูกใจ (จำนวนกดเป็นตัวเลขสมมติ)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up_alt_rounded,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            // TODO: logic กด like
                          },
                        ),
                        const Text('10'),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            // TODO: logic กด dislike
                          },
                        ),
                        const Text('0'),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
