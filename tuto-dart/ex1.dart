import 'dart:io';

void main() {
  stdout.write('Enter your name : ');
  var name = stdin.readLineSync();
  print('Hello, $name!');

  
  stdout.write('Enter your age : ');
  int age = int.parse(stdin.readLineSync()!);
  int yearsUntil100 = 100 - age;
  print('You are $age years old, you will be 100 years old in $yearsUntil100 years.');
}