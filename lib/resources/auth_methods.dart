import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
    //Recebe os dados da coleção como um document snapshot e por meio do método from Snap
    //implementado  na model user ele "divide nas propriedades" de user

    /*
    A DocumentSnapshot is returned from a query, or by accessing
     the document directly. Even if no document exists in the database,
      a snapshot will always be returned.
    */
  }

  //Cadastrar Usuário , uma função assincrona pois toda operação que depende do firebase é assincrona
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Ocorreu um erro";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //Cadastrar  o usuário
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // Salvar os dados do usuário no banco
        print(credential.user!.uid);

        // Vou chamar minha função que salva a photo do usuári
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        model.User user = model.User(
          username: username,
          uuid: credential.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );
        //Aqui basicamente ele vai criar uma coleção e salvar os dados nessa coleção
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
        res = 'success';
        /*
       
         await _firestore.collection('users').add({
          'username': username,
          'uid': credential.user!.uid,
          'email': email,
          'bio': bio,
          'folowers': [],
          'folowing': [],
        });
        Outra forma de adicionar , porém dessa forma o Firebase vai generar
        o uuid de forma totalmente aleatória o que pode ser ruim futuramente
        pra fazer algumas consultas e outras tarefas simples que levariam menos tempo
        */
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //Logar usuário
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Houve um erro interno";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "sucess";
      } else {
        res = "Por favor preencha todos os campos";
      }
    } /* Para quando ocorrer um erro na autenticação no bd
     on FirebaseAuthException catch(e){
      e.code =='user-not-found'?
    }  */
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
