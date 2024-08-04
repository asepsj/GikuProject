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

    // Define queue numbers and layout
    final List<int> firstRow = [1, 2, 3];
    final List<int> secondRow = [4, 5];

    return Container(
      padding: EdgeInsets.all(w * 0.05),
      child: Column(
        children: [
          // First Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: firstRow.map((nomor) {
              int index = nomor - 1;
              return _buildQueueButton(index, nomor, w);
            }).toList(),
          ),
          SizedBox(height: w * 0.04), // Spacing between rows
          // Second Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: secondRow.map((nomor) {
              int index = nomor - 1;
              return _buildQueueButton(index, nomor, w);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueButton(int index, int nomor, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02), // Adjust spacing between buttons
      child: TextButton(
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
              borderRadius: BorderRadius.all(Radius.circular(width * 0.05)),
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
          padding: EdgeInsets.all(width * 0.04),
          child: Text(
            '$nomor',
            style: TextStyle(
              fontSize: width * 0.045,
              color: widget.isQueueTaken[index] || _currentIndex == index
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
