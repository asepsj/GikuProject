import 'package:flutter/material.dart';
import 'package:giku/app/services/antrian/antrian_services.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:firebase_database/firebase_database.dart';

class NomorAntrianView extends StatefulWidget {
  final Function(int) onNomorAntrianChanged;
  final Map<dynamic, dynamic> doctor;
  final DateTime date;

  const NomorAntrianView({
    Key? key,
    required this.onNomorAntrianChanged,
    required this.doctor,
    required this.date,
  }) : super(key: key);

  @override
  _NomorAntrianViewState createState() => _NomorAntrianViewState();
}

class _NomorAntrianViewState extends State<NomorAntrianView> {
  int _currentIndex = -1;
  List<bool> _isQueueTaken = List.filled(5, false);
  final AntrianService _antrianService = AntrianService();

  @override
  void initState() {
    super.initState();
    _checkQueueNumbers();
  }

  @override
  void didUpdateWidget(covariant NomorAntrianView oldWidget) {
    if (widget.date != oldWidget.date) {
      _checkQueueNumbers();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _checkQueueNumbers() async {
    List<bool> isQueueTaken =
        await _antrianService.checkQueueNumbers(widget.doctor, widget.date);
    if (mounted) {
      setState(() {
        _isQueueTaken = isQueueTaken;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(w * 0.05),
      child: Wrap(
        spacing: w * 0.04,
        runSpacing: w * 0.04,
        children: List.generate(5, (index) {
          int nomor = index + 1;
          return TextButton(
            onPressed: _isQueueTaken[index]
                ? null
                : () {
                    if (mounted) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }
                    widget.onNomorAntrianChanged(nomor);
                  },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(w * 0.05)),
                ),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (_isQueueTaken[index]) return CustomTheme.greyColor;
                  if (_currentIndex == index) return CustomTheme.blueColor1;
                  return Colors.white;
                },
              ),
              elevation: MaterialStateProperty.resolveWith<double>(
                (Set<MaterialState> states) {
                  return 8;
                },
              ),
              shadowColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Colors.black.withOpacity(0.3);
                },
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: Text(
                '$nomor',
                style: TextStyle(
                  fontSize: w * 0.045,
                  color: _isQueueTaken[index] || _currentIndex == index
                      ? Colors
                          .white // Teks menjadi putih jika tombol dinonaktifkan atau aktif
                      : Colors.black, // Teks tetap hitam jika tombol aktif
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
