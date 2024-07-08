import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'recipe_screen.dart';
import '/widgets/auth_widgets.dart';

enum AuthMode { register, login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.login;
  var _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.register;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  Row authOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _authMode == AuthMode.login
              ? 'Belum punya akun? '
              : 'Sudah punya akun? ',
          style: const TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: _switchAuthMode,
          child: Text(
            _authMode == AuthMode.login ? 'DAFTAR' : 'LOGIN',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.login) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((value) {
          Navigator.of(context)
              .pushReplacementNamed(RecipeScreen.routeName)
              .onError((error, stackTrace) => null);
        });
      } on FirebaseAuthException catch (error) {
        var errorMessage = '${error.code}: ${error.message}';
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage = 'Authentication failed! Please try again later.';
        _showErrorDialog(errorMessage);
      }
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((value) {
          Navigator.of(context).pushReplacementNamed(RecipeScreen.routeName);
        });
      } on FirebaseAuthException catch (error) {
        var errorMessage = '${error.code}: ${error.message}';
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage = 'Authentication failed! Please try again later.';
        _showErrorDialog(errorMessage);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        decoration: _authMode == AuthMode.login
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    hexStringToColor("cc9880"),
                    hexStringToColor("c71565"),
                    hexStringToColor("333337"),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
            : BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    hexStringToColor("333337"),
                    hexStringToColor("c71565"),
                    hexStringToColor("cc9880"),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
        child: _isLoading == true
            ? Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 50,
                ),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, deviceSize.height * 0.15, 20, 0),
                    child: Column(children: [
                      logoWidget("assets/images/logo.png"),
                      const SizedBox(height: 50),
                      reTextFF(
                          "Email", Icons.email, false, true, _emailController),
                      const SizedBox(height: 20),
                      reTextFF("Password", Icons.lock, true, false,
                          _passwordController),
                      const SizedBox(height: 20),
                      _authMode == AuthMode.login
                          ? reAuthButton(context, true, _submit)
                          : reAuthButton(context, false, _submit),
                      authOption(),
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
