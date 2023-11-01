// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// void saveBookmark(String url) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];
//   bookmarks.add(url);
//   await prefs.setStringList('bookmarks', bookmarks);
// }
// Future<List<String>> getBookmarks() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];
//   return bookmarks;
// }