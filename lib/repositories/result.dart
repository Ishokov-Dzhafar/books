abstract class Result {
  ///Error message is not null
  String _errorMessage;

  String get errorMessage => _errorMessage;


  ///Constructor for creating Result of Authorization request
  Result(String errorMessage, {String status}) : assert(errorMessage != null) {
    _errorMessage = errorMessage ?? '';
  }

  bool isSucceeded() => _errorMessage.isEmpty;
}