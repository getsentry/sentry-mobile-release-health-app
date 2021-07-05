import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../screens/connect/connect_screen.dart';
import '../../screens/onboarding/onboarding_consent_screen.dart';
import '../../screens/onboarding/onboarding_info_screen.dart';
import '../../utils/sentry_colors.dart';
import 'onboarding_detail_screen.dart';
import 'onboarding_screen_item.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _pageItems = OnboardingScreenItem.values;
  var _currentPage = 0;

  @override
  void didChangeDependencies() {
    // Pre-cache images used in onboarding flow.
    precacheImage(Image.asset('assets/onboarding_1_a.png').image, context);
    precacheImage(Image.asset('assets/onboarding_1_b.png').image, context);
    precacheImage(Image.asset('assets/onboarding_2.png').image, context);
    precacheImage(Image.asset('assets/onboarding_3.png').image, context);
    precacheImage(Image.asset('assets/sitting-logo.jpg').image, context);
    precacheImage(Image.asset('assets/reading-logo.jpg').image, context);
    precacheImage(Image.asset('assets/user-menu.png').image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        PageView.builder(
          controller: _pageController,
          itemCount: _pageItems.length,
          onPageChanged: (int page) {
            _updateCurrentPage(page);
          },
          itemBuilder: (context, index) {
            return _widgetForItem(_pageItems[index]);
          },
        ),
        Container(
          margin: EdgeInsets.only(bottom: 32),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < _pageItems.length; i++)
                i == _currentPage
                    ? _circleIndicator(true)
                    : _circleIndicator(false),
            ],
          ),
        )
      ]),
    );
  }

  Widget _circleIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive
              ? SentryColors.rum
              : SentryColors.rum.withAlpha((256 * 0.2).toInt()),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  void _updateCurrentPage(int page) {
    _currentPage = page;
    setState(() {});
  }

  void _animateToLastPage() {
    _pageController.animateToPage(_pageItems.length - 1,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget _widgetForItem(OnboardingScreenItem item) {
    switch (item) {
      case OnboardingScreenItem.IMAGE_1:
        return OnboardingDetailScreen(
            'assets/onboarding_1_a.png',
            'assets/onboarding_1_b.png',
            'Start your day with Sentry. We\'re sorry in advance.');
      case OnboardingScreenItem.IMAGE_2:
        return OnboardingDetailScreen('assets/onboarding_2.png', null,
            'Hey, there\'s a chance things are going well. If so, go back to bed!');
      case OnboardingScreenItem.IMAGE_3:
        return OnboardingDetailScreen('assets/onboarding_3.png', null,
            'Really though, Sentry will show you everything that is on fire. You\'re welcome!');
      case OnboardingScreenItem.INFO:
        return OnboardingInfoScreen();
      case OnboardingScreenItem.CONSENT:
        return OnboardingConsentScreen(() {
          _animateToLastPage();
        });
      case OnboardingScreenItem.CONNECT:
        return ConnectScreen();
    }
  }
}
