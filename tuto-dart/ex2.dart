import 'dart:io';

void main() {
  stdout.write('Enter a number : ');
  int number = int.parse(stdin.readLineSync()!);
  if (number % 2 == 0) {
    print('This is an even number !');
  } else {
    print('This is an odd number !');
  }
}