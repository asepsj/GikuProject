import 'package:flutter/material.dart';
import 'package:giku/app/theme/custom_theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ButtonDateView extends StatefulWidget {
  const ButtonDateView({super.key});

  @override
  State<ButtonDateView> createState() => _ButtonDateViewState();
}

class _ButtonDateViewState extends State<ButtonDateView> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
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
                width: w * 0.17,
                height: w * 0.17,
                child: TextButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formattedDay,
                        style: TextStyle(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.black.withOpacity(0.4),
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = index;
                    });
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
                        if (_currentIndex == index)
                          return CustomTheme.blueColor1;
                        return Colors.white;
                      },
                    ),
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        // Atur elevasi (depth) button saat ditekan
                        if (states.contains(MaterialState.pressed)) {
                          return 8; // Atur nilai elevasi saat ditekan
                        }
                        return 8; // Atur nilai elevasi normal
                      },
                    ),
                    shadowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        // Atur warna bayangan (shadow color) sesuai keadaan
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
