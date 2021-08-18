// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_page.dart';
import 'detail_post_page.dart';

class SearchPage extends StatelessWidget {
  final FirebaseUser user;

  SearchPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'QR CODE SCAN',
        style: GoogleFonts.fredokaOne(),
      ),
    );
  }

  Widget _buildBody(context) {
    print('search_page created');
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        // 컬렉션 지칭가능 : post에 있는 모든 데이터를 가져옴
          stream: Firestore.instance.collection('post').snapshots(),
          builder: (context, snapshot) {
            // 데이터가 없다면
            if (!snapshot.hasData) {
              // 빙글 도는 로딩
              return Center(child: CircularProgressIndicator(),);
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3열
                  childAspectRatio: 1.0, // 1:1
                  mainAxisSpacing: 1.0,  // 1:1 정사각형 의미
                  crossAxisSpacing: 1.0), // 1 간격
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem(context, snapshot.data.documents[index]);
              },
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.create),
        onPressed: () {
          print('눌림');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreatePage(user)));
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    // InkWell 클릭 효과
    return Hero(
      tag: document.documentID,
      child: Material(
        child: InkWell(
          onTap: () {
            // print('click');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailPostPage(document, user)),
            );

          },
          child: Image.network(
            document['photoUrl'],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
