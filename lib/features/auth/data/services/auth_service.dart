import 'dart:convert';
import 'dart:math';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  bool get isAuthenticated => _token != null;
  String? get token => _token;

  Future<String> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    // Generate a mock JWT token
    final header = base64Encode(utf8.encode(json.encode({
      'alg': 'HS256',
      'typ': 'JWT'
    })));

    final payload = base64Encode(utf8.encode(json.encode({
      'sub': _generateUserId(),
      'email': email,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    })));

    final signature = base64Encode(
      List<int>.generate(32, (i) => Random().nextInt(256))
    );

    _token = '$header.$payload.$signature';
    return _token!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _token = null;
  }

  String _generateUserId() {
    const chars = 'abcdef0123456789';
    final random = Random();
    final result = StringBuffer();
    
    for (var i = 0; i < 24; i++) {
      result.write(chars[random.nextInt(chars.length)]);
    }
    
    return result.toString();
  }
} 