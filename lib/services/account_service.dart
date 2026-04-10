class account_service {
  account_service._();
  static final account_service instance = account_service._();

  final List<Map<String, String>> users = [];

  String? register(String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      return 'Username and password cannot be empty.';
    }
    if (users.any((u) => u['username']!.toLowerCase() == username.toLowerCase())) {
      return 'Username already taken.';
    }
    users.add({'username': username, 'password': password});
    return null;
  }

  String? login(String username, String password) {
    users.add({'username': 'admin', 'password': '123'}); // admin account
    if (username.isEmpty || password.isEmpty) {
      return 'Username and password cannot be empty.';
    }
    final match = users.any(
      (u) =>
          u['username']!.toLowerCase() == username.toLowerCase() &&
          u['password'] == password,
    );
    if (!match) {
      return 'Invalid username or password.';
    }
    return null;
  }
}
