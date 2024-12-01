import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/navigation/bottom_nav_bar.dart';
import 'package:haron_pos/reports/widgets/custom_text.dart';
import 'package:haron_pos/widgets/custom_buton.dart';
import 'package:haron_pos/widgets/custom_form.dart';
import 'package:haron_pos/constants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isFormValid = false;

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(33, 64, 7, 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/icon/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  HeadingText("Welcome"),
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/icon/wave.png',
                    height: 50,
                    width: 50,
                  )
                ],
              ),
              Row(
                children: [
                  HeadingText('to'),
                  const SizedBox(width: 5),
                  Text(
                    'Haron POS',
                    style: GoogleFonts.lexend(
                      color: primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              SubText("Hello there, Sign up to continue"),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
                child: SizedBox(
                  width: 335,
                  height: 56,
                  child: CustomForm(
                    controller: _emailController,
                    isPasswordVisible: false,
                    labelText: "Email Address",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SizedBox(
                  width: 335,
                  height: 56,
                  child: CustomForm(
                    controller: _passwordController,
                    isPasswordVisible: true,
                    labelText: "Password",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_emailController.text == '1' &&
                      _passwordController.text == '1') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavBar(),
                      ),
                    );
                    Hive.box('userBox').put('userEmail', _emailController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: inactiveButtonColor,
                        content: Text("Please check your credentials"),
                      ),
                    );
                  }
                },
                child: PrimaryButton(
                  text: "Sign up",
                  color: _isFormValid ? primaryColor : inactiveButtonColor,
                  textColor: _isFormValid ? white : inactiveTextColorForButton,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          height: 1,
                          width: 140,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SubText("Or continue with social account"),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          height: 1,
                          width: 150,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("google login");
                  // Implement Google login with BLoC if needed
                },
                child: Container(
                  width: 335,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    border: Border.all(
                      color: const Color.fromRGBO(172, 175, 181, 0.2),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/google.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Google",
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.21),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NormalAppText(
                      text: "Did you already have an account?",
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    const SizedBox(width: 7),
                    GestureDetector(
                      onTap: () {
                        // Implement login navigation
                      },
                      child: NormalAppText(
                        textColor: primaryColor,
                        text: "Login",
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
