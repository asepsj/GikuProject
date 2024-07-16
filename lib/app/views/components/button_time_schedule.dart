import 'package:flutter/material.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class ButtonTimeSchedule extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;

  const ButtonTimeSchedule({required this.onTimeSelected, super.key});

  @override
  State<ButtonTimeSchedule> createState() => _ButtonTimeScheduleState();
}

class _ButtonTimeScheduleState extends State<ButtonTimeSchedule> {
  final List<TimeOfDay> slots = [
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
  ];

  TimeOfDay selectedSlot = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 3.0,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedSlot = slot;
              });
              widget.onTimeSelected(slot);
            },
            style: ElevatedButton.styleFrom(
              elevation: w * 0.02,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.3),
              backgroundColor:
                  selectedSlot == slot ? CustomTheme.blueColor1 : Colors.white,
            ),
            child: Text(
              '${slot.hour}:${slot.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                  color: selectedSlot == slot ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
