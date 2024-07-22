import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giku/app/views/alert/we_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:giku/app/views/components/input_component.dart';
import 'package:giku/app/views/theme/custom_theme.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorHpController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _userDataSubscription;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          _databaseReference.child('pasiens/${user.uid}');

      _userDataSubscription = userRef.onValue.listen((DatabaseEvent event) {
        if (mounted) {
          final userData = event.snapshot.value as Map?;
          setState(() {
            _nameController.text = userData?['displayName'] ?? '';
            _emailController.text = userData?['email'] ?? '';
            _alamatController.text = userData?['alamat'] ?? '';
            _nomorHpController.text = userData?['phoneNumber'] ?? '';
            _profileImageUrl = userData?['profileImageUrl'];
          });
          isLoading = false;
        }
      });
    }
  }

  Future<void> _updateUserData() async {
    WeAlert.showLoading();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          _databaseReference.child('pasiens/${user.uid}');
      await userRef.update({
        'displayName': _nameController.text,
        'email': _emailController.text,
        'alamat': _alamatController.text,
        'phoneNumber': _nomorHpController.text,
        'profileImageUrl': _profileImageUrl,
      });
      await user.updateDisplayName(_nameController.text);
      WeAlert.close();
      WeAlert.success(
        description: 'Berhasil mengupdate profile',
        onTap: () {
          WeAlert.close();
        },
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      WeAlert.showLoading();
      try {
        String fileName = DateTime.now().toIso8601String();
        Reference storageRef = _storage.ref().child('profile_images/$fileName');
        await storageRef.putFile(imageFile);
        String imageUrl = await storageRef.getDownloadURL();

        setState(() {
          _profileImageUrl = imageUrl;
          WeAlert.close();
        });
      } catch (e) {
        WeAlert.close();
        print("Error uploading image: $e");
      }
    }
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return isLoading
        ? Center(
            child: AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Center(
                child: SpinKitCircle(
                  color: CustomTheme.blueColor1,
                  size: w * 0.2,
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'Edit Profil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: CustomTheme.blueColor1,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : AssetImage('assets/other/doktor.png')
                                    as ImageProvider,
                          ),
                          SizedBox(height: w * 0.03),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('Ubah Foto'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  CustomTheme.lightGreyColor),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: w * 0.03),
                    Text(
                      'Nama',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: w * 0.02),
                    InputComponent(
                      controller: _nameController,
                      hintText: 'Nama lengkap',
                      labelText: 'Nama Lengkap',
                    ),
                    SizedBox(height: w * 0.03),
                    Text(
                      'Email',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: w * 0.02),
                    InputComponent(
                      controller: _emailController,
                      hintText: 'Email',
                      labelText: 'Email',
                    ),
                    SizedBox(height: w * 0.03),
                    Text(
                      'Alamat',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: w * 0.02),
                    InputComponent(
                      controller: _alamatController,
                      hintText: 'Alamat',
                      labelText: 'Alamat',
                    ),
                    SizedBox(height: w * 0.03),
                    Text(
                      'Nomor HP',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: w * 0.02),
                    InputComponent(
                      labelText: 'Nomor HP',
                      hintText: 'Nomor HP',
                      controller: _nomorHpController,
                    ),
                    SizedBox(height: w * 0.03),
                    SizedBox(height: w * 0.05),
                    ElevatedButton(
                      onPressed: _updateUserData,
                      child: Text('Simpan',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            CustomTheme.lightGreyColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
