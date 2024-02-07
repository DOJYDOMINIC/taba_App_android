// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ImageList {
//   String? id;
//   String? imageUrl;
//
//   ImageList({this.id, this.imageUrl});
//
//   factory ImageList.fromJson(Map<String, dynamic> json) {
//     return ImageList(
//       id: json['id'],
//       imageUrl: json['imageUrl'],
//     );
//   }
// }
//
// class PaginationData extends ChangeNotifier {
//   int currentPage = 1;
//   bool isLoading = false;
//   bool reachedEnd = false;
//   List<ImageList> imageList = [];
//
//   Future<void> fetchData() async {
//     if (isLoading || reachedEnd) return;
//
//     isLoading = true;
//
//     try {
//       final response = await http.post(
//         Uri.parse('/list_images'),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "page": currentPage,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         List<dynamic> dataList = json.decode(response.body);
//         List<ImageList> newImageList = dataList.map((json) => ImageList.fromJson(json)).toList();
//         if (newImageList.isEmpty) {
//           reachedEnd = true;
//         } else {
//           imageList.addAll(newImageList);
//           currentPage++;
//         }
//       } else {
//         // Error in API call
//         print('Failed to load image data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Exception during API call
//       print('Error: $e');
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
