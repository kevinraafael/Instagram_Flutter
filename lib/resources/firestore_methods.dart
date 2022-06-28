import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Realizar o UpLoad de um Post

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Ocorreu um erro";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      //Cria um identificador único
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uuid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uuid, List likes) async {
    try {
      if (likes.contains(uuid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uuid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uuid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
