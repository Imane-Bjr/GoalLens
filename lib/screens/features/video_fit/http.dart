import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking videos
import 'package:http/http.dart' as http; // For HTTP requests

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  File? _file;
  String _responseMessage = "";

  // Function to pick a video from the gallery and upload it
  Future<void> uploadVideo() async {
    try {
      // Pick a video from the gallery
      final myfile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (myfile == null) return;

      setState(() {
        _file = File(myfile.path);
      });

      // Replace with your machine's local IP address
      final apiUrl = 'http://192.168.1.15:5000/process_video'; // Example IP
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.files.add(await http.MultipartFile.fromPath(
        'video', // This key must match Flask's 'request.files['video']'
        _file!.path,
      ));

      // Send the request with a timeout
      var response = await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = 'Video processed successfully!';
        });
      } else {
        setState(() {
          _responseMessage = 'Failed to process video: ${response.statusCode}';
        });
      }
    } on TimeoutException {
      setState(() {
        _responseMessage = 'Request timed out. Please try again.';
      });
    } on SocketException {
      setState(() {
        _responseMessage =
            'Failed to connect to the server. Check your network.';
      });
    } catch (e) {
      setState(() {
        _responseMessage = 'An error occurred: $e';
      });
    }
  }

  // Widget to build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Processing'),
        backgroundColor:
            const Color.fromARGB(255, 98, 176, 154), // Custom AppBar color
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/http.jpg'), // Add your background image in the assets
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _file == null
                      ? Text(
                          "No video selected",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      : VideoPlayerWidget(
                          file: _file!), // Custom widget to display the video
                  SizedBox(height: 20),
                  Text(
                    _responseMessage,
                    style: TextStyle(
                        fontSize: 18,
                        color:
                            Colors.white), // White text for better visibility
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Upload Button with style
                      ElevatedButton(
                        onPressed: uploadVideo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 49, 154, 114), // Button color
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                          elevation: 5, // Button shadow
                        ),
                        child: Text(
                          "Upload Video",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom widget to display the selected video (optional)
class VideoPlayerWidget extends StatelessWidget {
  final File file;

  VideoPlayerWidget({required this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Video selected: ${file.path}',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}
