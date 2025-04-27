// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../theme/app_theme.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLogin = true;
//   bool _isPasswordVisible = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _toggleFormMode() {
//     setState(() {
//       _isLogin = !_isLogin;
//     });
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       bool success;

//       if (_isLogin) {
//         success = await authProvider.login(
//           _emailController.text.trim(),
//           _passwordController.text,
//         );
//       } else {
//         success = await authProvider.register(
//           _nameController.text.trim(),
//           _emailController.text.trim(),
//           _passwordController.text,
//         );
//       }

//       if (success && mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final theme = Theme.of(context);

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // App Logo and Title
//                 Icon(
//                   Icons.check_circle_outline,
//                   size: 80,
//                   color: theme.colorScheme.primary,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Smart Tasker',
//                   textAlign: TextAlign.center,
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: theme.colorScheme.primary,
//                   ),
//                 ),
//                 Text(
//                   'AI-Powered Task Management',
//                   textAlign: TextAlign.center,
//                   style: theme.textTheme.titleMedium?.copyWith(
//                     color: theme.colorScheme.secondary,
//                   ),
//                 ),
//                 const SizedBox(height: 48),

//                 // Form
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       // Title
//                       Text(
//                         _isLogin ? 'Login' : 'Create Account',
//                         style: theme.textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // Name field (only for register)
//                       if (!_isLogin)
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: const InputDecoration(
//                             labelText: 'Name',
//                             prefixIcon: Icon(Icons.person),
//                           ),
//                           validator: (value) {
//                             if (!_isLogin && (value == null || value.isEmpty)) {
//                               return 'Please enter your name';
//                             }
//                             return null;
//                           },
//                           textInputAction: TextInputAction.next,
//                         ),
//                       if (!_isLogin) const SizedBox(height: 16),

//                       // Email field
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           prefixIcon: Icon(Icons.email),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                               .hasMatch(value)) {
//                             return 'Please enter a valid email';
//                           }
//                           return null;
//                         },
//                         keyboardType: TextInputType.emailAddress,
//                         textInputAction: TextInputAction.next,
//                       ),
//                       const SizedBox(height: 16),

//                       // Password field
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: const Icon(Icons.lock),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: _togglePasswordVisibility,
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           if (!_isLogin && value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                         obscureText: !_isPasswordVisible,
//                         textInputAction: TextInputAction.done,
//                         onFieldSubmitted: (_) => _submitForm(),
//                       ),
//                       const SizedBox(height: 24),

//                       // Error message
//                       if (authProvider.error != null)
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 16.0),
//                           child: Text(
//                             authProvider.error!,
//                             style: TextStyle(
//                               color: theme.colorScheme.error,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),

//                       // Submit button
//                       ElevatedButton(
//                         onPressed: authProvider.isLoading ? null : _submitForm,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: authProvider.isLoading
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : Text(_isLogin ? 'Login' : 'Register'),
//                       ),
//                       const SizedBox(height: 16),

//                       // Toggle form mode
//                       TextButton(
//                         onPressed: _toggleFormMode,
//                         child: Text(
//                           _isLogin
//                               ? 'Don\'t have an account? Register'
//                               : 'Already have an account? Login',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
