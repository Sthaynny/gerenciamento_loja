import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/controllers/login_controller/login_controller.dart';
import 'package:gerenciamento_loja/views/home_screen/home_screen.dart';
import 'package:gerenciamento_loja/views/login_screen/widgets/input_field/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = LoginController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loginController.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          break;
        case LoginState.FAIL:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Erro"),
              content: Text("Você não possui os privilégios necessarios!"),
            ),
          );
          break;
        case LoginState.IDLE:
        case LoginState.LOADING:
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginController.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          print(snapshot.data);
          switch (snapshot.data) {
            case LoginState.LOADING:
              // TODO: Handle this case.
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
                ),
              );
              break;
            case LoginState.FAIL:
            case LoginState.IDLE:
            case LoginState.SUCCESS:
              // TODO: Handle this case.
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.store_mall_directory,
                            color: Colors.deepOrangeAccent,
                            size: 160,
                          ),
                          InputField(
                            inputType: TextInputType.emailAddress,
                            icon: Icons.person_outline,
                            hint: 'Usuário',
                            obscure: false,
                            stream: _loginController.outEmail,
                            onChanged: _loginController.changedEmail,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: 'Senha',
                            obscure: true,
                            stream: _loginController.outPassword,
                            onChanged: _loginController.changedPassword,
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          StreamBuilder<bool>(
                              stream: _loginController.outSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    disabledColor: Colors.deepOrangeAccent[100],
                                    onPressed: snapshot.hasData
                                        ? _loginController.submet
                                        : null,
                                    color: Colors.deepOrangeAccent,
                                    child: Text(
                                      'Entar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              );
              break;
          }
        },
      ),
    );
  }
}
