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
      await user.updatePhotoURL(_profileImageUrl);
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
        Reference storageRef =
            _storage.ref().child('profile_pasiens_images/$fileName');
        await storageRef.putFile(imageFile);
        String imageUrl = await storageRef.getDownloadURL();

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DatabaseReference userRef =
              _databaseReference.child('pasiens/${user.uid}');
          await userRef.update({'profileImageUrl': imageUrl});
          await user.updatePhotoURL(imageUrl);
          setState(() {
            _profileImageUrl = imageUrl;
          });
        }

        WeAlert.close();
        Navigator.of(context).popUntil((route) => route.isFirst);
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
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(w * 0.1),
                  bottomRight: Radius.circular(w * 0.1),
                ),
              ),
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
                    SizedBox(height: w * 0.07),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
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
                              child: _profileImageUrl != null
                                  ? Image.network(
                                      _profileImageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.account_circle,
                                      size: w * 0.3,
                                      color: CustomTheme.blueColor2,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: EdgeInsets.all(w * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(w * 0.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: CustomTheme.blueColor1,
                                  size: w * 0.075,
                                ),
                              ),
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
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nama lengkap',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: w * 0.04),
                      ),
                    ),
                    SizedBox(height: w * 0.03),
                    Text(
                      'Email',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: w * 0.02),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: w * 0.04),
                      ),
                    ),
                    SizedBox(height: w * 0.03),
                    Text(
                      'Alamat',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: w * 0.02),
                    TextFormField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        hintText: 'Alamat',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: w * 0.04),
                      ),
                    ),
                    SizedBox(height: w * 0.03),
                    Text(
                      'Nomor HP',
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: w * 0.02),
                    TextFormField(
                      controller: _nomorHpController,
                      decoration: InputDecoration(
                        hintText: 'Nomor HP',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: w * 0.04),
                      ),
                    ),
                    SizedBox(height: w * 0.1),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateUserData,
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: w * 0.04,
                            color: CustomTheme.blueColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
