
class Loaner {
  final String first_name;
  final String last_name;
  final String id;
  final String phone_number;
  final DateTime req_date;

  Loaner(this.first_name, this.last_name, this.id, this.phone_number, this.req_date);

}

class Person {
  final String firstName;
  final String lastName;
  final int age;

  Person({required this.firstName, required this.lastName, required this.age});
}