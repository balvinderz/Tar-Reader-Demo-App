import 'dart:math';

int octToDecimal(int number)
{
  int decimal =0;

  int power = 0;
  while(number!=0)
  {
    int lastDigit = number%10;
    number=number~/10;
    //print(t);
    decimal += lastDigit*pow(8, power);
    power++;
  }
  return decimal;
}