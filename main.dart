import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:async/async.dart';
import 'dart:async';
import 'package:flutter_dialogflow_v2/flutter_dialogflow_v2.dart' as df;
import 'package:geocoder/geocoder.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title:'OTA',
    home: MyHomePage(title: 'OTA'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white70,),),backgroundColor: Colors.green,),
      body: Center(child: Image(image: AssetImage('assets/ota.jpg'),),),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Main Menu',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red,fontSize: 20.0),),
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
            ),
            ListTile(
              title: Text('Notification Section',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,fontSize:15.0),),
              onTap: () {

                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ListObj()));
              },
            ),

            ListTile(
              title: Text('Contact Section',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,fontSize:15.0),),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatBot(
                  title: 'Virtual Assistant',
                )));
              },
            ),
            ListTile(
              title: Text('Maps',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,fontSize:15.0),),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MapSample(lat1:33.6938118,lat2:73.0651511,
                )));
              },
            ),

          ],
        ),
      ),

    );
  }
}




class ListObj extends StatefulWidget {
  @override
  _ListObjState createState() => _ListObjState();
}

class _ListObjState extends State<ListObj> {
  @override
  Widget build(BuildContext context) {
    CollectionReference objects = FirebaseFirestore.instance.collection('objects');

    return Scaffold(
      appBar: AppBar(
        title: Text("Objects Received",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.greenAccent,fontSize:15.0),),
        backgroundColor: Colors.red,


      ),
      body: StreamBuilder<QuerySnapshot>(
       stream: objects.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(document.data()['Name'],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,fontSize:15.0),),
                subtitle: new Text(
                    document.data()['Status'],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,fontSize:15.0),),
                
                onTap: (){

                  String accuracy=document.data()['Accuracy'].toString();

                  print(accuracy);
                  String location=document.data()['Location'];
                  print(location);
                  String total=document.data()['TotalObj'].toString();
                  print(total);
                  String threatlevel=document.data()['Threat Level'].toString();
                  print(threatlevel);
                  String objno=document.data()['ObjNo'].toString();
                  print(objno);
                  String Link="";
                  if(objno=="0"){
                    Link="images/object1.jpg";
                  }
                  else if(objno=="1"){
                    Link="images/object2.jpg";
                  }
                  else if(objno=="2"){
                    Link="images/object3.jpg";
                  }
                  else if(objno=="3"){
                    Link="images/object4.jpg";
                  }
                  else if(objno=="4"){
                    Link="images/object5.jpg";
                  }
                  else if(objno=="5"){
                    Link="images/object6.jpg";
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(Accuracy: accuracy,Location: location,ThreatLevel: threatlevel,TotalObj: total,ObjNo: objno,link: Link,)));
                },

              );

            }).toList(),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        label: Text('Images'),
        icon: Icon(Icons.image_rounded),
        backgroundColor: Colors.pink,
        onPressed: (){
          FirebaseFirestore.instance.collection('objects').get().then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              print(doc.data()["Name"]);
              print(doc.data()["Location"]);
              print(doc.data()["Accuracy"]);
              print(doc.data()["Status"]);
              print(doc.data()["Threat Level"]);
              print(doc.data()["TotalObj"]);

            })
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultPhoto()));
        },
      ),
    );
  }
}
class Details extends StatefulWidget {
  final String Accuracy;
  final String Location;
  final String ThreatLevel;
  final String TotalObj;
  final String ObjNo;
  final String link;
  Details({this.Accuracy,this.Location,this.ThreatLevel,this.TotalObj,this.ObjNo,this.link});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

Future<Widget> _getImage(BuildContext context,String imageName) async{
Image image;
await FireStorageService.loadImage(context, imageName).then((value){
  image=Image.network(value.toString(),fit: BoxFit.scaleDown,);
});
return image;
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Details",

      home: Scaffold(
        appBar: AppBar(
          title: Text("Details",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green,fontSize:20.0),),
          backgroundColor: Colors.red[900],
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.message_sharp,color: Colors.lightBlue,),
              title: Text('Object Number',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,),),
              subtitle: Text(widget.ObjNo,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green,),),


            ),
            ListTile(
              leading: Icon(Icons.message_sharp,color: Colors.lightBlue,),
              title: Text('Accuracy',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,),),
              subtitle: Text(widget.Accuracy,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green,),),

            ),
            ListTile(
              leading: Icon(Icons.message_sharp,color: Colors.lightBlue,),
              title: Text('Location',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,),),
              subtitle: Text(widget.Location,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green,),),
            ),
            ListTile(
              leading: Icon(Icons.warning_rounded,color: Colors.red[int.parse(widget.ThreatLevel)*200],),
              title: Text('Threat Level',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red[int.parse(widget.ThreatLevel)*200] ,),),
              subtitle: Text(widget.ThreatLevel,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red[int.parse(widget.ThreatLevel)*200] ,),),


            ),
            ListTile(
              leading: Icon(Icons.message_sharp,color: Colors.lightBlue,),
              title: Text('Total Objects',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue,),),
              subtitle: Text(widget.TotalObj,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green,),),

            ),

            FutureBuilder(

              future: _getImage(context, widget.link),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  return Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.width/1.2,
                    child: snapshot.data,
                  );
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.width/1.2,
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),

          ],

        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Eliminate'),
          icon: Icon(Icons.all_out),
          backgroundColor: Colors.lightGreen,
          onPressed: (){
            print(widget.ObjNo);
            String objid='';
            if (widget.ObjNo=="0"){
              objid= 'uve7r77st0Q25jMiXOxy';


            }
            else if (widget.ObjNo=="1"){
              objid= 'vbD8BD6Rrz3Bv981U1gl';

            }
            else if (widget.ObjNo=="2"){
              objid='ObzbMhjjqxstZKrussMc';

            }
            else if (widget.ObjNo=="3"){
              objid='';

            }
            else if (widget.ObjNo=="4"){
              objid='';

            }
            else if (widget.ObjNo=="5"){
              objid='';

            }
            else if (widget.ObjNo=="6"){
              objid='';

            }
            else if (widget.ObjNo=="7"){
              objid='';

            }
            CollectionReference users = FirebaseFirestore.instance.collection('objects');


            users
                .doc(objid)
                .update({'Status': 'Eliminated'})
                .then((value) => print("Status Updated"))
                .catchError((error) => print("Failed to update : $error"));





          },
        ),
      ),
    );
  }
}



class FireStorageService extends ChangeNotifier{
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context,String Image)async{
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();

  }
}

class ResultPhoto extends StatefulWidget {
  @override
  _ResultPhotoState createState() => _ResultPhotoState();
}

class _ResultPhotoState extends State<ResultPhoto> {
  Future<Widget> _getImage(BuildContext context,String imageName) async{
    Image image;
    await FireStorageService.loadImage(context, imageName).then((value){
      image=Image.network(value.toString(),fit: BoxFit.scaleDown,);
    });
    return image;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"Full Image",

      home: Scaffold(
         appBar: AppBar(title: Text("Full IMAGE",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.greenAccent,fontSize:15.0),),backgroundColor: Colors.red,),
        body: FutureBuilder(
        future: _getImage(context, "images/fullresult.jpg"),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              width: MediaQuery.of(context).size.width/1.2,
              height: MediaQuery.of(context).size.width/1.2,
              child: snapshot.data,
            );
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Container(
              width: MediaQuery.of(context).size.width/1.2,
              height: MediaQuery.of(context).size.width/1.2,
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Threats Pics'),
          icon: Icon(Icons.warning),
          backgroundColor: Colors.red,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ThreatPhotos()));
          },

        ),
      ),
    );
  }
}
class ThreatPhotos extends StatefulWidget {
  @override
  _ThreatPhotosState createState() => _ThreatPhotosState();
}

class _ThreatPhotosState extends State<ThreatPhotos> {
  Future<Widget> _getImage(BuildContext context,String imageName) async{
    Image image;
    await FireStorageService.loadImage(context, imageName).then((value){
      image=Image.network(value.toString(),fit: BoxFit.scaleDown,);
    });
    return image;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Threat pics details",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.greenAccent,fontSize:15.0),),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder(
              future: _getImage(context, "images/threatcheck1.jpg"),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  return Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.width/1.2,
                    child: snapshot.data,
                  );
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.width/1.2,
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),
            FutureBuilder(
              future: _getImage(context, "images/threatcheck2.jpg"),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  return Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.width/1.2,
                    child: snapshot.data,
                  );
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: MediaQuery.of(context).size.width/1.2,
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),

          ],
        ),
      ),
    );
  }
}



class MapSample extends StatefulWidget {
  double lat1=37.42796133580664;
  double lat2=-122.085749655962;
  MapSample({this.lat1,this.lat2});
  @override

  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  static double lt1;
  static double lt2;
  void initState() {
    lt1=widget.lat1;
    lt2=widget.lat2;
    super.initState();
  }
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(

    target: LatLng(lt1,lt2),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(lt1,lt2),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Zoom inside!'),
        icon: Icon(Icons.zoom_in),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}


class ChatBot extends StatefulWidget {
  ChatBot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatBotState createState() => new _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void response(query) async {
    _textController.clear();
    df.AuthGoogle authGoogle =
    await df.AuthGoogle(fileJson: 'assets/services.json').build();
    df.Dialogflow dialogflow =
    df.Dialogflow(authGoogle: authGoogle, sessionId: '123456');
    df.DetectIntentResponse response = await dialogflow.detectIntentFromText(query,"id");
    ChatMessage message = new ChatMessage(
      text: response.queryResult.fulfillmentText,
      name: 'Bot',
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: 'Humayun',
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Dialogflow V2'),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),

      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),

      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}





