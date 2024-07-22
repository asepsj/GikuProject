import 'package:flutter/material.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class NomorAntrianView extends StatefulWidget {
  final Function(int) onNomorAntrianChanged;
  final List<bool> isQueueTaken;

  const NomorAntrianView({
    Key? key,
    required this.onNomorAntrianChanged,
    required this.isQueueTaken,
  }) : super(key: key);

  @override
  _NomorAntrianViewState createState() => _NomorAntrianViewState();
}

class _NomorAntrianViewState extends State<NomorAntrianView> {
  int _currentIndex = -1;

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
            onPressed: widget.isQueueTaken[index]
                ? null
                : () {
                    setState(() {
                      _currentIndex = index;
                    });
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
                  if (widget.isQueueTaken[index]) return CustomTheme.greyColor;
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
                  color: widget.isQueueTaken[index] || _currentIndex == index
                      ? Colors.white
                      : Colors.black,
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
