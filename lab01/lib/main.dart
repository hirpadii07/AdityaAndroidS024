import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString('username');
      String? savedPassword = prefs.getString('password');
      print('Loaded Username: $savedUsername'); // Debug print
      print('Loaded Password: $savedPassword'); // Debug print
      if (savedUsername != null && savedPassword != null) {
        setState(() {
          _usernameController.text = savedUsername;
          _passwordController.text = savedPassword;
        });
        final snackBar = SnackBar(
          content: Text('Login information loaded'),
          action: SnackBarAction(
            label: 'Clear Saved Data',
            onPressed: () {
              _clearSavedData();
            },
          ),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        print('No saved data found.');
      }
    } catch (e) {
      print('Error loading saved data: $e');
    }
  }

  Future<void> _clearSavedData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('password');
      setState(() {
        _usernameController.text = '';
        _passwordController.text = '';
      });
      print('Cleared saved data.');
    } catch (e) {
      print('Error clearing saved data: $e');
    }
  }

  Future<void> _saveData(String username, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      print('Saved Username: $username'); // Debug print
      print('Saved Password: $password'); // Debug print
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Login Information'),
          content: Text('Would you like to save your username and password for next time?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _saveData(_usernameController.text, _passwordController.text);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                _clearSavedData();
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSaveDialog();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
