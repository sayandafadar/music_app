import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  TextEditingController songName = TextEditingController();
  TextEditingController artistName = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController songURL = TextEditingController();
  TextEditingController imageURL = TextEditingController();

  File image, song;
  String imagepath, songpath;
  Reference ref;
  var imageDownUrl, songDownUrl;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // void selectimage() async {
  //   image = await FilePicker.getFile();

  //   setState(() {
  //     image = image;
  //     imagepath = basename(image.path).toString();
  //     uploadImageFile(image.readAsBytesSync(), imagepath);
  //   });
  // }

  // Future<String> uploadImageFile(List<int> image, String imagepath) async {
  //   ref = FirebaseStorage.instance.ref().child(imagepath);
  //   UploadTask uploadTask = ref.putData(image);

  //   imageDownUrl = await (await uploadTask).ref.getDownloadURL();
  // }

  // void selectsong() async {
  //   song = await FilePicker.getFile();

  //   setState(() {
  //     song = song;
  //     songpath = basename(song.path);
  //     uploadSongFile(song.readAsBytesSync(), songpath);
  //   });
  // }

  // Future<String> uploadSongFile(List<int> song, String songpath) async {
  //   ref = FirebaseStorage.instance.ref().child(songpath);
  //   UploadTask uploadTask = ref.putData(song);

  //   songDownUrl = await (await uploadTask).ref.getDownloadURL();
  // }

  finalupload(context) {
    if (songName.text != '' && songURL.text != null && imageURL.text != null) {
      print(songName.text);
      print(artistName.text);
      print(songURL.text);
      print(imageURL.text);

      var data = {
        "songName": songName.text,
        "artistName": artistName.text,
        "songUrl": songURL.text,
        "imageUrl": imageURL.text,
        "duration": durationController.text,
      };

      firestore.collection("songs").add(data).whenComplete(() => showDialog(
            context: context,
            builder: (context) =>
                _onTapButton(context, "Files Uploaded Successfully :)"),
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            _onTapButton(context, "Please Enter All Details :("),
      );
    }
  }

  _onTapButton(BuildContext context, data) {
    return AlertDialog(title: Text(data));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        // RawMaterialButton(
        //   onPressed: () => selectimage(),
        //   child: Text("Select Image"),
        // ),
        // RawMaterialButton(
        //   onPressed: () => selectsong(),
        //   child: Text("Select Song"),
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: TextField(
            controller: songURL,
            decoration: InputDecoration(
              hintText: "Enter Song URL",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: TextField(
            controller: imageURL,
            decoration: InputDecoration(
              hintText: "Enter Image URL",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: TextField(
            controller: songName,
            decoration: InputDecoration(
              hintText: "Enter Song Name",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: TextField(
            controller: artistName,
            decoration: InputDecoration(
              hintText: "Enter artist name",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: TextField(
            controller: durationController,
            decoration: InputDecoration(
              hintText: "Enter duration name",
            ),
          ),
        ),
        RawMaterialButton(
          onPressed: () => finalupload(context),
          child: Text("Upload"),
        ),
      ],
    ));
  }
}
