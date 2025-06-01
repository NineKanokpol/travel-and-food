import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({super.key});

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ดึง SafeArea มาใช้เพื่อกัน notch / status bar
      body: SafeArea(
        child: Container(
          // background gradient
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFD3D3),
                Color(0xFFEE7373),
              ],
            ),
          ),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ชื่อใน pill-shape
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black26),
                ),
                child: const Text(
                  'นายอนันต์ปัตร ชัยเย',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // รูปวงกลม
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      NetworkImage('https://cdn.britannica.com/70/234870-050-D4D024BB/Orange-colored-cat-yawns-displaying-teeth.jpg'),
                ),
              ),

              const SizedBox(height: 48),

              // ปุ่มแรก
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: รายงานปัญหา
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: const Text(
                      'รายงานปัญหา',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ปุ่มที่สอง
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      canLaunchUrl(Uri(scheme: 'tel', path: '1669')).then((bool result) {
                        if (result) {
                          launchUrl(Uri(scheme: 'tel', path: '1669'));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ไม่สามารถโทรออกได้'),
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: const Text(
                      'ติดต่อเรา',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
