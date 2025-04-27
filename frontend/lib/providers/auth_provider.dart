// import 'package:flutter/foundation.dart';
// import '../models/user_model.dart';
// import '../services/auth_service.dart';

// class AuthProvider with ChangeNotifier {
//   final AuthService _authService;
//   User? _user;
//   bool _isLoading = false;
//   String? _error;

//   AuthProvider({required AuthService authService}) : _authService = authService;

//   // Getters
//   User? get user => _user;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _user != null;

//   // Initialize - check if user is already logged in
//   Future<void> initialize() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final isLoggedIn = await _authService.isLoggedIn();
//       if (isLoggedIn) {
//         _user = await _authService.getCurrentUser();
//       }
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Register a new user
//   Future<bool> register(String name, String email, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       _user = await _authService.register(name, email, password);
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//       return false;
//     }
//   }

//   // Login a user
//   Future<bool> login(String email, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       _user = await _authService.login(email, password);
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//       return false;
//     }
//   }

//   // Logout a user
//   Future<void> logout() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       await _authService.logout();
//       _user = null;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Get the auth token
//   Future<String?> getToken() async {
//     return await _authService.getToken();
//   }

//   // Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }
