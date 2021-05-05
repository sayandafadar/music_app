import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'player_screen.dart';

List<DocumentSnapshot> list;

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120.0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF536976),
                Color(0xFF292E49),
              ]),
        )),
        title: Text(
          "Meditation Vives",
          style: TextStyle(
              fontSize: 30.0, color: Colors.white, fontFamily: "DancingScript"),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFF536976),
              Color(0xFF292E49),
            ],
          ),
        ),
        child: MusicStream(),
      ),
    );
  }
}

class MusicStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('songs')
          .orderBy('songName')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        } else {
          list = snapshot.data.docs;
          List<SeassionCard> sessionCards = [];
          for (var card in list) {
            final cardImage = card.data()['imageUrl'];
            final title = card.data()['songName'];
            final duration = card.data()['duration'];
            final sessionCard = SeassionCard(
              cardImage: cardImage,
              title: title,
              duration: duration,
              press: () => Get.to(
                PlayerScreen(
                  songName: card.data()["songName"],
                  artistName: card.data()["artistName"],
                  songUrl: card.data()["songUrl"],
                  imageUrl: card.data()["imageUrl"],
                ),
              ),
            );

            sessionCards.add(sessionCard);
          }
          return ListView(
            children: [
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: sessionCards,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class SeassionCard extends StatelessWidget {
  final Function press;
  final String cardImage;
  final String duration;
  final String title;
  const SeassionCard({
    Key key,
    this.press,
    this.cardImage,
    this.duration,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: constraint.maxWidth / 2 - 12,
          height: constraint.maxWidth / 1.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF536976), Color(0xFF292E49)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: NetworkImage(
                cardImage,
              ),
              alignment: Alignment.centerLeft,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                offset: Offset(4, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: press,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                    height: 17.0,
                    width: 50.0,
                    child: Center(
                      child: Text(
                        duration,
                        style: TextStyle(
                          fontSize: 9.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0x55FFFFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 33.0,
                          fontFamily: "DancingScript"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
