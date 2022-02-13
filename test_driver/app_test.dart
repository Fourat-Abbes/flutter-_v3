import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';
import 'dart:io';
import 'package:path/path.dart';

void main() {
  group('flutter iset app test', () {
    FlutterDriver driver;
    setUpAll(() async {
      await Process.run('C:/Users/Fourat/AppData/Local/Android/Sdk/platform-tools/adb.exe', [
    'shell',
    'pm',
    'grant',
    'thealphamerc.flutter_login_signup', // replace with your app id
    'android.permission.ACCESS_NETWORK_STATE',
  
  ]);
      await Process.run('C:/Users/Fourat/AppData/Local/Android/Sdk/platform-tools/adb.exe', [
    'shell',
    'pm',
    'grant',
    'thealphamerc.flutter_login_signup', // replace with your app id
    'android.permission.INTERNET',
  
  ]);
      await Process.run('C:/Users/Fourat/AppData/Local/Android/Sdk/platform-tools/adb.exe', [
    'shell',
    'pm',
    'grant',
    'thealphamerc.flutter_login_signup', // replace with your app id
    'android.permission.ACCESS_COARSE_LOCATION',
  
  ]);
      await Process.run('C:/Users/Fourat/AppData/Local/Android/Sdk/platform-tools/adb.exe', [
    'shell',
    'pm',
    'grant',
    'thealphamerc.flutter_login_signup', // replace with your app id
    'android.permission.CAMERA',
  
  ]);
  

      driver = await FlutterDriver.connect();
    });
    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    var textFiledEmail = find.byValueKey('Email');
    var textFiledPassword = find.byValueKey('Password');
    var buttonLogin = find.text('Login');
    var buttonQr = find.text('Code QR');
    var buttonHistorique = find.text('Historique');
    var buttonAllow = find.text('ALLOW');
    var textResult = find.text('Historique');
    var listFinder =find.byValueKey("list_matiere");
    var itemFinder = find.text('Atelier CMS');
    var detaillMatiere = find.text('Atelier CMS : Absence');
    
       /*  test("test login", () async {
      await driver.tap(textFiledEmail);
      await driver.enterText('Etudiant10@gmail.com');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(textFiledPassword);
      await driver.enterText('0000');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(buttonLogin);
      await Future.delayed(Duration(seconds: 2));

      await driver.waitUntilNoTransientCallbacks();

      expect((await driver.getText(textResult)), 'Historique');
    });*/

   /*test("test scanner error code", () async {
      await driver.tap(textFiledEmail);
      await driver.enterText('Etudiant10@gmail.com');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(textFiledPassword);
      await driver.enterText('0000');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(buttonLogin);
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(buttonQr);
      await Future.delayed(Duration(seconds: 2));

      var noButton= find.byValueKey('noButton');
      await driver.waitUntilNoTransientCallbacks();/* 
      await driver.waitFor(find.text('error code')); */
      expect((await driver.getText(noButton)), 'NO');
    });*/


test("verifers the list contains a specific item", () async {
      await driver.tap(textFiledEmail);
      await driver.enterText('Etudiant10@gmail.com');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(textFiledPassword);
      await driver.enterText('0000');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(buttonLogin);
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(buttonHistorique);
      await Future.delayed(Duration(seconds: 1));
      
      await driver.scrollUntilVisible(listFinder,itemFinder);

      await driver.tap(itemFinder);
      await Future.delayed(Duration(seconds: 1));
      

      await driver.waitUntilNoTransientCallbacks();

      expect((await driver.getText(detaillMatiere)), 'Atelier CMS : Absence');
    });

/*test("test scanner True Code", () async {
      await driver.tap(textFiledEmail);
      await driver.enterText('Etudiant10@gmail.com');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(textFiledPassword);
      await driver.enterText('0000');
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(buttonLogin);
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(buttonQr);
      await Future.delayed(Duration(seconds: 2));


      await driver.waitUntilNoTransientCallbacks();

      expect((await driver.getText(textResult)), 'Historique');
    });*/

  });
}
