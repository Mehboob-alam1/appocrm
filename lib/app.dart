import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/navigation/app_navigator.dart';
import 'package:appocrm/screens/main_shell.dart';
import 'package:appocrm/screens/onboarding_screen.dart';
import 'package:appocrm/services/onboarding_prefs.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:appocrm/widgets/after_call_prompt_listener.dart';
import 'package:flutter/material.dart';

class AppomatrixApp extends StatefulWidget {
  AppomatrixApp({super.key, CrmRepository? repository})
      : repository = repository ?? CrmRepository();

  final CrmRepository repository;

  @override
  State<AppomatrixApp> createState() => _AppomatrixAppState();
}

class _AppomatrixAppState extends State<AppomatrixApp> {
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _loadOnboarding();
  }

  Future<void> _loadOnboarding() async {
    final complete = await OnboardingPrefs.isComplete();
    if (mounted) setState(() => _onboardingComplete = complete);
  }

  void _onOnboardingFinished() {
    setState(() => _onboardingComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Appomatrix CRM',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: _onboardingComplete == null
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _onboardingComplete!
              ? AfterCallPromptListener(
                  repository: widget.repository,
                  child: MainShell(repository: widget.repository),
                )
              : OnboardingScreen(onFinished: _onOnboardingFinished),
    );
  }
}
