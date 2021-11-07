import 'package:flutter/material.dart';

class AddWeight extends StatefulWidget {
  @override
  _AddWeightState createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  String _studentName="";

  final _studentNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Weight"),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter Student Name';
              }
              if (value.trim() == "")
                return "Only Space is Not Valid!!!";
              return null;
            },
            onSaved: (value) {
              _studentName = value!;
            },
            controller: _studentNameController,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.purple,
                        width: 2,
                        style: BorderStyle.solid)),
                // hintText: "Student Name",
                labelText: "Student Name",
                icon: Icon(
                  Icons.business_center,
                  color: Colors.purple,
                ),
                fillColor: Colors.white,
                labelStyle: TextStyle(
                  color: Colors.purple,
                )),
          ),
        ),
          ElevatedButton(onPressed: slectdate(), child:
          const Text("Select Date")),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: slectdate(), child:
          const Text("Add"))
        ],
      ),

    );
  }
  slectdate(){

  }
}
