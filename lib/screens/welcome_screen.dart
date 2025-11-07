// In welcome_screen.dart
import '../components/button.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'TypeWriterLogoAnimated.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// Add 'with SingleTickerProviderStateMixin' to enable animation.
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // 1. Define the controller and animation for the background.
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();

    // 2. Initialize the controller and the color tween.
    _backgroundController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.grey[800], // Dark start color
      end: Colors.white, // Light end color
    ).animate(_backgroundController);

    // 3. Start the animation.
    _backgroundController.forward();

    // 4. Add a listener to rebuild the screen on each animation frame.
    _backgroundController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // 5. IMPORTANT: Always dispose of controllers.
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 6. Use the animation value for the background color.
      backgroundColor: _backgroundColorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                // Use the simplified TypeWriterLogoAnimated widget.
                // It has no color animation properties.
                TypeWriterLogoAnimated(
                  text: 'Flash Chat',
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black, // Set the final text color here.
                  ),
                ),
              ],
            ),
            SizedBox(height: 48.0),
            // Your Button widgets remain correct.
            Button(
              label: 'Login',
              color: Colors.lightBlueAccent,
              id: LoginScreen.id,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            Button(
              label: 'Register',
              color: Colors.blueAccent,
              id: RegistrationScreen.id,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// **FIX FOR YOUR BUTTONFunction*

