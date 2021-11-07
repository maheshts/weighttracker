import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          // Provide a standard title.
          title: Text("Weight"),
          // Allows the user to reveal the app bar if they begin scrolling
          // back up the list of items.
          floating: true,
          // Display a placeholder widget to visualize the shrinking size.
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text("Average : 45 kg",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.0,
              )),
          //background:
          // Image.network(
          //   "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
          //   fit: BoxFit.cover,
          // )
      ),

          // Make the initial height of the SliverAppBar larger than normal.
          expandedHeight: 200,
        ),
        // Next, create a SliverList
        SliverList(
          // Use a delegate to build items as they're scrolled on screen.
          delegate: SliverChildBuilderDelegate(
            // The builder function returns a ListTile with a title that
            // displays the index of the current item.
                (context, index) => ListTile(title: Text('Item #$index')),
            // Builds 1000 ListTiles
            childCount: 15,
          ),
        )
      ],
    ),
    );
  }
}
