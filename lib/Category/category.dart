import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';

class GeneralCatgory extends StatelessWidget {
  const GeneralCatgory({
    Key key,
    @required this.title,
    @required this.category,
  }) : super(key: key);
  final String title;
  final String category;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        Route route = MaterialPageRoute(builder: (context) => StoreHome());
        Navigator.push(context, route);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.redAccent, Colors.blueAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 55.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            // SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(category)
                  .limit(15)
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverFillRemaining(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverFillRemaining(
                      child: MasonryGridView.count(
                          crossAxisCount: 1,
                          // staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                dataSnapshot.data.docs[index].data());
                            return sourceInfo(model, context);
                          },
                          itemCount: dataSnapshot.data.docs.length,
                        ),
                    );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
