import 'blocs/passcode_bloc.dart' show KeyboardSymbol;

String mapKeyboarSymbol(KeyboardSymbol symbol) {
  switch (symbol) {
    case KeyboardSymbol.zero:
      return '0';
      break;
    case KeyboardSymbol.one:
      return '1';
      break;
    case KeyboardSymbol.two:
      return '2';
      break;
    case KeyboardSymbol.three:
      return '3';
      break;
    case KeyboardSymbol.four:
      return '4';
      break;
    case KeyboardSymbol.five:
      return '5';
      break;
    case KeyboardSymbol.six:
      return '6';
      break;
    case KeyboardSymbol.seven:
      return '7';
      break;
    case KeyboardSymbol.eight:
      return '8';
      break;
    case KeyboardSymbol.nine:
      return '9';
      break;
    default:
      return '';
  }
}