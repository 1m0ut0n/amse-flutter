import 'dart:io';

void main() {
  stdout.write('Enter a number : ');
  int number = int.parse(stdin.readLineSync()!);
  var divisor = [for (int i=number; i>0; i--) if (number % i == 0) i];
  print('The divisor of that number are ${divisor} !');
}