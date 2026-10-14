import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/auth/app_user.dart';
import 'package:pawsetu/core/auth/auth_service.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FakeFirebaseFirestore db;
  late DemoAuthService auth;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = FakeFirebaseFirestore();
    await DemoStore.loadInto(db, DemoSeed.build(DateTime(2026, 10, 14)));
    auth = DemoAuthService(db, await SharedPreferences.getInstance());
  });

  Future<AppUser?> nextUser() => auth.userChanges().firstWhere((u) => u != null);

  test('email sign-in with the demo password', () async {
    await auth.signInWithEmail('priya@example.com', 'demo1234');
    final u = await nextUser();
    expect(u!.name, 'Priya Sharma');
    expect(u.isPlus, isTrue);
  });

  test('wrong password is refused', () async {
    expect(() => auth.signInWithEmail('priya@example.com', 'nope'), throwsA(isA<AuthFailure>()));
  });

  test('phone OTP 123456 signs Ravi in', () async {
    final id = await auth.startPhoneSignIn('90000 00002');
    await auth.confirmPhoneCode(id, '123456');
    expect((await nextUser())!.uid, 'u_ravi');
  });

  test('one-tap demo login gives partner roles', () async {
    await auth.signInAsDemo('u_groomer');
    final u = await nextUser();
    expect(u!.role, UserRole.groomer);
    expect(u.partnerId, 'prov_groom_1');
  });

  test('sign-up needs email verification', () async {
    await auth.signUpWithEmail('New Person', 'new@example.com', 'secret1');
    final u = await nextUser();
    expect(u!.emailVerified, isFalse);
    expect(u.onboarded, isFalse);
    final outbox = await db.collection('outbox').where('to', isEqualTo: 'new@example.com').get();
    expect(outbox.docs, isNotEmpty);
  });
}
