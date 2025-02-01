import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/auth_theme.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late List<AnimationController> _orbitControllers;
  late AnimationController _entranceController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _formSlideAnimation;
  bool _isLoading = false;

  static const int numCircles = 8;
  static const double baseRadius = 80.0;

  @override
  void initState() {
    super.initState();

    // Create separate controllers for each orbit
    _orbitControllers = List.generate(
      numCircles,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(seconds: 10 + (index * 5)),
      )..repeat(),
    );

    // Entrance animations controller
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _titleOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _formSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start the entrance animations
    _entranceController.forward();
  }

  @override
  void dispose() {
    for (var controller in _orbitControllers) {
      controller.dispose();
    }
    _entranceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AuthTheme.gray[100],
      body: Stack(
        children: [
          // Animated circles
          ...List.generate(
            numCircles,
            (index) => AnimatedBuilder(
              animation: _orbitControllers[index],
              builder: (context, child) {
                final angle = _orbitControllers[index].value * 2 * math.pi;
                final radiusFactor = 1.0 + (index * 0.5);
                final wobble = math.sin(angle * 2) * 10;

                return Positioned(
                  left: screenSize.width / 2 +
                      (baseRadius * radiusFactor * math.cos(angle)) +
                      (wobble * math.sin(angle * 3)),
                  top: screenSize.height / 2 +
                      (baseRadius * radiusFactor * math.sin(angle)) +
                      (wobble * math.cos(angle * 2)),
                  child: Container(
                    width: 20 - (index * 1.5),
                    height: 20 - (index * 1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AuthTheme.orbitColors[index],
                    ),
                  ),
                );
              },
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AuthTheme.gray[100],
                        boxShadow: [
                          BoxShadow(
                            color: AuthTheme.primary[900]!.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/michro_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  FadeTransition(
                    opacity: _titleOpacityAnimation,
                    child: const Text(
                      'chronobiology in your pocket',
                      style: AuthTheme.titleStyle,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Form
                  AnimatedBuilder(
                    animation: _formSlideAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _formSlideAnimation.value),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: AuthTheme.inputDecoration('Email'),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: AuthTheme.inputDecoration('Password'),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                          onSubmitted: (_) => _handleLogin(),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: AuthTheme.primaryButtonStyle,
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AuthTheme.gray[100]!,
                                    ),
                                  ),
                                )
                              : Text('Log in',
                                  style: AuthTheme.buttonTextStyle),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  context.go('/register');
                                },
                          child: Text(
                            'Register',
                            style: AuthTheme.registerButtonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      await AuthService().login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        context.go('/input');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
