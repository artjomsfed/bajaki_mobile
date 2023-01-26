import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Application extends StatefulWidget {

  final String happeningId;

  const Application({required this.happeningId});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  static const List<String> genders = <String>['Male', 'Female'];
  //TODO: receive from main app
  static const List<String> fieldsOfWork = <String>['IT', 'Medicine'];
  static const List<String> knownByOptions = <String>['Friends', 'Social networks', 'Others', 'School'];
  static const List<String> accomodationOptions = <String>['Without accomodation', 'Single', 'Shared', 'Couple'];

  //TODO: candidate for NewApplication class
  String? firstName;
  String? lastName;
  String? email;
  String? cellPhone;
  String? gender;
  String? country;
  DateTime? birthDate;
  String? facebookLink;
  List<String> languages = [];
  String? jobTitle;
  String? companyName;
  String? fieldOfWork;
  String? knownBy;
  String? dietaryRequirements;
  String? accomodationOption;
  String? accomodationComments;
  bool allowToShareData = false;

  File? avatar;


  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bajaki'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildFirstName(),
                buildLastName(),
                buildEmail(),
                buildCellPhone(),
                SizedBox(height: 10),
                Text('Gender'),
                buildGenderSelect(),
                buildCountry(),
                buildDateTimePicker(),
                buildLinkToSocialMedia(),
                buildLanguageSelect(),
                buildJobTitle(),
                buildCompanyName(),
                SizedBox(height: 10),
                Text('Field of work'),
                buildFieldOfWorkSelect(),
                SizedBox(height: 10),
                Text('How did you hear about Baltic Jewish Network'),
                buildKnownBySelect(),
                buildDietaryRequirements(),
                SizedBox(height: 10),
                Text('Accomodation options'),
                buildAccomodationOptionsSelect(),
                buildAccomodationComments(),
                SizedBox(height: 10),
                buildAllowToShareCheckbox(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showImagePickingDialog();
                      },
                      child: Text('Upload Photo'),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          formKey.currentState!.save();
                          submitForm();
                        },
                        child: Text('Submit')
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      avatar = File(img!.path);
    });
  }

  void showImagePickingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildFirstName() {
    return TextFormField(
      initialValue: firstName,
      decoration: InputDecoration(
        label: Text('First Name'),
      ),
      onSaved: (newValue) {
        firstName = newValue;
      },
    );
  }

  Widget buildLastName() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Last Name'),
      ),
      onSaved: (newValue) {
        lastName = newValue;
      },
    );
  }

  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Email'),
      ),
      onSaved: (newValue) {
        email = newValue;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }

        return null;
      },
    );
  }

  Widget buildCellPhone() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Cell Phone'),
      ),
      onSaved: (newValue) {
        cellPhone = newValue;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Cell Phone is required';
        }

        return null;
      },
    );
  }

  Widget buildCountry() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Country of living'),
      ),
      onSaved: (newValue) {
        country = newValue;
      },
    );
  }

  Widget buildGenderSelect() {
    return DropdownButtonFormField(
      isExpanded: true,
      value: gender,
      hint: Text('Select gender'),
      icon: const Icon(Icons.arrow_downward),
      items: genders.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          gender = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Gender is required';
        }

        return null;
      },
    );
  }

  DateTimePicker buildDateTimePicker() {
    return DateTimePicker(
      type: DateTimePickerType.date,
      initialValue: '',
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      dateLabelText: 'Birth date',
      onSaved: (dateTimeString) {
        if (dateTimeString == null) {
          return;
        }

        DateTime date = DateTime.parse(dateTimeString);
        birthDate = date;
      },
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Birth date is required';
        }

        return null;
      },
    );
  }

  Widget buildLinkToSocialMedia() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Link to social media'),
      ),
      onSaved: (newValue) {
        facebookLink = newValue;
      },
    );
  }

  Widget buildJobTitle() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Job title'),
      ),
      onSaved: (newValue) {
        jobTitle = newValue;
      },
    );
  }

  Widget buildCompanyName() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Company name'),
      ),
      onSaved: (newValue) {
        companyName = newValue;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Company name is required';
        }

        return null;
      },
    );
  }

  MultiSelectDialogField buildLanguageSelect() {
    return MultiSelectDialogField(
      buttonText: Text('Languages'),
      title: Text('Languages'),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.5,
              )
          )
      ),
      items: [
        MultiSelectItem('English', 'English'),
        MultiSelectItem('Estonian', 'Estonian'),
        MultiSelectItem('Latvian', 'Latvian'),
        MultiSelectItem('Lithuanian', 'Lithuanian'),
        MultiSelectItem('Russian', 'Russian'),
        MultiSelectItem('Spanish', 'Spanish'),
      ],
      listType: MultiSelectListType.LIST,
      onConfirm: (values) {
        languages = values.map((value) => value.toString()).toList();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'At least one language is required';
        }

        return null;
      },
    );
  }

  Widget buildFieldOfWorkSelect() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      hint: Text('Select field of work'),
      value: fieldOfWork,
      icon: const Icon(Icons.arrow_downward),
      onChanged: (String? value) {
        setState(() {
          fieldOfWork = value!;
        });
      },
      items: fieldsOfWork.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field of work is required';
        }

        return null;
      },
    );
  }

  Widget buildKnownBySelect() {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text('Select option'),
      value: knownBy,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      // style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          knownBy = value!;
        });
      },
      items: knownByOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildDietaryRequirements() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Dietary requirements'),
      ),
      onSaved: (newValue) {
        dietaryRequirements = newValue;
      },
    );
  }

  Widget buildAccomodationOptionsSelect() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      hint: Text('Select option'),
      value: accomodationOption,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (String? value) {
        setState(() {
          accomodationOption = value!;
        });
      },
      items: accomodationOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Accomodation option is required';
        }

        return null;
      },
    );
  }

  Widget buildAccomodationComments() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text('Accomodation comments'),
      ),
      onSaved: (newValue) {
        accomodationComments = newValue;
      },
    );
  }

  Widget buildAllowToShareCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: allowToShareData,
          onChanged: (value) => setState(() {
            allowToShareData = value ?? false;
          }),
        ),
        Flexible(
          child: Text('Allow to share your data for our networking purposes',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void submitForm() async {

    var uri = Uri.parse('http://10.0.2.2:26000/api/apply/event/${widget.happeningId}');
    var request = http.MultipartRequest("POST", uri);

    request.fields['new_application_api[attender][firstName]'] = firstName ?? '';
    request.fields['new_application_api[attender][lastName]'] = lastName ?? '';
    request.fields['new_application_api[attender][email]'] = email ?? '';
    request.fields['new_application_api[attender][phone]'] = cellPhone ?? '';
    String genderParam = gender == 'Male' ? '1' : '2';
    request.fields['new_application_api[attender][gender]'] = genderParam;
    if (allowToShareData) {
      request.fields['new_application_api[attender][allowToShare]'] = '1';
    }
    request.fields['new_application_api[attender][countryOfLiving]'] = country ?? '';
    //TODO: implement proper birt date processing
    request.fields['new_application_api[attender][dateOfBirth][month]'] = birthDate!.month.toString();
    request.fields['new_application_api[attender][dateOfBirth][day]'] = birthDate!.day.toString();;
    request.fields['new_application_api[attender][dateOfBirth][year]'] = birthDate!.year.toString();;
    request.fields['new_application_api[attender][facebookLink]'] = facebookLink ?? '';
    //Parse languages
    if (languages.isEmpty) {
      request.fields['new_application_api[attender][languages]'] = '';
    } else {
      for (String language in languages) {
        int index = languages.indexOf(language);
        request.fields['new_application_api[attender][languages][$index]'] = language;
      }
    }

    request.fields['new_application_api[attender][jobTitle]'] = jobTitle ?? '';
    request.fields['new_application_api[attender][company]'] = companyName ?? '';
    //TODO: implement mapping between values in mobile form and in main app
    request.fields['new_application_api[attender][fieldOfWork]'] = "1";
    //TODO: implement mapping between values in mobile form and in main app
    request.fields['new_application_api[attender][knowFrom]'] = "";
    request.fields['new_application_api[dietaryRequirements]'] = dietaryRequirements ?? '';
    request.fields['new_application_api[accomodation]'] = accomodationOption ?? '';
    request.fields['new_application_api[accomodationComments]'] = accomodationComments ?? '';
    request.fields['new_application_api[save]'] = "";

    //Add avatar
    if (avatar != null) {
      var multipartFile = await http.MultipartFile.fromPath('new_application_api[attender][avatar]', avatar!.path);
      request.files.add(multipartFile);
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
  }
}