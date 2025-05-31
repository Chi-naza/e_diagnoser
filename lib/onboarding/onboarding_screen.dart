import 'package:e_diagnoser/core/capture_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 60),
      pages: [
        PageViewModel(
          title: "A healthy cassava; all green and full",
          body:
              "Although a perennial plant, cassava is extensively cultivated in tropical and subtropical regions as an annual crop for its edible starchy tuberous root.",
          image: Center(child: Image.asset("assets/images/cassava.jpg")),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            bodyTextStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
        ),
        PageViewModel(
          title: "A healthy potato; fleshy and strong",
          body:
              "Potatoes are underground tubers of the plant Solanum tuberosum, a perennial in the nightshade family Solanaceae.",
          image: Center(child: Image.asset("assets/images/potato.jpg")),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            bodyTextStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
        ),
        PageViewModel(
          title: "A healthy yam is what this represents",
          body:
              "Yams are perennial herbaceous vines native to Africa, Asia, and the Americas and cultivated for the consumption of their starchy tubers",
          image: Center(child: Image.asset("assets/images/yam.png")),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            bodyTextStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Text("Next"),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CaptureMainScreen()),
        );
      },
      onSkip: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CaptureMainScreen()),
        );
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
