import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ticketsystem/features/auth/presentation/provider/AuthProvider.dart';
import 'package:ticketsystem/features/profile/presentation/screens/ProfileScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  bool _obscurePassword = true;
  String? _selectedRole;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Consumer<AuthProvider>(builder: (context, provider, child) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo and App Name
                          Column(
                            children: [
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign up to get started',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),

                          SizedBox(
                            height: 16,
                          ),
                          if (provider.message.isNotEmpty &&
                              !provider.isLoggedIn)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                provider.message,
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 16,
                          ),

                          // Full Name TextField
                          TextField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _usernameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                              prefixIcon: Icon(Icons.person_4_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email TextField
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Mobile Number TextField
                          TextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(15),
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Mobile Number',
                              prefixIcon: Icon(Icons.phone_android_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password TextField
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password TextField
                          TextField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: () => _pickDate(context),
                            decoration: InputDecoration(
                              labelText: 'Select Birthdate',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),

                          const SizedBox(height: 24),
                          // Gender Selection (Radio Buttons inside Wrap to avoid overflow)
                          Center(
                            child: Text(
                              'I am',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 50,
                            runSpacing: 0,
                            alignment: WrapAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: 'user',
                                    groupValue: _selectedRole,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                                  ),
                                  const Text('An User'),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: 'organizer',
                                    groupValue: _selectedRole,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                                  ),
                                  const Text('An Organizer'),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // // Terms and Conditions
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       height: 24,
                          //       width: 24,
                          //       child: Checkbox(
                          //         value: _agreeToTerms,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             _agreeToTerms = value ?? false;
                          //           });
                          //         },
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(4),
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: Text.rich(
                          //         TextSpan(
                          //           text: 'I agree to the ',
                          //           style: TextStyle(
                          //             color: Colors.grey.shade700,
                          //             fontSize: 14,
                          //           ),
                          //           children: const [
                          //             TextSpan(
                          //               text: 'Terms of Service',
                          //               style: TextStyle(
                          //                 color: Colors.blue,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             TextSpan(text: ' and '),
                          //             TextSpan(
                          //               text: 'Privacy Policy',
                          //               style: TextStyle(
                          //                 color: Colors.blue,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 24),

                          // Register Button
                          ElevatedButton(
                            onPressed: provider.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      await provider.register(
                                        _emailController.text,
                                        _passwordController.text,
                                        _nameController.text,
                                        _mobileController.text,
                                        _selectedDate!,
                                        _usernameController.text,
                                      );

                                      if (provider.isLoggedIn) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              disabledBackgroundColor: Colors.blue.shade200,
                            ),
                            child: Text(
                              provider.isLoading
                                  ? 'Creating Account...'
                                  : 'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Or continue with
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or sign up with',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Social Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                onPressed: () {},
                                icon: Icons.g_mobiledata,
                                iconColor: Colors.red,
                              ),
                              const SizedBox(width: 16),
                              _buildSocialButton(
                                onPressed: () {},
                                icon: Icons.apple,
                                iconColor: Colors.black,
                              ),
                              const SizedBox(width: 16),
                              _buildSocialButton(
                                onPressed: () {},
                                icon: Icons.facebook,
                                iconColor: Colors.blue.shade800,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Sign In Text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color iconColor,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
