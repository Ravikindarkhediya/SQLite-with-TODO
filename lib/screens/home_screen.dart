import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db_helper.dart';
import '../model/photo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxList<Photo> photoList = <Photo>[].obs;
  final DBHelper dbHelper = DBHelper();

  Future<void> pickAndSaveImage() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Add TODO'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );

                if (result != null) {
                  String path = result.files.single.path!;
                  print('\n\n\nPAth:  $path');
                  print('\n\n\n ${titleController.text}');
                  print('\n\n\n ${descController.text}');
                  Photo photo = Photo(
                    photoName: path,
                    title: titleController.text,
                    description: descController.text,
                  );
                  await dbHelper.insertPhoto(photo);
                  loadPhotos();
                  Navigator.pop(context);
                }
              },
              child: Text('Pick Image'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadPhotos() async {
    print('\n\n Load Photos');
    final photos = await dbHelper.getPhotos();
    photoList.assignAll(photos);
    print('\n\n Load Photos');
  }

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          pickAndSaveImage().then((onValue){
            Get.toNamed('/home');
          });
        },
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (photoList.isEmpty) {
          return Center(child: Text("No images found"));
        }
        return ListView.builder(
          itemCount: photoList.length,
          itemBuilder: (context, index) {
            final photo = photoList[index];
            return ListTile(
              leading: Image.file(
                File(photo.photoName),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(photo.title),
              subtitle: Text(photo.description),
            );
          },
        );
      }),
    );
  }
}
