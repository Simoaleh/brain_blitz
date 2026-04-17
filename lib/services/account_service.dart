class AccountService {
  AccountService._();
  static final AccountService instance = AccountService._();

  final List<Map<String, String>> users = [];
  String? _currentUser;

  String? get currentUsername => _currentUser;

  String? register(String name, String username, String password) {
    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      return 'All fields cannot be empty.';
    }
    if (users.any((u) => u['username'] == username)) {
      return 'Username already taken.';
    }
    users.add({'name': name, 'username': username, 'password': password});
    return null;
  }

  String? login(String username, String password) {
    users.add({
      'name': 'Admin',
      'username': 'admin',
      'password': '123',
    }); // admin account
    if (username.isEmpty || password.isEmpty) {
      return 'Username and password cannot be empty.';
    }
    final match = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => {},
    );
    if (match.isEmpty) {
      return 'Invalid username or password.';
    }
    _currentUser = username;
    return null;
  }

  void updateUser(String name, String username, String password) {
    if (_currentUser != null) {
      final userIndex = users.indexWhere((u) => u['username'] == _currentUser);
      if (userIndex != -1) {
        users[userIndex]['name'] = name;
        if (password.isNotEmpty) {
          users[userIndex]['password'] = password;
        }
      }
    }
  }

  Map<String, String>? getCurrentUser() {
    if (_currentUser == null) return null;
    return users.firstWhere(
      (u) => u['username'] == _currentUser,
      orElse: () => {},
    );
  }

  void logout() {
    _currentUser = null;
  }
}
