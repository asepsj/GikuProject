import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/services/antrian/add_antrian.dart';
import 'package:giku/app/services/antrian/batalkan_antrian.dart';
import 'package:giku/app/services/antrian/detail_antrian.dart';
import 'package:giku/app/views/theme/custom_theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailAntrian extends StatefulWidget {
  final String queueId;
  const DetailAntrian({
    super.key,
    required this.queueId,
  });

  @override
  State<DetailAntrian> createState() => _DetailAntrianState();
}

class _DetailAntrianState extends State<DetailAntrian> {
  final AntrianBatal _antrianBatal = AntrianBatal();
  final AddAntrianService _antrianService = AddAntrianService();
  final AntrianDetail _antrianDetail = AntrianDetail();
  Map<String, dynamic>? _antrian;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQueueDetails();
    initializeDateFormatting('id_ID', null);
  }

  Future<void> _cancelQueue(String queueId) async {
    await _antrianBatal.cancelQueue(context, queueId);
  }

  Future<void> _fetchQueueDetails() async {
    final antrian = await _antrianDetail.fetchQueueDetails(widget.queueId);
    if (mounted) {
      setState(() {
        _antrian = antrian;
        isLoading = false;
      });
    }
  }

  String _toTitleCase(String str) {
    if (str.isEmpty) return str;
    return str.split(' ').map((word) {
      return toBeginningOfSentenceCase(word) ?? '';
    }).join(' ');
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFB3E5FC),
        body: Center(
          child: SpinKitCircle(
            color: CustomTheme.blueColor1,
            size: w * 0.2,
          ),
        ),
      );
    }

    if (_antrian == null) {
      return Scaffold(
        backgroundColor: Color(0xFFB3E5FC),
        body: Center(
          child: Text('No data available for this queue.'),
        ),
      );
    }

    bool showCancelButton = _antrian!['status'] == 'dibuat';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.only(left: w * 0.07),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: w * 0.05,
            ),
          ),
        ),
        title: Text(
          'Detail Antrian',
          style: TextStyle(
            fontSize: w * 0.05,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: 32),
        padding: EdgeInsets.all(w * 0.05),
        decoration: BoxDecoration(
          color: CustomTheme.blueColor2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nama Pasien',
              style: TextStyle(
                fontSize: w * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.04),
            Text(
              _toTitleCase(_antrian!['pasien_name'] ?? 'Name not available'),
              style: TextStyle(
                fontSize: w * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.04),
            Text(
              _formatDate(_antrian!['date']),
              style: TextStyle(
                fontSize: w * 0.04,
                color: Colors.white,
              ),
            ),
            SizedBox(height: w * 0.03),
            Text(
              'Dr. ${_antrian!['doctor_name']}',
              style: TextStyle(
                fontSize: w * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.03),
            Divider(
              color: Colors.white,
              height: w * 0.05,
              thickness: w * 0.005,
            ),
            SizedBox(height: w * 0.03),
            Text(
              'Nomor Antrian',
              style: TextStyle(
                fontSize: w * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '00${_antrian!['nomor_antrian']}' ?? 'Nomor not available',
              style: TextStyle(
                fontSize: w * 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Status antrian (${_antrian!['status']})',
              style: TextStyle(
                fontSize: w * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: w * 0.01),
            if (showCancelButton)
              ElevatedButton(
                onPressed: () {
                  _cancelQueue(widget.queueId);
                },
                child: Text(
                  'Batalkan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
