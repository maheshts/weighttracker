import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weighttracker/model/weight_model.dart';
import 'package:weighttracker/screens/addweight.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<String> dataList = ["Sr No.: ", "Weight: ", "Time: ", "Date"];
  // initialize >>>>

  var box;
  List<WeightModel> weightData = [];
  String average = "loading ...";
  initData() async {
    box = await Hive.openBox<WeightModel>("saveTask");
    setState(() {
      weightData = box.values.toList();
      weightData = new List.from(weightData.reversed);
      var avg = weightData.map((m) => m.weightNum).reduce((a, b) => a! + b!)! /
          weightData.length;
      average = avg.round().toString();
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
           // Navigator.push(ontext, MaterialPageRoute(builder: (context) => AddWeight()));
            Map results =  await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
              builder: (BuildContext context) {
                return new AddWeight();
              },
            ));
            //var results = await Navigator.pushNamed(context, AddWeight());
            if (results != null && results.containsKey('selection')) {
              setState(() {
                initData();
                //_selection = results['selection'];
              });
            }
          },
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            initData();
          },
          child: CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverAppBar(
                // Provide a standard title.
                title: Text("Weight Tracker", style: TextStyle(
                  color: Colors.amber,
                  fontSize: 22.0,
                  fontFamily: 'Arial-Semibold',
                )),
                centerTitle: true,
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                floating: true,
                // Display a placeholder widget to visualize the shrinking size.
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2,2,20),
                    child: Text("Average: " + average,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontFamily: 'Arial-Semibold',
                        )),
                  ),
                ),

                // Make the initial height of the SliverAppBar larger than normal.
               // expandedHeight: 180,
                expandedHeight: MediaQuery.of(context).size.height/3,
              ),
              // Next, create a SliverList
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.only(left: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Text(
                                      "Weight:  ",
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Text(
                                    "${weightData[index].weightNum}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Text(
                                      "Time:  ",
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Text(
                                    "${weightData[index].timeStamp}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Text(
                                      "Date:  ",
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Text(
                                    "${weightData[index].dateStamp}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),

                  // Builds 1000 ListTiles
                  childCount: weightData.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  customBox() {
    return dataList.map((data) => Row(
          children: [
            Text(
              "${data}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ));
  }
}
