import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'add_or_edit_employee_screen.dart';
import 'employee.dart';

class EmployeesListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmployeesListState();
  }
}

class EmployeesListState extends State<EmployeesListScreen> {
  List<Employee> listEmployees = [];

  void getEmployees() async {
    final box = await Hive.openBox<Employee>('employee');
    setState(() {
      listEmployees = box.values.toList();
    });
  }

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Hive Local Database"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddOrEditEmployeeScreen(false)));
            }),
        body: Container(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
                itemCount: listEmployees.length,
                itemBuilder: (context, position) {
                  Employee getEmployee = listEmployees[position];
                  var salary = getEmployee.empSalary;
                  var age = getEmployee.empAge;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(getEmployee.empName,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18))),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(right: 45),
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                AddOrEditEmployeeScreen(true,
                                                    position, getEmployee)));
                                  }),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  final box = Hive.box<Employee>('employee');
                                  box.deleteAt(position);
                                  setState(
                                      () => {listEmployees.removeAt(position)});
                                }),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("Salary: $salary | Age: $age",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18))),
                        ],
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}
