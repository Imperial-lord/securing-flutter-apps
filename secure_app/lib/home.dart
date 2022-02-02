import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Form controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Flutter Secure Storage
  final flutterSecureStorage = const FlutterSecureStorage();

  // Event handlers
  void saveCredentialHandler() async {
    FocusManager.instance.primaryFocus?.unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Saved data to secure storage',
        ),
      ),
    );
    await flutterSecureStorage.write(
        key: usernameController.text, value: passwordController.text);
  }

  void showCredentialHandler() async {
    String? password = await flutterSecureStorage.read(
      key: usernameController.text,
    );
    Map credentials = {
      'username': usernameController.text,
      'password': password,
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CredentialsPage(
          credentials: credentials,
        ),
      ),
    );
  }

  void detectJailBreakHandler() async {
    // check for jailbreak
    bool developerMode = await FlutterJailbreakDetection.developerMode;
    if (kDebugMode) {
      print(developerMode);
    }
  }

  // Widget
  Widget textField(
      TextEditingController controller, String placeholder, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CupertinoTextField(
        controller: controller,
        padding: const EdgeInsets.all(15),
        placeholder: placeholder,
        obscureText: obscureText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Secure App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Username'),
              textField(usernameController, 'Enter your username', false),
              const Text('Password'),
              textField(passwordController, 'Enter your password', true),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => saveCredentialHandler(),
                    child: const Text('Save credentials'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => showCredentialHandler(),
                    child: const Text('Show user credentials'),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => detectJailBreakHandler(),
                  child: const Text('Check for jailbreak'),
                ),
              ),
            ],
          ),
        ));
  }
}

class CredentialsPage extends StatelessWidget {
  final Map credentials;

  const CredentialsPage({Key? key, required this.credentials})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Credentials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${credentials['username']}'),
            Text('Password: ${credentials['password']}'),
          ],
        ),
      ),
    );
  }
}
