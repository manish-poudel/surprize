import 'dart:async';

import 'dart:io';

abstract class FirestoreStorage{
  Future<String> uploadFile(String folderName, String filename, File file);
}