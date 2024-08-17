import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class PusatBantuanView extends StatefulWidget {
  const PusatBantuanView({super.key});

  @override
  State<PusatBantuanView> createState() => _PusatBantuanViewState();
}

class _PusatBantuanViewState extends State<PusatBantuanView> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(w * 0.1),
            bottomRight: Radius.circular(w * 0.1),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Pusat Bantuan',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: CustomTheme.blueColor1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: EdgeInsets.all(w * 0.05),
        child: ListView(
          children: [
            _helpItem(
              title: 'Bagaimana cara mengganti kata sandi?',
              description:
                  'Anda bisa mengganti kata sandi melalui halaman pengaturan kata sandi di profil Anda.',
            ),
            _helpItem(
              title: 'Bagaimana cara memperbarui profil?',
              description:
                  'Untuk memperbarui informasi profil, buka halaman pengaturan profil di menu profil Anda.',
            ),
            _helpItem(
              title: 'Bagaimana cara keluar dari akun?',
              description:
                  'Anda dapat keluar dari akun Anda dengan menekan tombol "Keluar" di bagian bawah halaman profil.',
            ),
            _helpItem(
              title: 'Bagaimana cara menghubungi dukungan?',
              description:
                  'Jika Anda memerlukan bantuan lebih lanjut, Anda dapat menghubungi dukungan melalui email: asepsj07@gmail.com.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _helpItem({
    required String title,
    required String description,
  }) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: w * 0.045,
              fontWeight: FontWeight.bold,
              color: CustomTheme.blueColor1,
            ),
          ),
          tilePadding: EdgeInsets.symmetric(horizontal: w * 0.04),
          collapsedBackgroundColor: Colors.white,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04, vertical: w * 0.02),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: w * 0.04,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
