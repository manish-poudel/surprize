import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:Surprize/CustomWidgets/CustomNoticeViewWidget.dart';
import 'package:Surprize/Models/Notice.dart';
import 'package:Surprize/Resources/FirestoreResources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {

  Map<String, Notice> _noticeMap = new Map();


  @override
  void initState() {
    super.initState();
    getNoticeFromServer();
  }

  /// Get quiz letter list from server
  getNoticeFromServer(){
    Firestore.instance.collection(FirestoreResources.collectionNotice).snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((docSnapshot){
        Notice notice = Notice.fromMap(docSnapshot.document.data);
        setState(() {
          _noticeMap.putIfAbsent(notice.id, () => notice);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar("Notice",context),
        body: SingleChildScrollView(child: noticeList()),
      ),
    );
  }


  Widget noticeList(){
    List<Notice> noticeList = _noticeMap.values.toList();

    if(noticeList.length == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.new_releases, color: Colors.grey,),
              Text("No notice", style: TextStyle(
                  fontSize: 14, fontFamily: 'Raleway', color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: noticeList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left:8.0, right: 8.0),
              child: Column(
                children: <Widget>[
                  Card(child: CustomNoticeViewWidget(noticeList[index]))
                ],
              ),
            );
          }),
    );
  }
}
