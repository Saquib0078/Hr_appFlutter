import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:photo_view/photo_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? imageFile;
  Position? _currentPosition;
  String? _address;
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    if (source == ImageSource.camera) {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission.isDenied) {
        return;
      }

      final locationPermission = await Permission.location.request();
      if (locationPermission.isDenied) {
        return;
      } else {
        await _getCurrentLocation();
      }
    }

    if (source == ImageSource.gallery) {
      final storagePermission = await Permission.storage.request();
      if (storagePermission.isDenied) {
        return;
      }
    }

    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        imageFile = image;
      });
      await _getCurrentLocation();
      await _getAddressFromLatLng();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getAddressFromLatLng() async {
    if (_currentPosition != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks[0];
          setState(() {
            _address =
            '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
          });
          print('Address: $_address');
        }
      } catch (e) {
        print('Error occurred while getting the address: $e');
      }
    }
  }

  Future<void> _sendDataToApi() async {
    if (_currentPosition != null && imageFile != null && _address != null) {
      setState(() {
        _isLoading = true;
      });

      var uri = Uri.parse('http://164.52.211.138:8003/get_location');
      var request = http.MultipartRequest('POST', uri)
        ..fields['latitude'] = _currentPosition!.latitude.toString()
        ..fields['longitude'] = _currentPosition!.longitude.toString()
        ..fields['address'] = _address!
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile!.path,
        ));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var decodedResponse = json.decode(responseData);
          setState(() {
            _imageUrl = decodedResponse['image_url'];
            _isLoading = false;
          });
          print('Image URL: $_imageUrl');
        } else {
          print('Failed to send data. Status code: ${response.statusCode}');
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error sending data to API: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openInGoogleMaps() async {
    if (_currentPosition != null) {
      final latitude = _currentPosition!.latitude;
      final longitude = _currentPosition!.longitude;

      String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not open Google Maps $googleMapsUrl';
      }
    }
  }

  Future<bool> _onWillPop() async {
    return true; // Return true to allow the back button to close the app
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          backgroundColor: Colors.lightBlue,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_isLoading)
                CircularProgressIndicator()
              else if (_imageUrl != null)
                Container(
                  height: 400,
                  width: w,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: PhotoView(
                    imageProvider: NetworkImage(_imageUrl!),
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(
                        value: event == null
                            ? null
                            : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                )
              else if (imageFile != null)
                  Container(
                    height: 400,
                    width: w,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: PhotoView(
                      imageProvider: FileImage(File(imageFile!.path)),
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      loadingBuilder: (context, event) => Center(
                        child: CircularProgressIndicator(
                          value: event == null
                              ? null
                              : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                        ),
                      ),
                    ),
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Open Camera',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Open Gallery',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (imageFile != null)
                ElevatedButton(
                  onPressed: _sendDataToApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Upload Picture',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
