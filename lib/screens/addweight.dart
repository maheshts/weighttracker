import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weighttracker/model/weight_model.dart';

class AddWeight extends StatefulWidget {
  @override
  _AddWeightState createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
// declare variable>>>
  int srNum = 1;
  final weightController = TextEditingController();
  var dateData = "";
  TextEditingController dateController = TextEditingController();
  bool isAddLoading = false;

  // select time>>

  TimeOfDay selectedTime = TimeOfDay.now();
  selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  // show date >>
  DateTime _date = DateTime.now();
  Future<dynamic> showDate(BuildContext context) async {
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1947),
        lastDate: DateTime(2030));
    if (datePicker != null && datePicker != _date) {
      setState(() {
        _date = datePicker;
      });
    }
  }

  var box;
// initialize srNum>>>>
  initSrNum() async {
    box = await Hive.openBox<WeightModel>("saveTask");
    srNum = box.get("srNum") ?? 1;
  }

  // initialize thingies>>>>>
  @override
  void initState() {
    initSrNum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header for app>>>>>
      appBar: AppBar(
        title: Text("Add Weight"),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  selectTime(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: customBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Choose Time: ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          " ${selectedTime.hour}:${selectedTime.minute} ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: customBox(
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Weight';
                    }
                    if (value.trim() == "") return "Only Space is Not Valid!!!";
                    return null;
                  },
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  // keyboardAppearance: ,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Weight",
                      hintText: "Weight in KG",
                      icon: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.line_weight,
                          color: Colors.white,
                        ),
                      ),
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  showDate(context).then((value) {
                    setState(() {
                      dateData = _date.toString().substring(0, 11);
                      var date = dateData;
                      dateData = dateData.toString();
                      dateController.text = date;
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: customBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Select date:  ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "$dateData",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                    var weight = weightController.text;
                    var date = dateData;
                    var timeData = selectedTime.hour.toString() +
                        ":" +
                        selectedTime.minute.toString();
                    if (weight.isEmpty || date.isEmpty || timeData.isEmpty) {
                      setState(() {
                        isAddLoading = false;
                      });
                      return alert(context,
                          headerText: "Attention!",
                          content: "Please enter all details carefully!");
                    } else {
                      setState(() {
                        isAddLoading = true;
                      });
                      setState(() {
                        srNum = int.parse(srNum.toString());
                      });
                      WeightModel model = new WeightModel(
                          srNum: int.parse(srNum.toString()),
                          weightNum: double.parse(weight),
                          dateStamp: date,
                          timeStamp: timeData);

                      // var box = await Hive.openBox<WeightModel>('saveTask');
                      await box.add(model);
                      print("added");
                      srNum++;
                      setState(() {
                        isAddLoading = false;
                      });
                    }
                  },
                  child: isAddLoading
                      ? const Text("please wait..")
                      : const Text("Add")),
            )
          ],
        ),
      ),
    );
  }

  customBox({Widget? child}) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white)),
        alignment: Alignment.center,
        child: child);
  }

// alert method >>>
  alert(BuildContext context, {String? headerText, String? content}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade300,
        title: Text(
          headerText!,
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          content!,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
