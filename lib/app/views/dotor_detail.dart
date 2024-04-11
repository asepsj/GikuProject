import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/theme/custom_theme.dart';
import 'package:giku/app/views/doctor/doctor_view.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          bottom: w * 0.035,
          top: w * 0.02,
          left: w * 0.05,
          right: w * 0.05,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorView()),
            );
          },
          child: Text(
            'Buat Jadwal',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(CustomTheme.blueColor1),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFFF4F4F4).withOpacity(0.5),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
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
              'Dokter',
              style: TextStyle(
                fontSize: w * 0.05,
                fontWeight: FontWeight.normal,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            pinned: false,
            expandedHeight: w * 1,
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: w * 0.25),
              child: FlexibleSpaceBar(
                background: Image(
                  image: AssetImage('assets/other/doktor.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: w,
              height: h,
              padding: EdgeInsets.only(
                  top: w * 0.1, right: w * 0.08, left: w * 0.08),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(w * 0.09),
                    topRight: Radius.circular(w * 0.09)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Dr. Aninda putri',
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Dokter Gigi',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.normal,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: w * 0.03, bottom: w * 0.055),
                    child: Divider(),
                  ),
                  Container(
                    child: Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: w * 0.02),
                    child: Text(
                      'Seorang dokter yang khusus mempelajari ilmu kesehatan dan penyakit pada gigi dan mulut. Seorang dokter gigi memiliki kompetensi atau keahlian dalam mendiagnosis, mengobati, dan memberikan edukasi tentang pencegahan berbagai masalah kesehatan gigi, gusi, dan mulut.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.normal,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: w * 0.02),
                    child: Text(
                      'Seorang dokter yang khusus mempelajari ilmu kesehatan dan penyakit pada gigi dan mulut. Seorang dokter gigi memiliki kompetensi atau keahlian dalam mendiagnosis, mengobati, dan memberikan edukasi tentang pencegahan berbagai masalah kesehatan gigi, gusi, dan mulut.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.normal,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
