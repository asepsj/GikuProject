import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giku/app/theme/custom_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.05,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: CustomTheme.blueColor1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: w,
                height: h * 0.25,
                decoration: BoxDecoration(
                  color: CustomTheme.blueColor1,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(w * 0.1),
                    bottomRight: Radius.circular(w * 0.1),
                  ),
                ),
              ),
            ),
            Positioned(
              top: w * 0.2,
              left: (MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 0.9) /
                  2,
              child: Material(
                elevation: w * 0.05,
                shadowColor: CustomTheme.blueColor1.withOpacity(0.5),
                borderRadius: BorderRadius.circular(w * 0.1),
                child: Container(
                  width: w * 0.9,
                  height: w * 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(w * 0.05)),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: w * 0.3),
                    child: Column(
                      children: [
                        Container(
                          child: _itemList(
                              title: 'Pengaturan profil',
                              icon: Icon(MdiIcons.squareEditOutline)),
                        ),
                        Container(
                          child: _itemList(
                              title: 'Riwayat antrian',
                              icon: Icon(MdiIcons.fileDocumentOutline)),
                        ),
                        Container(
                          child: _itemList(
                              title: 'Pusat bantuan',
                              icon: Icon(MdiIcons.alertCircleOutline)),
                        ),
                        Container(
                          width: w * 0.5,
                          padding: EdgeInsets.only(top: w * 0.04),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Keluar',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.04,
                                    fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  CustomTheme.lightGreyColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: w * 0.03,
              left: (w - w * 0.5) / 2,
              child: Container(
                width: w * 0.5,
                child: Column(
                  children: [
                    Container(
                      width: w * 0.3,
                      height: w * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.5),
                        color: CustomTheme.blueColor4,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.5),
                        child: Image.asset(
                          'assets/other/doktor.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: w * 0.03),
                    Container(
                      child: Text(
                        'Iriana diana lesmana',
                        style: TextStyle(
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _itemList extends StatelessWidget {
  final String title;
  final Icon icon;
  // final VoidCallback page;

  const _itemList({
    super.key,
    required this.title,
    required this.icon,
    // required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: w * 0.03,
          ),
          width: w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: CustomTheme.blueColor4,
                    radius: w * 0.06,
                    child: CircleAvatar(
                      child: Icon(
                        icon.icon,
                        size: w * 0.05,
                        color: CustomTheme.blueColor1,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: w * 0.05),
                    width: w * 0.45,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: w * 0.1,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: w * 0.03,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
