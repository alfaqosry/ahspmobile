import 'package:ahsp2/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';

class LoginScren extends StatefulWidget {
  const LoginScren({super.key});

  @override
  State<LoginScren> createState() => _LoginScrenState();
}

class _LoginScrenState extends State<LoginScren> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<Auth>(
      builder: (context, value, child) {
        if (value.isLoading == true) {
          return Center(
            child: LoadingAnimationWidget.waveDots(
              color: GFColors.DARK,
              size: 50,
            ),
          );
        } else {
          return Container(
            color: Color.fromRGBO(246, 249, 255, 1),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(
                              'SYSTEM AHSP ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(68, 68, 68, 1)),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                                'Masukan username & password to Login',
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 6.0),
                                  border: OutlineInputBorder(),
                                  hintText: "Masukan Username"),
                              controller: _usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan username yang valid';
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Masukan Password",
                              ),
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan Password yang valid';
                                }
                                return null;
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(500, 40)),
                                onPressed: () {
                                  Map creds = {
                                    "username": _usernameController.text,
                                    "password": _passwordController.text,
                                  };
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    Provider.of<Auth>(context, listen: false)
                                        .login(creds: creds);

                                    Center(
                                      child: LoadingAnimationWidget.waveDots(
                                        color: GFColors.DARK,
                                        size: 50,
                                      ),
                                    );
                                    context.goNamed('main_page');
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    ));
  }
}
