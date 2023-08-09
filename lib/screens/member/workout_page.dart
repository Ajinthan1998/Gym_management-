import 'package:flutter/material.dart';
import 'workout_detail.dart';

class Workouts extends StatelessWidget {
  final category;

  Workouts({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
            padding: EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width - 80.0,
            height: MediaQuery.of(context).size.height - 50.0,
            child: GridView.count(
              crossAxisCount: 2,
              primary: false,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.8,
              children: buildCardList(context),
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  List<Widget> buildCardList(BuildContext context) {
    List<Widget> cardList = [];

    if (category == "abs") {
      cardList.add(_buildCard(
        'Abs 1',
        'assets/images/abs.jpg',
        category,
        false,
        true,
        context,
        'abs1',
      ));
      cardList.add(_buildCard(
        'Abs 2',
        'assets/images/abs.jpg',
        category,
        false,
        false,
        context,
        'abs2',
      ));
      cardList.add(_buildCard(
        'Abs 3',
        'assets/images/abs.jpg',
        category,
        false,
        false,
        context,
        'abs3',
      ));
      cardList.add(_buildCard(
        'Abs 4',
        'assets/images/abs.jpg',
        category,
        false,
        false,
        context,
        'abs4',
      ));
    } else if (category == "chest") {
      cardList.add(_buildCard(
        'Chest 1',
        'assets/images/chest.jpg',
        category,
        true,
        false,
        context,
        'chest1',
      ));
      cardList.add(_buildCard(
        'Chest 2',
        'assets/images/chest.jpg',
        category,
        true,
        false,
        context,
        'chest2',
      ));
      cardList.add(_buildCard(
        'Chest 3',
        'assets/images/shoulder.png',
        category,
        false,
        true,
        context,
        'chest3',
      ));
      cardList.add(_buildCard(
        'Chest 4',
        'assets/images/shoulder.png',
        category,
        false,
        true,
        context,
        'chest4',
      ));
    } else if (category == "shoulder") {
      cardList.add(_buildCard(
        'Shoulder 1',
        'assets/images/workout.jpg',
        category,
        false,
        false,
        context,
        'shoulder1',
      ));
      cardList.add(_buildCard(
        'Shoulder 2',
        'assets/images/workout.jpg',
        category,
        false,
        false,
        context,
        'shoulder2',
      ));
      cardList.add(_buildCard(
        'Shoulder 3',
        'assets/images/workout.jpg',
        category,
        false,
        false,
        context,
        'shoulder3',
      ));
      cardList.add(_buildCard(
        category,
        'assets/images/workout.jpg',
        "shoulder",
        false,
        false,
        context,
        'shoulder4',
      ));
    }

    return cardList;
  }

  Widget _buildCard(
    String name,
    String imgPath,
    String cat,
    bool added,
    bool isFavourite,
    context,
    String heroTag,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutDetail(
                assetPath: imgPath,
                workoutName: name,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [],
            color: Colors.black,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isFavourite
                        ? Icon(Icons.favorite, color: Color(0xFFEF7532))
                        : Icon(Icons.favorite_outline, color: Color(0xFFEF7532))
                  ],
                ),
              ),
              Hero(
                tag: heroTag,
                child: Container(
                  height: 90.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imgPath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 17.0),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Varela',
                    fontSize: 20.0,
                  ),
                ),
              ),

              Text(
                category,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Varela',
                  fontSize: 12.0,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(15.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
