import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/helpers/firebase_api.dart';
import 'package:daff_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.firebaseAPI);
  final FirebaseAPI firebaseAPI;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationModel>(
      builder: (BuildContext context,  AuthenticationModel model, Widget child) {
        // return model.isLoading ? CircularProgressIndicator() :
        return Scaffold(
          appBar: AppBar(
            title: Text('כניסה'),
          ),
          body: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLoginForm(model),
              ],
            ),
          ),
        ); });
  }

  Widget _buildLoginForm(AuthenticationModel model){
    void onPressedFunction() async {
      if (!_formKey.currentState.validate()) return;
      _formKey.currentState.save();
      String deviceToken = widget.firebaseAPI.deviceToken ;
      int status = await model.daffLogin(deviceToken);
      if (!model.isLoading && status == 200) {
        // Navigator.of(context).pushNamed(HomeScreen.routeName,);
      }

    }
    return Form(                                                                                                          // form knows about the TextFormFields exist as children, this is automatic behind the scenes, form is a stateful widget by default because it re-renders when a user inputs text
      key: _formKey,  
      child: Column(children: <Widget>[
      _buildEmailField(model),
        _buildPasswordField(model),
        SizedBox(height: 10.0,),
        RaisedButton(
          child: Text('כניסה'),
          onPressed:() => onPressedFunction()
        )
      ],)
    );

  }

  Widget _buildEmailField(AuthenticationModel model){
    return TextFormField(
        onSaved: (String value) {
        model.email = value;
      },
      initialValue: 'michal@yashpe.com',
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'you@example.com',
        labelText: 'כתובת מייל *',
      ),
      validator: (String value) {
        if (value.isEmpty)
          return 'יש להקליד כתובת מייל';
        else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
          return 'כתובת המייל אינה תקינה';
        return null;
      },

    );
  }
   Widget _buildPasswordField(AuthenticationModel model){
    return TextFormField(
        onSaved: (String value) {
        model.password = value;
      },
      initialValue: 'michmich',
      validator: (String value) {
        if (value.isEmpty)
          return 'יש להקליד סיסמה';
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'סיסמה',
        labelText: 'סיסמה *',
      ),

    );
  }




  
}
