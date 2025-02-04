import 'dart:io';

void main() {
  stdout.write('Enter a word : ');
  var word = stdin.readLineSync()!.toLowerCase();
  var invertedWord = word.split('').reversed.join('');
  var palindrome = word == invertedWord;
  
  print(palindrome ? 'This word is a palindrome !' : 'This word is not a palindrome !');
}