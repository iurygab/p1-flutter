import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

// Classe para gerenciar usuários
class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  final List<Map<String, String>> _users = [];

  UserManager._internal();

  void addUser(String name, String email, String password) {
    _users.add({'name': name, 'email': email, 'password': password});
  }

  bool validateUser(String email, String password) {
    for (var user in _users) {
      // Verifica se o email e a senha estão corretos
      if (user['email'] == email && user['password'] == password) {
        return true; // Retorna verdadeiro se o usuário for encontrado
      }
    }
    return false; // Retorna falso se o usuário não for encontrado
  }

  bool emailExists(String email) {
    for (var user in _users) {
      if (user['email'] == email) {
        return true;
      }
    }
    return false;
  }

  void updateUserPassword(String email, String newPassword) {
    for (var user in _users) {
      if (user['email'] == email) {
        user['password'] = newPassword; // Atualiza a senha
        break;
      }
    }
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configuração do controlador de animação
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Animação de opacidade
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Inicia a animação
    _controller.forward();

    // Redireciona para a tela de onboarding após 5 segundos
    Timer(Duration(seconds: 5), () {
      _navigateToOnboarding();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
         
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromRGBO(46, 46, 46, 0.933),
    body: Center(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/home.png', // Substitua pelo caminho da sua imagem de fundo
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Ajuste o valor da opacidade conforme necessário (0.5 é 50% de transparência)
            height: double.infinity,
            width: double.infinity,
          ),
          // Camada de imagens sobre a imagem de fundo com efeito de fade
          FadeTransition(
            opacity: _animation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Primeira imagem
                  Image.asset(
                    'assets/images/Welcome To.png', // Substitua pelo caminho da sua primeira imagem
                    width: 200, // Ajuste o tamanho conforme necessário
                    height: 100,
                  ),
                  SizedBox(height: 0),
                  // Segunda imagem
                  Image.asset(
                    'assets/images/Group.png', // Substitua pelo caminho da sua segunda imagem
                    width: 200,
                    height: 100,
                  ),
                 
                  // Terceira imagem
                  Image.asset(
                    'assets/images/FITBODY.png', // Substitua pelo caminho da sua terceira imagem
                    width: 200,
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> _icons = [
    'assets/images/Work Out.png',
    'assets/images/Nutrition.png',
    'assets/images/Community.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildPage(
            'Start Your Journey Towards A More Active Lifestyle',
            'assets/images/workout1.png',
          ),
          _buildPage(
            'Find Nutrition Tips That Fit Your Lifestyle',
            'assets/images/workout2.png',
          ),
          _buildPage(
            'A Community For You, Challenge Yourself',
            'assets/images/workout3.png',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title, String imagePath) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(horizontal: 0.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 179, 160, 255),
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Column(
                children: [
                  Image.asset(
                    _icons[_currentPage],
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDotIndicator(),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_currentPage < 2)
              _buildNextButton()
            else
              _buildStartButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        _controller.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(132, 99, 98, 98),
        foregroundColor:
            Colors.white, // Substituído para usar o foregroundColor
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      ),
      child: Text('Next', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(132, 99, 98, 98),
        foregroundColor:
            Colors.white, // Substituído para usar o foregroundColor
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
      ),
      child: Text('Get Started', style: TextStyle(fontSize: 18)),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            _buildTextField(_emailController, 'Username or email'),
            SizedBox(height: 16),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildLoginButton(context),
            SizedBox(height: 16),
            Text(
              'or sign up with',
              style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
            ),
            SizedBox(height: 16),
            _buildSocialMediaButtons(),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Color.fromARGB(255, 179, 160, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _login(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Log In',
        style: GoogleFonts.poppins(fontSize: 18),
      ),
    );
  }

  Widget _buildSocialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.g_mobiledata, color: Colors.white),
          onPressed: () {},
        ),
        SizedBox(width: 16),
        IconButton(
          icon: Icon(Icons.facebook, color: Colors.white),
          onPressed: () {},
        ),
        SizedBox(width: 16),
        IconButton(
          icon: Icon(Icons.fingerprint, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  void _login(BuildContext context) {
    String email = _emailController.text.trim(); // Remove espaços em branco
    String password = _passwordController.text;

    // Verifica se o usuário existe
    if (UserManager().validateUser(email, password)) {
      // Usuário encontrado, redireciona para a página de sucesso
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessPage()),
      );
    } else {
      // Exibe uma mensagem de erro se o usuário não for encontrado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email ou senha inválidos")),
      );
    }
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success')),
      body: Center(
        child: Text(
          'Log In successfully!!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let\'s Start!',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            _buildTextField(_nameController, 'Full Name'),
            SizedBox(height: 16),
            _buildTextField(_emailController, 'Email or Mobile Number'),
            SizedBox(height: 16),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            SizedBox(height: 16),
            _buildTextField(_confirmPasswordController, 'Confirm Password',
                obscureText: true),
            SizedBox(height: 24),
            _buildSignUpButton(context),
            SizedBox(height: 16),
            Text(
              'By continuing, you agree to Terms of Use and Privacy Policy.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.7), fontSize: 12),
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            _buildSocialMediaButtons(),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Already have an account? Log In',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Color.fromARGB(255, 179, 160, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _signUp(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Sign Up',
        style: GoogleFonts.poppins(fontSize: 18),
      ),
    );
  }

  Widget _buildSocialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.g_mobiledata, color: Colors.white),
          onPressed: () {},
        ),
        SizedBox(width: 16),
        IconButton(
          icon: Icon(Icons.facebook, color: Colors.white),
          onPressed: () {},
        ),
        SizedBox(width: 16),
        IconButton(
          icon: Icon(Icons.fingerprint, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  void _signUp(BuildContext context) {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    // Adiciona o novo usuário
    UserManager().addUser(name, email, password);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Account created successfully!")),
    );

    Navigator.pop(context);
  }
}

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            _buildTextField(_emailController, 'Enter your email address'),
            SizedBox(height: 24),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Color.fromARGB(255, 179, 160, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Exemplo de chamada ajustada
// Exemplo de chamada ajustada
  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String email = _emailController.text.trim();

        // Verifica se o campo de e-mail está vazio
        if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, insira um e-mail.')),
          );
          return;
        }

        // Verifica se o email existe
        if (UserManager().emailExists(email)) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SetPasswordPage(email: email)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email não encontrado!')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Continue',
        style: GoogleFonts.poppins(fontSize: 18),
      ),
    );
  }
}

class SetPasswordPage extends StatelessWidget {
  final String email; // Armazenar o email recebido
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  SetPasswordPage({required this.email}); // Inicializando o email no construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set Password',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            SizedBox(height: 16),
            _buildTextField(_confirmPasswordController, 'Confirm Password',
                obscureText: true),
            SizedBox(height: 24),
            _buildResetPasswordButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Color.fromARGB(255, 179, 160, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildResetPasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_passwordController.text == _confirmPasswordController.text) {
          // Atualiza a senha do usuário
          UserManager().updateUserPassword(email, _passwordController.text);
          // Redirecionar para a página de login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Mostra uma mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('As senhas não correspondem!')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Reset Password',
        style: GoogleFonts.poppins(fontSize: 18),
      ),
    );
  }
}
