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
  bool newAccount = true;

  @override
  Widget build(BuildContext context) {
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
            _buildConnectByEmailForm(),
            SizedBox(height: 3.0,),
            Text('מבטיחים לא לשלוח ספאם, רק סיפורים ושירים.', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 30.0,),
            _buildSwipeAccountType()
          ])
        ));
  }

  Widget _buildConnectByEmailForm() {
    return Consumer<AuthenticationModel>(
      builder: (BuildContext context, AuthenticationModel model, Widget child) {
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildEmailField(),
              _buildPasswordField(),
              newAccount ? _buildConfirmPasswordField() : Text(''),
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
                        int status = await model.daffLogin();
                        print(status);
                        if (!model.isLoading && status == 200) {
                          print('wow');
                          // Navigator.of(context).pushNamed(HomeScreen.routeName,);
                        }
                    })
                  )
                ])
            ],
          ));
    });
  }

  Widget _buildEmailField() {
    return TextFormField(
      onSaved: (String value) {
        Provider.of<AuthenticationModel>(context, listen: false).email = value;
      },
      // initialValue: 'michal@yashpe.com',
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

  Widget _buildConfirmPasswordField(){
    return TextFormField(
      onSaved: (String value) {
        Provider.of<AuthenticationModel>(context, listen: false).password = value;
      },
      // initialValue: 'michmich',
      validator: (String value) {
        if (value.isEmpty) return 'יש לאמת סיסמה';
        return null;
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(

        hintText: 'אימות סיסמה',
        labelText: 'אימות סיסמה *',
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      onSaved: (String value) {
        Provider.of<AuthenticationModel>(context, listen: false).password = value;
      },
      // initialValue: 'michmich',
      validator: (String value) {
        if (value.isEmpty) return 'יש להקליד סיסמה';
        return null;
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'סיסמה',
        labelText: 'סיסמה *',
      ),
    );
  }

  Widget _buildSwipeAccountType() {
    return newAccount ? 
      buildHyperLink(text: 'יש לי כבר חשבון',  onPressed: () => setState(() {newAccount = false;}))
      : Wrap(
        children: <Widget>[
        Text('אין לך חשבון? '),
        buildHyperLink(text: 'יצירת חשבון חדש', onPressed: () => setState(() {newAccount = true;}))
      ],
    )
      ;
  }
}
