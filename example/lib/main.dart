/// AI-powered customer service UIKit for Tencent Cloud Desk.

import 'package:example/utils/generate_userSig.dart';
import 'package:flutter/material.dart';
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';

import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tencent Cloud Desk Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0052D9)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _userIdController = TextEditingController();
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Tencent Cloud Desk'),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Image.asset(
                'assets/logo.png', // Replace with your logo path
                height: 48,
                width: 48,
              ),
              const SizedBox(height: 32),

              // Introduction Text
              Text(
                'Deliver world-class customer support with our desk solution, aiming to resolve customer’s issues quickly and increase satisfaction on your platform.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 62),

              // User ID Input
              TextField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'Enter a UserID',
                  labelStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Phase 1 Button: Initialize and Login
              ElevatedButton(
                onPressed: _isLoggedIn ? null : () async {
                  final userId = _userIdController.text.trim();
                  if (userId.isNotEmpty) {
                    final res = await TencentCloudAIDeskCustomer.init(
                      sdkAppID: TencentCloudDeskCustomerDemoConfig.sdkAppID,
                      userID: userId,
                      userSig: GenerateDevUsersigForTest(
                        sdkappid: TencentCloudDeskCustomerDemoConfig.sdkAppID,
                        key: TencentCloudDeskCustomerDemoConfig.secret,
                      ).genSig(identifier: userId, expire: 999999),
                      config: TencentCloudCustomerConfig(),
                    );
                    if (res.code == 0) {
                      setState(() {
                        _isLoggedIn = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login successful!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed: ${res.desc}')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid UserID')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Phase 1: Initialize and Login',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use `TencentCloudCustomer.init` to initialize the Customer UIKit, configure global options, and log in.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // Phase 2 Button: Navigate to Chat
              ElevatedButton(
                onPressed: _isLoggedIn
                    ? () {
                  TencentCloudAIDeskCustomer.navigate(
                    customerServiceID: TencentCloudDeskCustomerDemoConfig.customerServiceID,
                    context: context,
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Phase 2: Start Chat',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use `TencentCloudCustomer.navigate` to open a chat with a specific customer service account and configure individual session settings.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}
