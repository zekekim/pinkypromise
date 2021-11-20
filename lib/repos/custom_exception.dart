class CustomException {
  final String? message;

  const CustomException({this.message = 'Something went wrong!'});

  @override
  String toString() => 'CustomException {message: $message}';
}
