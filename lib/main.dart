import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_and_vet_admin/add_item_secreen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color primary = Color.fromRGBO(238, 142, 103, 1);
    Color accent = Color.fromRGBO(69, 2, 36, 1);
    return MaterialApp(
      title: 'Pet and Vet Admin',
      theme: ThemeData(
        primaryColor: primary,
        accentColor: accent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Pet and Vet Admin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/img.png',height: 150,width: 150,),

              Container(
                width: 150,
                height: 150,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem(),));
                            },
                          ),
                          Text('Add Item'),
                        ],
                      ),
                    )
                ),
              ),
              // Container(
              //   width: 150,
              //   height: 150,
              //   child: Card(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(25)
              //       ),
              //       child: Center(
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             IconButton(
              //               icon: Icon(Icons.settings),
              //               onPressed: (){},
              //             ),
              //             Text('Manage Items'),
              //           ],
              //         ),
              //       )
              //   ),
              // ),
            ],
          ),
        ));
  }
}
