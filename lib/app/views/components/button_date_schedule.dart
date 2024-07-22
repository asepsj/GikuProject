import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giku/app/services/antrian/antrian_services.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_database/firebase_database.dart';

class ButtonDateView extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Map<dynamic, dynamic> doctor;

  const ButtonDateView(
      {required this.onDateSelected, required this.doctor, Key? key})
      : super(key: key);

  @override
  State<ButtonDateView> createState() => _ButtonDateViewState();
}

class _ButtonDateViewState extends State<ButtonDateView> {
  int _currentIndex = 0;
  List<bool> _isQueueFull = List.filled(7, false);
  final AntrianService _antrianService = AntrianService();
  DatabaseReference? _queueRef;
  late StreamSubscription<DatabaseEvent>? _queueListener;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _checkQueues();
    _addQueueListener();
  }

  Future<void> _checkQueues() async {
    DateTime currentDate = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = currentDate.add(Duration(days: i));
      bool isFull =
          await _antrianService.isQueueFull(widget.doctor['key'], date);
      if (mounted) {
        setState(() {
          _isQueueFull[i] = isFull;
        });
      }
    }
  }

  void _addQueueListener() {
    _queueRef = FirebaseDatabase.instance.ref().child('antrians');
    _queueListener = _queueRef?.onValue.listen((event) {
      _checkQueues();
    });
  }

  @override
  void dispose() {
    _queueListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(top: w * 0.01),
      height: h * 0.13,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(7, (index) {
              DateTime currentDate = DateTime.now();
              DateTime date = currentDate.add(Duration(days: index));
              String formattedDay = DateFormat.EEEE('id_ID').format(date);
              formattedDay = formattedDay.substring(0, 3);
              String formattedDate = DateFormat('dd').format(date);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: w * 0.04),
                width: w * 0.19,
                height: w * 0.19,
                child: TextButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: _isQueueFull[index]
                              ? Colors.white
                              : _currentIndex == index
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formattedDay,
                        style: TextStyle(
                          color: _isQueueFull[index]
                              ? Colors.white
                              : _currentIndex == index
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.4),
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  onPressed: _isQueueFull[index]
                      ? null
                      : () {
                          setState(() {
                            _currentIndex = index;
                          });
                          widget.onDateSelected(date);
                        },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(w * 0.05)),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (_isQueueFull[index]) return CustomTheme.greyColor;
                        if (_currentIndex == index)
                          return CustomTheme.blueColor1;
                        return Colors.white;
                      },
                    ),
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return 8;
                        }
                        return 8;
                      },
                    ),
                    shadowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black.withOpacity(0.3);
                        }
                        return Colors.black.withOpacity(0.3);
                      },
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
