import 'dart:convert';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import MediaType
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/constants/constants.dart';
import 'package:taba_app_android/model/user_model.dart';
import 'package:taba_app_android/view/login.dart';
import '../controller/controllers.dart';
import '../widgets/text_field.dart';
import 'bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.item});

  final item;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
    whatsappNumber();
    welfare();

    // dataMaster();
  }

  User? userData;
  var result;
  var regNo = "";

  fetchData() async {
    try {
      result = box.get(0);

      if(result != null){
        userData = User.fromJson(result);
      }
    } catch (error) {
      debugPrint("Hive: $error");
    }
  }

  Future<void> profileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdat = prefs.getString("regNo");
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_by_regno"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "regNo": userdat,
          },
        ),
      );

      if (response.statusCode == 200) {
        var user = jsonDecode(response.body);
        box.put(0, user[0]);
        Map<String, dynamic> profileData = box.get(0);
       userData = User.fromJson(profileData);
        setState(() {});
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? welfareData;
  late var bloodGroup = userData?.bloodGroup ?? "BloodGroup";


  addData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    if (userData != null) {
      User newUser = User(
          id: id,
          regNo: userData?.regNo,
          phone: userData?.phone ?? "",
          firstName: userData?.firstName ?? "",
          lastName: userData?.lastName ?? "",
          email: userData?.email ?? "",
          dob: userData?.dob ?? "",
          address: userData?.address ?? "",
          officeAddress: userData?.officeAddress ?? "",
          clerkName1: userData?.clerkName1 ?? "",
          clerkName2: userData?.clerkName2 ?? "",
          clerkPhone1: userData?.clerkPhone1 ?? "",
          clerkPhone2: userData?.clerkPhone2 ?? "",
          bloodGroup: userData?.bloodGroup ?? "",
          welfareMember: userData?.welfareMember ?? "",
          enrollmentDate: userData?.enrollmentDate ?? "",
          pincode: userData?.pincode ?? "",
          district: userData?.district ?? "",
          state: userData?.state ?? "",
          whatsAppno: userData?.whatsAppno ?? "",
          password: userData?.password,
          isRegisteredUser: true,
          isValidUser: true);

      sendUserDataRequest(newUser);

    } else if (result == null) {
      User newUser = User(
        regNo: widget.item["regNo"],
        phone: _phone.text,
        firstName: _firstname.text,
        lastName: _lastname.text,
        password: widget.item["password"],
        email: _email.text,
        dob: _dob.text,
        address: _address.text,
        officeAddress: _officeaddress.text,
        clerkName1: _clerkname1.text,
        clerkName2: _clerkname2.text,
        clerkPhone1: _clerkphone1.text,
        clerkPhone2: _clerkphone2.text,
        bloodGroup: selectedValue,
        welfareMember: welfareData,
        enrollmentDate: widget.item["enrollmentDate"],
        pincode: _pincode.text,
        district: _district.text,
        state: _state.text,
        whatsAppno: _whatsapp.text,
      );
      print('regNo: ${widget.item["regNo"]}');
      print('phone: ${_phone.text}');
      uploadData(newUser);
    }
  }

  File base64ToFile(String base64String, String fileName) {
    // Decode the base64 string
    List<int> bytes = base64.decode(base64String);

    // Create a temporary file
    File file = File(fileName);

    // Write the bytes to the file
    file.writeAsBytesSync(bytes);

    return file;
  }

  Future<void> uploadData(User userData) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));

    if (_image == null || _image!.path.isEmpty) {
      Future<File> base64ToImage(String base64String) async {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String outputPath = '${documentsDirectory.path}/decoded_image.jpg';

        List<int> imageBytes = base64Decode(base64String);
        File imageFile = File(outputPath);
        await imageFile.writeAsBytes(imageBytes);
        return imageFile;
      }

      String base64String = defaultImage; // Your base64 string
      File decodedImage = await base64ToImage(base64String);
      print(decodedImage.path);
      _image = decodedImage;
      print(_image?.path);
    }

    // Convert User object to a map
    Map<String, dynamic> userMap = userData.toJson();
    // Iterate through the map and set fields in the request
    userMap.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add the image file as a MultipartFile
    File compressedImage = await _compressImage(_image!);
    var imageFile = await http.MultipartFile.fromPath(
        'image', compressedImage.path,
        contentType: MediaType('image', 'jpeg'), filename: "1234.jpeg");
    request.files.add(imageFile);
    // Send the request
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Request sent successfully');
      } else {
        print('Failed to send request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending request: $error');
    }
  }

  Future<void> sendUserDataRequest(User userData) async {
    print("${result["password"]}");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var id = prefs.getString("id");

    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/update/$id'));

    // If _image is null or its path is empty, use a default image

    if (_image == null || _image!.path.isEmpty) {
      Future<File> base64ToImage(String base64String) async {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String outputPath = '${documentsDirectory.path}/decoded_image.jpg';

        List<int> imageBytes = base64Decode(base64String);
        File imageFile = File(outputPath);
        await imageFile.writeAsBytes(imageBytes);
        return imageFile;
      }

      String base64String = result["image"]; // Your base64 string
      File decodedImage = await base64ToImage(base64String);
      _image = decodedImage;
    }

    // Convert User object to a map
    Map<String, dynamic> userMap = userData.toJson();

    // Iterate through the map and set fields in the request
    userMap.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add the image file as a MultipartFile
    File compressedImage = await _compressImage(_image!);
    var imageFile = await http.MultipartFile.fromPath(
      'image',
      compressedImage.path,
      contentType: MediaType('image', 'jpeg'),
      filename: "1234.jpeg",
    );
    request.files.add(imageFile);

    // Print out the data being sent to the API
    print('PUT Request Data:');
    print('URL: ${request.url}');
    print('Fields:');
    request.fields.forEach((key, value) {
      print('$key: $value');
    });
    print('Files:');
    request.files.forEach((file) {
      print('Field name: ${file.field}');
      print('File name: ${file.filename}');
      print('Content type: ${file.contentType}');
      print('File length: ${file.length}');
    });

    // Send the request
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Request sent successfully');
      } else {
        print('Failed to send request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending request: $error');
    }
  }

  Future<File> createTemporaryFileFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final String tempFileName =
        DateTime.now().millisecondsSinceEpoch.toString();
    final File tempFile = File('${Directory.systemTemp.path}/$tempFileName');
    await tempFile.writeAsBytes(bytes, flush: true);
    return tempFile;
  }

  Future<File> _compressImage(File image) async {
    // Read the image file as bytes
    Uint8List imageBytes = await image.readAsBytes();
    // Compress the image with target size (50 KB)
    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      imageBytes,
      minHeight: 800, // Adjust the height and width based on your requirements
      minWidth: 800,
      quality: 50, // Adjust the quality as needed
      format: CompressFormat.jpeg,
    );

    // Create a temporary file and write the compressed bytes to it
    File compressedFile =
        File('${Directory.systemTemp.path}/compressed_image.jpg');
    compressedFile.writeAsBytesSync(compressedBytes);
    return compressedFile;
  }

  final ImagePicker _picker = ImagePicker();

  File? preset = File("assets/images/person.jpg");
  File? _image;
  bool _whatschek = false;

  Future<void> whatsappNumber() async {
    if (userData?.phone != null) {
      if (userData?.phone == userData?.whatsAppno) {
        _whatschek = true;
      } else {
        _whatschek = false;
      }
      setState(() {});
    }
  }

  bool _welfare = false;

  Future<void> welfare() async {
    // if (userData?.welfareMember != null) {
    if (userData?.welfareMember == "yes") {
      _welfare = true;
    } else {
      _welfare = false;
    }
    setState(() {});
  }

  String? selectedValue;

  final _enroll = GlobalKey<FormState>();

  bool isDateValid(String date) {
    try {
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parseStrict(date);
      return parsedDate != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _showImageSourceBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 15);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    setState(() {});
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 15);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    setState(() {});
  }

  late TextEditingController _firstname =
      TextEditingController(text: userData?.firstName ?? "");
  late TextEditingController _lastname =
      TextEditingController(text: userData?.lastName ?? "");
  late TextEditingController _phone =
      TextEditingController(text: userData?.phone ?? "");
  late TextEditingController _whatsapp =
      TextEditingController(text: userData?.whatsAppno ?? "");
  late TextEditingController _address =
      TextEditingController(text: userData?.address ?? "");
  late TextEditingController _officeaddress =
      TextEditingController(text: userData?.officeAddress ?? "");
  late TextEditingController _email =
      TextEditingController(text: userData?.email ?? "");
  late TextEditingController _pincode =
      TextEditingController(text: userData?.pincode ?? "");
  late TextEditingController _state =
      TextEditingController(text: userData?.state ?? "");
  late TextEditingController _district =
      TextEditingController(text: userData?.district);
  late TextEditingController _dob =
      TextEditingController(text: userData?.dob ?? "");
  late TextEditingController _clerkname1 =
      TextEditingController(text: userData?.clerkName1);
  late TextEditingController _clerkphone1 =
      TextEditingController(text: userData?.clerkPhone1);
  late TextEditingController _clerkname2 =
      TextEditingController(text: userData?.clerkName2);
  late TextEditingController _clerkphone2 =
      TextEditingController(text: userData?.clerkPhone2);

  bool isPressed = false;

  void ButtonState() {
    setState(() {
      isPressed = !isPressed;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isPressed = !isPressed;
      });
    });
  }

  double si = 15;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // print("Current image: $_image");

    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(Icons.menu,
                            color: Colors.black, size: 35),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            if (userData?.image != null)
                              CircleAvatar(
                                radius: 55.sp,
                                backgroundColor: Colors.grey.shade400,
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50.sp,
                                    backgroundImage: _image?.path == null
                                        ? MemoryImage(
                                            base64Decode(userData?.image),
                                          )
                                        : Image.file(File(_image!.path)).image
                                    // const AssetImage(
                                    //             "assets/images/man.png") as ImageProvider<Object>?
                                    ),
                              ),
                            if (userData?.image == null)
                              CircleAvatar(
                                radius: 55.sp,
                                backgroundColor: Colors.grey.shade400,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 50.sp,
                                  backgroundImage: _image?.path == null
                                      ? const AssetImage(
                                              "assets/images/man.png")
                                          as ImageProvider<Object>?
                                      : Image.file(File(_image!.path)).image,
                                ),
                              ),
                            Positioned(
                              left: width / 6.sp,
                              top: height * .09.sp,
                              child: IconButton(
                                onPressed: () {
                                  _showImageSourceBottomSheet();
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.grey.shade700,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // ElevatedButton(onPressed: (){
                        //   sendMultipartRequest();
                        // }, child: Text("click")),
                        Column(
                          children: [
                            SizedBox(
                              height: height * .02,
                            ),
                            TextFieldOne(
                              readonly: false,
                              controller: _firstname,
                              hinttext: "Name",
                              onchange: (val) {
                                userData?.firstName = val;

                                print(_firstname.text);
                              },
                              obsecuretxt: false,
                            ),
                            // TextFieldOne(
                            //   readonly: false,
                            //   controller: _lastname,
                            //   hinttext: "Last name",
                            //   onchange: (val) {
                            //     userData?.lastName = val;
                            //   },
                            //   obsecuretxt: false,
                            // ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldOne(
                                      readonly: false,
                                      controller: _phone,
                                      hinttext: "phone",
                                      onchange: (val) {
                                        userData?.phone = val;
                                      }),
                                ),
                                Checkbox(
                                    value: _whatschek,
                                    onChanged: (val) {
                                      _whatschek = !_whatschek;
                                      if (_whatschek == true) {
                                        userData?.whatsAppno = userData?.phone;
                                      }
                                      setState(() {});
                                    }),
                                SizedBox(
                                    width: 35.w,
                                    height: 35.h,
                                    child: Image.asset(
                                        "assets/images/whatsapp.png"))
                              ],
                            ),
                            if (_whatschek == false)
                              TextFieldOne(
                                  readonly: false,
                                  controller: _whatsapp,
                                  hinttext: "Whatsapp number",
                                  onchange: (val) {
                                    userData?.whatsAppno = val;
                                  }),
                            TextFieldOne(
                              readonly: false,
                              hinttext: "DOB",
                              keytype: TextInputType.number,
                              controller: _dob,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'DOB date is required(dd-MM-yyyy)';
                                }

                                if (!isDateValid(value)) {
                                  return 'Invalid date format. Please enter a valid date (dd-MM-yyyy)';
                                }
                                return null; // Return null if the validation is successful
                              },
                              onchange: (value) {
                                List<String> parts = value.split(' ');
                                userData?.dob = parts[0];
                                setState(() {});
                              },
                              obsecuretxt: false,
                              sufix: IconButton(
                                onPressed: () async {
                                  var datePicked = await DatePicker.showSimpleDatePicker(context, firstDate: DateTime(1900), dateFormat: "dd-MM-yyyy", locale: DateTimePickerLocale.en_us, looping: true,);
                                  if (datePicked != null) {
                                    // print(datePicked.toString());
                                    var enrollDate = DateFormat('dd-MM-yyyy').format(datePicked);
                                    _dob.text = enrollDate;
                                    userData?.dob = enrollDate.toString();
                                    setState(() {});
                                  }
                                },
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TextFieldOne(
                                readonly: false,
                                controller: _email,
                                hinttext: "email",
                                onchange: (val) {
                                  userData?.email = val ?? "";
                                }),
                            SizedBox(
                              height: si,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.only(left: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: TextField(
                                  controller: _address,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "address",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  cursorColor: Colors.white,
                                  maxLines: null,
                                  // Allow text to wrap to the next line
                                  onChanged: (val) {
                                    userData?.address = val ?? "";
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: si,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: _officeaddress,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Office address",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                cursorColor: Colors.white,
                                maxLines: null,
                                // Allow text to wrap to the next line
                                onChanged: (val) {
                                  userData?.officeAddress = val ?? "";
                                },
                              ),
                            ),
                            TextFieldOne(
                                readonly: false,
                                controller: _clerkname1,
                                hinttext: "Clerk 1",
                                onchange: (val) {
                                  userData?.clerkName1 = val ?? "";
                                }),
                            TextFieldOne(
                                readonly: false,
                                controller: _clerkphone1,
                                hinttext: "Clerk 1 Phone",
                                onchange: (val) {
                                  userData?.clerkPhone1 = val ?? "";
                                }),
                            TextFieldOne(
                                readonly: false,
                                controller: _clerkname2,
                                hinttext: "Clerk 2",
                                onchange: (val) {
                                  userData?.clerkName2 = val ?? "";
                                }),
                            TextFieldOne(
                                readonly: false,
                                controller: _clerkphone2,
                                hinttext: "Clerk 2 phone",
                                onchange: (val) {
                                  userData?.clerkPhone2 = val ?? "";
                                }),
                            // TextFieldOne(
                            //     controller: _district,
                            //     hinttext: "Blood Group",
                            //     onchange: (val) {}),
                            TextFieldOne(
                                readonly: false,
                                controller: _pincode,
                                hinttext: "pincode",
                                onchange: (val) {
                                  userData?.pincode = val ?? "";
                                }),
                            SizedBox(
                              height: si,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade600),
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: DropdownButton<String>(
                                      hint: Text(
                                        bloodGroup,
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8)),
                                      ),
                                      underline: Container(),
                                      alignment: Alignment.center,
                                      value: selectedValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedValue = newValue!;
                                          userData?.bloodGroup = selectedValue;
                                        });
                                      },
                                      items: <String>[
                                        'A+',
                                        'A-',
                                        'B+',
                                        'B-',
                                        'AB+',
                                        'AB-',
                                        'O+',
                                        'O-',
                                        "N/A",
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: si,
                                ),
                                Text(
                                  "welfare \nmember",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.withOpacity(.8),
                                  ),
                                ),
                                Checkbox(
                                    value: _welfare,
                                    onChanged: (val) {
                                      _welfare = !_welfare;
                                      if (_welfare == true) {
                                        _welfare = true;
                                        userData?.welfareMember = "yes";
                                        welfareData = "yes";
                                        setState(() {
                                          print(welfareData);
                                        });
                                      } else if (_welfare == false) {
                                        _welfare = false;
                                        userData?.welfareMember = "no";
                                        welfareData = "no";
                                        setState(() {
                                          print(welfareData);
                                        });
                                      }
                                      // setState(() {});
                                    })
                              ],
                            ),
                            TextFieldOne(
                                readonly: false,
                                controller: _district,
                                hinttext: "district",
                                onchange: (val) {
                                  userData?.district = val ?? "";
                                }),
                            TextFieldOne(
                                readonly: false,
                                controller: _state,
                                hinttext: "state",
                                onchange: (val) {
                                  userData?.state = val ?? "";
                                }),

                            SizedBox(
                              height: si,
                            ),
                            SizedBox(
                              width: width,
                              height: 60,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var regNo = prefs.getString("regNo");
                                    addData();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => regNo != null
                                              ? BottomNavigationPage()
                                              : Login(),
                                        ));
                                  },
                                  child: Text(
                                    "save",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ],
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
