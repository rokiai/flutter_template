import 'package:flutter/material.dart';

import '../../../routing/app_router.dart';
import '../../common/ui/widgets/loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goMain());
  }

  Future<void> _goMain() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    const MainRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Loading()),
    );
  }
}
