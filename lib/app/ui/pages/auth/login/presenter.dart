import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/auth/update_workspace_db_request.dart';
import 'package:mobile_sev2/use_cases/auth/get_token.dart';
import 'package:mobile_sev2/use_cases/auth/login.dart';
import 'package:mobile_sev2/use_cases/auth/update_workspace.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPresenter extends Presenter {
  GetTokenUseCase _tokenUseCase;
  LoginUseCase _loginUseCase;
  UpdateWorkspaceUseCase _updateWorkspaceUseCase;

  String _clientId;
  String _uriScheme;
  String _authUrl;
  String _tokenUrl;
  String _grantType;

  // for get notifications
  late Function loginOnNext;
  late Function loginOnComplete;
  late Function loginOnError;

  late Function updateWorkspaceOnNext;
  late Function updateWorkspaceOnComplete;
  late Function updateWorkspaceOnError;

  LoginPresenter(
    this._tokenUseCase,
    this._loginUseCase,
    this._updateWorkspaceUseCase,
    this._clientId,
    this._uriScheme,
    this._authUrl,
    this._tokenUrl,
    this._grantType,
  );

  ///TODO: cleanup later
  String baseUrl = 'https://sev-2.com';

  loginGoogle(String workspaceName) async {
    final callbackUrlScheme = _uriScheme;

    final url = '$baseUrl/oauth/google/start?afterurl=$callbackUrlScheme:/';

    try {
      final authResult = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: callbackUrlScheme);
      final accessToken = Uri.parse(authResult).queryParameters['access_token'];
      final userInfoResponse = await http.post(
        Uri.parse(
          'https://www.googleapis.com/oauth2/v3/userinfo?access_token=$accessToken',
        ),
        headers: {"Content-Type": "application/json"},
      );
      var userInfo = jsonDecode(userInfoResponse.body);
      var userCheck = await http.get(
        Uri.parse('$baseUrl/auth/google/account'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      late var authUserData;

      if (userCheck.statusCode != 200) {
        var requestBody = jsonEncode({
          'first_name': userInfo['given_name'] ?? "",
          'last_name': userInfo['family_name'] ?? ""
        });
        final registeredUser = await http.post(
          Uri.parse('$baseUrl/auth/google/account'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken'
          },
          body: requestBody,
        );
        if (registeredUser.statusCode > 201) {
          loginOnError(
            'register User on error status code: ${registeredUser.statusCode}',
            'google',
          );
          return;
        } else {
          userCheck = await http.get(
            Uri.parse('$baseUrl/auth/google/account'),
            headers: {'Authorization': 'Bearer $accessToken'},
          );
          authUserData = jsonDecode(userCheck.body);
        }
      } else {
        authUserData = jsonDecode(userCheck.body);
      }
      if (authUserData != null) {
        loginOnNext(
          authUserData['id'],
          accessToken,
          "google",
          userInfo['email'],
          userInfo['sub'],
        );
        loginOnComplete();
      } else {
        loginOnError(
          'something went wrong',
          'google',
        );
      }
      return;
    } catch (e) {
      if (e is PlatformException) {
        return;
      } else {
        print('error: $e');
        loginOnError(
          e,
          'google',
        );
      }
    }
  }

  loginApple(String workspaceName) async {
    try {
      AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential.identityToken != null) {
        String accessToken = credential.identityToken!;
        var userCheck = await http.get(
          Uri.parse('$baseUrl/auth/apple/account'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );
        late var authUserData;

        if (userCheck.statusCode != 200) {
          var requestBody = jsonEncode({
            'first_name': credential.givenName ?? 'ios-user',
            'last_name': credential.familyName ??
                DateTime.now().millisecondsSinceEpoch.toString()
          });
          final registeredUser = await http.post(
            Uri.parse('$baseUrl/auth/apple/account'),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken'
            },
            body: requestBody,
          );
          if (registeredUser.statusCode > 201) {
            loginOnError(
              'register User on error status code: ${registeredUser.statusCode}',
              'apple',
            );
            return;
          } else {
            userCheck = await http.get(
              Uri.parse('$baseUrl/auth/apple/account'),
              headers: {'Authorization': 'Bearer $accessToken'},
            );
            authUserData = jsonDecode(userCheck.body);
          }
        } else {
          authUserData = jsonDecode(userCheck.body);
        }
        if (authUserData != null) {
          var jwt = Jwt.parseJwt(credential.identityToken!);
          loginOnNext(
            authUserData['id'],
            accessToken,
            "apple",
            jwt['email'],
            jwt['sub'],
          );
          loginOnComplete();
        } else {
          loginOnError(
            'something went wrong',
            'apple',
          );
        }
        return;
      } else {
        loginOnError(
          'identityToken null',
          'apple',
        );
        return;
      }
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
        return;
      } else {
        print('error: $e');
        loginOnError(
          e,
          'apple',
        );
      }
    }
  }

  updateWorkspace(UpdateWorkspaceRequestInterface req) {
    if (req is UpdateWorkspaceDBRequest) {
      _updateWorkspaceUseCase.execute(_UpdateWorkspaceObserver(this), req);
    }
  }

  @override
  void dispose() {
    _tokenUseCase.dispose();
    _loginUseCase.dispose();
    _updateWorkspaceUseCase.dispose();
  }
}

class _UpdateWorkspaceObserver implements Observer<bool> {
  LoginPresenter _presenter;

  _UpdateWorkspaceObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateWorkspaceOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateWorkspaceOnError(e);
  }

  @override
  void onNext(bool? response) {
    _presenter.updateWorkspaceOnNext(response);
  }
}
