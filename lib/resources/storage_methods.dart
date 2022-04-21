import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Função que salva uma foto do usuário no Firebase storage e retorna uma url desse arquivo
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Adicionadno Imagem ao Firebase Storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    //Como estamos usando o Uint8List tem quer ser o putData e não putFile

    //UploadTask é similar ao tipo Future
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;

    // Gerará uma url do arquivo que foi anexado
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
