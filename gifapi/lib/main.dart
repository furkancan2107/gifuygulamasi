import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gif GETİR',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Gif Getir'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> gifUrls = [];
  final MyController = TextEditingController();
  void getGif(String word) async {
    var data = await http.get(
        "https://api.tenor.com/v1/search?q=$word&key=LIVDSRZULELA&limit=8");
    var dataParsed = jsonDecode(data.body);
    gifUrls.clear();

    for (int i = 0; i < 8; i++) {
      dataParsed['results'][i]['media'][0]['tinygif']['url'];
      gifUrls.add(dataParsed["results"][i]["media"][0]["tinygif"]["url"]);
    }
    setState(() {});
  }

  @override
  void initState() {
    getGif("batman");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gif Getir"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: MyController,
              decoration: InputDecoration(
                hintText: "gif gir",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () {
                  getGif(MyController.text);
                },
                child: Text("gifleri getir")),
            gifUrls.isEmpty
                ? CircularProgressIndicator()
                : Expanded(
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.separated(
                          itemBuilder: (_, int index) {
                            return Container(
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(gifUrls[index]),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) {
                            return Divider(
                              color: Colors.blue,
                              thickness: 4,
                              height: 4,
                            );
                          },
                          itemCount: 8,
                        )),
                  ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
