// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/descricao_screen.dart';
import 'doador/home_doador_screen.dart';
import 'receptor/home_receptor_screen.dart';
import '../fake_users.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  String? erroLogin;
  int tipoUsuarioSelecionado = 0; // 0 = Doador, 1 = ONG

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void _fazerLogin() {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() => erroLogin = "Preencha todos os campos.");
      return;
    }

    try {
      final usuarioLogado = usuariosCadastrados.firstWhere(
        (user) => user.email == email && user.senha == senha,
      );

      String tipoSelecionado = tipoUsuarioSelecionado == 0 ? 'doador' : 'receptor';

      if (usuarioLogado.tipo != tipoSelecionado) {
        setState(() => erroLogin = "Usuário não cadastrado como ${tipoUsuarioSelecionado == 0 ? 'Doador' : 'ONG'}.");
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => tipoUsuarioSelecionado == 0 
            ? const HomeDoadorScreen() 
            : const HomeReceptorScreen(),
        ),
      );
    } catch (e) {
      setState(() => erroLogin = "E-mail ou senha incorretos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFF0a8449);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Mesmo fundo da tela Sobre Nós
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO COM HERO ANIMATION ---
              Hero(
                tag: 'logo_app',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/integrador.jpg',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Connect Ong',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: baseColor,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 40),

              // --- CARD PRINCIPAL (ESTILO SOBRE NÓS) ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Seletor de Tipo
                    _buildToggleSelector(baseColor),
                    const SizedBox(height: 24),

                    // Campos de Texto
                    _buildTextField(
                      controller: emailController,
                      label: 'E-mail',
                      icon: Icons.alternate_email,
                      baseColor: baseColor,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: senhaController,
                      label: 'Senha',
                      icon: Icons.lock_outline,
                      baseColor: baseColor,
                      isPassword: true,
                    ),

                    // Erro Amigável
                    if (erroLogin != null) _buildErrorBadge(),

                    const SizedBox(height: 24),

                    // Botão Entrar
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: baseColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: _fazerLogin,
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- LINKS INFERIORES ---
              TextButton(
                onPressed: () {},
                child: Text(
                  "Não tem conta? Cadastre-se",
                  style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DescricaoScreen()),
                  );
                },
                icon: const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                label: const Text(
                  "Sobre o Projeto",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES PARA LIMPEZA DO CÓDIGO ---

  Widget _buildToggleSelector(Color baseColor) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildToggleButton(0, "Doador", baseColor),
          _buildToggleButton(1, "ONG", baseColor),
        ],
      ),
    );
  }

  Widget _buildToggleButton(int index, String label, Color baseColor) {
    bool isSelected = tipoUsuarioSelecionado == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tipoUsuarioSelecionado = index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? baseColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color baseColor,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: baseColor, size: 22),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: baseColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildErrorBadge() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              erroLogin!,
              style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}