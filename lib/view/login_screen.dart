import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../TaskBloc/task_bloc.dart';
import '../TaskBloc/task_event.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwrdCtrl = TextEditingController();

  final _Email = 'ivory@gmail.com';
  final _Password = '12345678';

  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwrdCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(Duration(seconds: 2),(){
        setState(() {
          _isLoading=false;
        });
        if (_emailCtrl.text.trim() == _Email && _passwrdCtrl.text.trim() == _Password){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => TaskBloc()..add(LoadTasks()),
                child: const HomeScreen(),
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        else{

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Credentials'),
              backgroundColor: Color.fromARGB(255, 182, 9, 9),
              duration: Duration(seconds: 2),
            ),
          );        }
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Center(child: const Text('Login',style: TextStyle(color: Colors.white),))),
      body: Form(
        key: _formKey,
        child:  Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: const Image(
                      image: AssetImage("assets/images/todo_icon.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'you@example.com',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
              
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _passwrdCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          borderSide: const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? '').isEmpty) return 'Password is required';
                        if (v!.length < 6) return 'Minimum 6 characters';
                        return null;
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text('Forgot password?'),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Login')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),),
    );
  }
}
