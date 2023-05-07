import 'package:firebase_auth/firebase_auth.dart';

enum FirebaseAuthResultStatus {
  Successful,
  EmailAlreadyExists,
  WrongPassword,
  InvalidEmail,
  UserNotFound,
  UserDisabled,
  OperationNotAllowed,
  TooManyRequests,
  Undefined,
  AccountExistsWithDifferentCredential,
  InvalidCredential,
  WeakPassword
}

class FirebaseAuthExceptionHandler {
  static FirebaseAuthResultStatus handleException(FirebaseAuthException e) {
    FirebaseAuthResultStatus result;
    switch (e.code) {
      case 'invalid-email':
        result = FirebaseAuthResultStatus.InvalidEmail;
        break;

      case 'wrong-password':
        result = FirebaseAuthResultStatus.WrongPassword;
        break;

      case 'user-not-found':
        result = FirebaseAuthResultStatus.UserNotFound;
        break;

      case 'user-disabled':
        result = FirebaseAuthResultStatus.UserDisabled;
        break;

      case 'too-many-requests':
        result = FirebaseAuthResultStatus.TooManyRequests;
        break;

      case 'operation-not-allowed':
        result = FirebaseAuthResultStatus.OperationNotAllowed;
        break;

      case 'email-already-in-use':
        result = FirebaseAuthResultStatus.EmailAlreadyExists;
        break;
      case 'weak-password':
        result = FirebaseAuthResultStatus.WeakPassword;
        break;
      default:
        result = FirebaseAuthResultStatus.Undefined;
        break;
    }
    return result;
  }

  static String exceptionMessage(FirebaseAuthResultStatus result) {
    String? message = '';
    switch (result) {
      case FirebaseAuthResultStatus.Successful:
        message = 'ログインに成功しました。';
        break;
      case FirebaseAuthResultStatus.EmailAlreadyExists:
        message = '指定されたメールアドレスは既に使用されています。';
        break;
      case FirebaseAuthResultStatus.WrongPassword:
        message = 'パスワードが違います。';
        break;
      case FirebaseAuthResultStatus.WeakPassword:
        message = 'パスワードは６文字以上入力してください。';
        break;
      case FirebaseAuthResultStatus.InvalidEmail:
        message = 'メールアドレスが不正です。';
        break;
      case FirebaseAuthResultStatus.UserNotFound:
        message = '指定されたユーザーは存在しません。';
        break;
      case FirebaseAuthResultStatus.UserDisabled:
        message = '指定されたユーザーは無効です。';
        break;
      case FirebaseAuthResultStatus.OperationNotAllowed:
        message = '指定されたユーザーはこの操作を許可していません。';
        break;
      case FirebaseAuthResultStatus.TooManyRequests:
        message = '指定されたユーザーはこの操作を許可していません。';
        break;
      case FirebaseAuthResultStatus.AccountExistsWithDifferentCredential:
        message = '別のアカウントが存在します';
        break;
      case FirebaseAuthResultStatus.InvalidCredential:
        message = 'アカウントが不正です';
        break;
      case FirebaseAuthResultStatus.Undefined:
        message = '認証に失敗しました';
        break;
    }
    return message;
  }
}
