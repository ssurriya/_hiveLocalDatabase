import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 22)
class Employee {
  @HiveField(0)
  String empName;

  @HiveField(1)
  String empSalary;

  @HiveField(2)
  String empAge;

  Employee(
      {required this.empName, required this.empSalary, required this.empAge});
}
