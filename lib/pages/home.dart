import 'dart:convert';
import 'package:bajaki_mobile/entity/happening.dart';
import 'package:bajaki_mobile/pages/application_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<List<Happening>>? happenings;
  int? selectedHappeningId;

  final formKey = GlobalKey<FormState>();


  //TODO: add error handling
  @override
  void initState() {
    happenings = loadHappenings();
  }

  Future<List<Happening>> loadHappenings() async {
    String apiUrl = dotenv.get('API_URL');
    final response = await http.get(Uri.parse('$apiUrl/api/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load events');
    }

    var decodedResponse = jsonDecode(response.body);
    if (decodedResponse['code'] != 0) {
      throw Exception('Failed to load events');
    }

    List<Happening> happenings = [];
    try {
      Map<String, dynamic> eventMap = decodedResponse['data']['events'];
      eventMap.forEach((key, value) {
        Happening happening = Happening.fromJson(value);
        happenings.add(happening);
      });
    } catch (e) {
      throw Exception('Failed to load events');
    }

    return happenings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: happenings,
      builder: (context, data) {
        if (data.hasData) {
          return buildHomePage(data.data);
        } else {
          return buildLoadingIndicator();
        }
      }
    );
  }
  
  Widget buildHomePage(List<Happening>? loadedHappenings) {
    if (loadedHappenings == null) {
      throw Exception('Failed to load events');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bajaki'),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildHappeningsDropdown(loadedHappenings),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Application(happeningId: selectedHappeningId.toString()),
                              ),
                            );
                          },
                          child: Text('Apply')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bajaki'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildHappeningsDropdown(List<Happening> loadedHappenings) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      hint: Text('Select happening'),
      value: selectedHappeningId?.toString(),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (String? value) {
        setState(() {
          selectedHappeningId = int.parse(value!);
        });
      },
      items: loadedHappenings.map<DropdownMenuItem<String>>((Happening happening) {
        return DropdownMenuItem<String>(
          value: happening.id.toString(),
          child: Text(
            happening.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Select a happening';
        }

        return null;
      },
    );
  }
}
