import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static const String _webClientId =
      '152566724840-itl7926ncrk5pi4lhqtmqtpoaioe5cgr.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: _webClientId,
  );

  Future<String> getIdToken() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Login Google dibatalkan');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;

    if (idToken == null) {
      throw Exception('idToken null');
    }

    return idToken;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}