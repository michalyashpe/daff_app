import 'package:daff_app/authentication_model.dart';
import 'package:daff_app/widgets/hyperlink.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailConnectScreen extends StatefulWidget {
  EmailConnectScreen();
  _EmailConnectScreenState createState() => _EmailConnectScreenState();
}

class _EmailConnectScreenState extends State<EmailConnectScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _passwordForVerification;
  @override
  void initState() {
    Provider.of<AuthenticationModel>(context, listen: false).initialize(firstTime: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationModel>(
      builder: (BuildContext context, AuthenticationModel model, Widget child) {
        return Scaffold(
      appBar: AppBar(
        title: Text('כניסה עם אימייל'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildConnectByEmailForm(model),
            SizedBox(height: 3.0,),
            Text('מבטיחים לא לשלוח ספאם, רק סיפורים ושירים.', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 30.0,),
            _buildSwipeAccountType(model)
          ])
        ));});
  }

  Widget _buildConnectByEmailForm(AuthenticationModel model) {
    return  Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              model.user.authenticationToken != null ? Text(model.user.authenticationToken, style: TextStyle(color: Colors.blue)) : SizedBox(),
              model.firstLogin ? Text('אנחנו כמעט שם. יש לאשר את המייל שנשלח אליך זה עתה.', style: TextStyle(color: Colors.green, fontSize: 15.0)) : SizedBox(),
              model.errors.length > 0 ? Text(model.errors.map((e) => e).join(), style: TextStyle(color: Colors.red, fontSize: 15.0)) : SizedBox(),
              _buildEmailField(model.email),
              _buildPasswordField(model.password),
              model.newAccount ? _buildConfirmPasswordField() : SizedBox(),
              SizedBox(height: 30.0,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('כניסה', style: TextStyle(fontSize: 20.0)),
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) return;
                        _formKey.currentState.save();
                        int status = model.newAccount ? await model.signUp() : await model.logIn();
                        if (!model.isLoading && status == 200) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                    })
                  )
                ])
            ],
          ));
    
  }

  Widget _buildEmailField(String email) {
    return TextFormField(
      onSaved: (String value) {
        Provider.of<AuthenticationModel>(context, listen: false).email = value;
      },
      initialValue: email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'you@example.com',
        labelText: 'כתובת מייל *',
      ),
      validator: (String value) {
        if (value.isEmpty)
          return 'יש להקליד כתובת מייל';
        else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) return 'כתובת המייל אינה תקינה';
        return null;
      },
    );
  }


  Widget _buildPasswordField(String password) {
    return TextFormField(
      onChanged: (String value) => _passwordForVerification = value,
      onSaved: (String value) {
        Provider.of<AuthenticationModel>(context, listen: false).password = value;
      },
      initialValue: password,
      validator: (String value) {
        if (value.isEmpty) return 'יש להקליד סיסמה';
        return null;
      },
      obscureText: !passwordVisibility['password'],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'סיסמה',
        labelText: 'סיסמה *',
        suffixIcon:  buildTogglePasswordButton('password')
      ),
    );
  }

  Map<String, bool> passwordVisibility = {
    'password': false,
    'passwordVerification': false
  };




  Widget _buildConfirmPasswordField(){
    return TextFormField(
      onSaved: (String value) {
        // _verifiedPassword = value;
      },
      validator: (String value) {
        print(_passwordForVerification);
        if (value.isEmpty) return 'יש לאמת סיסמה';
        else if (value != _passwordForVerification )
          return 'הסיסמה לא תואמת';
        return null;
      },
      obscureText: !passwordVisibility['passwordVerification'],
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'אימות סיסמה',
        labelText: 'אימות סיסמה *',
        suffixIcon: buildTogglePasswordButton('passwordVerification')
      ),
    );
  }

  Widget buildTogglePasswordButton(String key){
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(passwordVisibility[key] ? Icons.visibility : Icons.visibility_off,),
      onPressed: () {
          setState(() {
              passwordVisibility[key] = !passwordVisibility[key];
          });
        },
      );
  }

  Widget _buildSwipeAccountType(AuthenticationModel model) {
    model.initialize();
    return model.newAccount ? 
      buildHyperLink(text: 'יש לי כבר חשבון',  onPressed: () => setState(() {model.newAccount = false;}))
      : buildHyperLink(text: 'יצירת חשבון חדש', onPressed: () => setState(() {model.newAccount = true;})
      ,
    )
      ;
  }
}
