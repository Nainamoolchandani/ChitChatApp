import 'package:chitchatapp/brainpart/signupcontroller.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  bool obscurePassword = true;

  final GlobalKey<FormState> userForm = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  Future<void> createAccount() async {
    if (userForm.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await SignUpController.createAccount(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        country: countryController.text,
      );

      setState(() {
        isLoading = false;
      });

      emailController.clear();
      passwordController.clear();
      nameController.clear();
      countryController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: userForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Logo(),
                const SizedBox(height: 20.0),
                EmailField(controller: emailController),
                const SizedBox(height: 10.0),
                PasswordField(
                  controller: passwordController,
                  obscurePassword: obscurePassword,
                  togglePasswordVisibility: togglePasswordVisibility,
                ),
                const SizedBox(height: 10.0),
                NameField(controller: nameController),
                const SizedBox(height: 10.0),
                CountryField(controller: countryController),
                const SizedBox(height: 20),
                SignUpButton(
                  isLoading: isLoading,
                  onPressed: createAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: 50,
    );
  }
}

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter your email',
        suffixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Email is required";
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email address";
        }
        return null;
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback togglePasswordVisibility;

  const PasswordField({
    super.key,
    required this.controller,
    required this.obscurePassword,
    required this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.visiblePassword,
      controller: controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        suffixIcon: InkWell(
          onTap: togglePasswordVisibility,
          child: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Password is required";
        } else if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }
}

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter your name',
        suffixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }
}

class CountryField extends StatelessWidget {
  final TextEditingController controller;

  const CountryField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter your country',
        suffixIcon: const Icon(Icons.flag),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13.0)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Country is required";
        }
        return null;
      },
    );
  }
}

class SignUpButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SignUpButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        foregroundColor: Colors.white,
        backgroundColor:  Colors.blue,
      ),
      child: isLoading
          ? const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(color: Colors.white),
      )
          : const Text(
        'Create Account',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
