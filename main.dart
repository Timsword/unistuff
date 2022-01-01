import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  File? imagefile;

  @override
  Widget build(BuildContext context) {
    var ImageSource;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturing Image'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imagefile != null)
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  image: DecorationImage(
                      image: FileImage(imagefile!),
                      fit: BoxFit.cover
                  ),
                  border: Border.all(width: 8, color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(11.0),
                ),
              )
            else
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  border: Border.all(width: 5, color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: const Text('Image should appear here', style: TextStyle(fontSize: 26),),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: ()=> getImage(source: ImageSource.camera),
                    child: const Text(
                      'Camera', style: TextStyle(fontSize: 18))
                  ),
                ),
                const SizedBox(width: 18,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: ()=> getImage(source: ImageSource.gallery),
                    child: const Text(
                        'Gallery', style: TextStyle(fontSize: 18))
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {

    final file = await ImagePicker().pickImage(
        source: source,
      maxWidth: 640,
      maxHeight: 480,
    );
    if(file?.path != null){
      setState(() {
        imagefile = File(file!.path);

      });
    }
  }
}