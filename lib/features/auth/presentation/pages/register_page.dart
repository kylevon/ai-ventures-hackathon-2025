import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/auth_theme.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _diseaseController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedSex;
  String? _selectedGender;
  List<String> _selectedDiseases = [];
  bool _isLoading = false;

  // Animation controllers
  late List<AnimationController> _orbitControllers;
  late AnimationController _entranceController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _formSlideAnimation;

  static const int numCircles = 8;
  static const double goldenRatio = 1.618;
  static const double baseRadius = 80.0;

  static const List<String> sexOptions = ['male', 'female', 'other'];
  static const List<String> genderOptions = [
    'Male', 'Female', 'Non-binary', 'Other', 'Prefer not to say'
  ];
  static const List<String> commonDiseases = [
    'Diabetes', 'Hypertension', 'Heart Disease', 'Asthma',
    'Allergies', 'Celiac Disease', 'Lactose Intolerance'
  ];

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _diseaseController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userData = {
      'name': _nameController.text,
      'dateOfBirth': _selectedDate?.toIso8601String().split('T')[0],
      'height': double.tryParse(_heightController.text),
      'weight': double.tryParse(_weightController.text),
      'sex': _selectedSex,
      'gender': _selectedGender,
      'diseases': _selectedDiseases,
    };

    // TODO: Implement actual registration logic
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/login');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
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
                      'Create your account',
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: AuthTheme.inputDecoration('Full Name'),
                            validator: (value) =>
                                value?.isEmpty == true ? 'Please enter your name' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: AuthTheme.inputDecoration('Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value?.isEmpty == true ? 'Please enter your email' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: AuthTheme.inputDecoration('Password'),
                            obscureText: true,
                            validator: (value) =>
                                value?.isEmpty == true ? 'Please enter a password' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _dateController,
                            decoration: AuthTheme.inputDecoration('Date of Birth'),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            validator: (value) =>
                                value?.isEmpty == true ? 'Please select your date of birth' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  decoration: AuthTheme.inputDecoration('Height (cm)'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value?.isEmpty == true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  decoration: AuthTheme.inputDecoration('Weight (kg)'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value?.isEmpty == true ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedSex,
                            decoration: AuthTheme.inputDecoration('Sex'),
                            items: sexOptions.map((sex) => DropdownMenuItem(
                              value: sex,
                              child: Text(sex[0].toUpperCase() + sex.substring(1)),
                            )).toList(),
                            onChanged: (value) => setState(() => _selectedSex = value),
                            validator: (value) =>
                                value == null ? 'Please select your sex' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: AuthTheme.inputDecoration('Gender'),
                            items: genderOptions.map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            )).toList(),
                            onChanged: (value) => setState(() => _selectedGender = value),
                            validator: (value) =>
                                value == null ? 'Please select your gender' : null,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Medical Conditions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _diseaseController,
                                  decoration: AuthTheme.inputDecoration('Enter condition'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  if (_diseaseController.text.isNotEmpty) {
                                    setState(() {
                                      _selectedDiseases.add(_diseaseController.text.trim());
                                      _diseaseController.clear();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add_circle),
                                color: AuthTheme.primary[500],
                                tooltip: 'Add condition',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_selectedDiseases.isNotEmpty) ...[
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedDiseases.map((disease) => Chip(
                                label: Text(disease),
                                onDeleted: () {
                                  setState(() {
                                    _selectedDiseases.remove(disease);
                                  });
                                },
                                deleteIcon: const Icon(Icons.cancel, size: 18),
                              )).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                          const Text(
                            'Common conditions:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: commonDiseases.map((disease) => ActionChip(
                              label: Text(disease),
                              onPressed: () {
                                if (!_selectedDiseases.contains(disease)) {
                                  setState(() {
                                    _selectedDiseases.add(disease);
                                  });
                                }
                              },
                            )).toList(),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: AuthTheme.primaryButtonStyle,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text('Register', style: AuthTheme.buttonTextStyle),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => context.go('/login'),
                            child: Text(
                              'Already have an account? Login',
                              style: AuthTheme.registerButtonTextStyle,
                            ),
                          ),
                        ],
                      ),
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
} 