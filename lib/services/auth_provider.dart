import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  // Sign up with email and password
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    BuildContext? context, // Optional context for navigation/snackbar
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (name.isEmpty) {
        throw Exception('Please enter your name');
      }

      if (email.isEmpty) {
        throw Exception('Please enter your email');
      }

      if (password.isEmpty) {
        throw Exception('Please enter a password');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Firebase sign up
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update user display name
      await userCredential.user?.updateDisplayName(name);

      // Reload the user to get updated profile information
      await userCredential.user?.reload();

      // Get the updated user object
      _currentUser = _auth.currentUser;
      notifyListeners(); // Make sure to notify listeners of the update

      if (context != null) {
        _showSuccessSnackBar(context, 'Account created successfully!');
      }

      return _currentUser;
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseErrorMessage(e);
      _setError(message);
      return null;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (email.isEmpty) {
        throw Exception('Please enter your email');
      }

      if (password.isEmpty) {
        throw Exception('Please enter your password');
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Reload the user to get updated profile information
      await userCredential.user?.reload();

      // Get the updated user object
      _currentUser = _auth.currentUser;
      notifyListeners();

      return _currentUser;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e));
      return null;
    } catch (e) {
      // Handles PlatformException on Windows
      final message = e.toString().replaceAll('Exception: ', '');
      _setError(
        message.isNotEmpty ? message : 'An unexpected error occurred',
      );
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Check if user is logged in - FIXED VERSION
  Future<void> checkAuthState() async {
    _currentUser = _auth.currentUser;
    // Removed notifyListeners() to fix the "setState() called during build" error
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered';

      case 'invalid-email':
        return 'Please enter a valid email address';

      case 'weak-password':
        return 'Password is too weak';

      case 'user-not-found':
        return 'No account found with this email';

      case 'wrong-password':
        return 'Incorrect password';

      case 'invalid-credential':
        return 'Incorrect email or password';

      case 'internal-error':
        return 'Incorrect email or password';

      case 'network-request-failed':
        return 'Network error. Please check your connection';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later';

      default:
        return 'Authentication failed. Please try again.';
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut(); // clear cache for last log-in

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // if User canceled the sign-in
      if (googleUser == null) {
        _setLoading(false);
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Reload the user to get updated profile information
      await userCredential.user?.reload();

      // Get the updated user object
      _currentUser = _auth.currentUser;
      notifyListeners();

      return _currentUser;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e));
      return null;
    } catch (e) {
      _setError('Google Sign-In failed. Please try again.');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Forgot Password
  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (email.isEmpty) {
        throw Exception('Please enter your email first');
      }

      await _auth.sendPasswordResetEmail(email: email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset email sent. Check your inbox.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseErrorMessage(e));
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
