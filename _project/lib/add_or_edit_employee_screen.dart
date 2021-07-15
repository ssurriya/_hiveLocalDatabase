import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'employee.dart';
import 'employee_list_screen.dart';

// ignore: must_be_immutable
class AddOrEditEmployeeScreen extends StatefulWidget {
  bool isEdit;
  int? position;
  Employee? employeeModel;

  // ignore: use_key_in_widget_constructors
  AddOrEditEmployeeScreen(this.isEdit, [this.position, this.employeeModel]);

  @override
  State<StatefulWidget> createState() {
    return AddEditEmployeeState();
  }
}

class AddEditEmployeeState extends State<AddOrEditEmployeeScreen> {
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerSalary = new TextEditingController();
  TextEditingController controllerAge = new TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      controllerName.text = widget.employeeModel!.empName;
      controllerSalary.text = widget.employeeModel!.empSalary.toString();
      controllerAge.text = widget.employeeModel!.empAge.toString();
    }

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text("Employee Name:", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(controller: controllerName),
                  )
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text("Employee Salary:",
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                        controller: controllerSalary,
                        keyboardType: TextInputType.number),
                  )
                ],
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text("Employee Age:", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                        controller: controllerAge,
                        keyboardType: TextInputType.number),
                  )
                ],
              ),
              const SizedBox(height: 100),
              // ignore: deprecated_member_use
              RaisedButton(
                color: Colors.grey,
                child: const Text("Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: () async {
                  var getEmpName = controllerName.text;
                  var getEmpSalary = controllerSalary.text;
                  var getEmpAge = controllerAge.text;
                  if (getEmpName.isNotEmpty &
                      getEmpSalary.isNotEmpty &
                      getEmpAge.isNotEmpty) {
                    if (widget.isEdit) {
                      // ignore: unnecessary_new
                      Employee updateEmployee = new Employee(
                          empName: getEmpName,
                          empSalary: getEmpSalary,
                          empAge: getEmpAge);
                      var box = await Hive.openBox<Employee>('employee');
                      box.putAt(
                          int.parse("${widget.position}"), updateEmployee);
                    } else {
                      // ignore: unnecessary_new
                      Employee addEmployee = new Employee(
                          empName: getEmpName,
                          empSalary: getEmpSalary,
                          empAge: getEmpAge);
                      var box = await Hive.openBox<Employee>('employee');
                      box.add(addEmployee);
                      // ignore: unnecessary_string_interpolations
                      // databaseRef.child("$getEmpName").set({
                      //   "name": "$getEmpName",
                      //   "age": "$getEmpAge",
                      //   "salary": "$getEmpSalary"
                      // });
                    }
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EmployeesListScreen()),
                        (r) => false);
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
