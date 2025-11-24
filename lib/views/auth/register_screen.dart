import 'package:flutter/material.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usuarioCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _password2Ctrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePassword2 = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _emailCtrl.dispose();
    _usuarioCtrl.dispose();
    _telefonoCtrl.dispose();
    _passwordCtrl.dispose();
    _password2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final data = <String, dynamic>{
      'nombre': _nombreCtrl.text.trim(),
      'apellido': _apellidoCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'nombreusuario': _usuarioCtrl.text.trim(),
      'telefono': _telefonoCtrl.text.trim(),
      'password': _passwordCtrl.text.trim(),
      'password_confirmation': _password2Ctrl.text.trim(),
    };

    final success = await authController.register(data);

    if (!mounted) return;

    setState(() {
      _loading = false;
      _errorMessage = authController.errorMessage;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/dashboard-principal');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8F8),
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryGreen),
        title: const Text(
          'Crear cuenta',
          style: TextStyle(color: primaryGreen),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Regístrate en AgroNexus",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade800,
                      fontSize: 13,
                    ),
                  ),
                ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _input("Nombre", _nombreCtrl, Icons.person_outline),
                    const SizedBox(height: 12),
                    _input("Apellido", _apellidoCtrl, Icons.person_outline),
                    const SizedBox(height: 12),
                    _input(
                      "Correo electrónico",
                      _emailCtrl,
                      Icons.email_outlined,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Ingresa tu correo';
                        }
                        if (!v.contains('@')) return 'Correo no válido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _input(
                        "Nombre de usuario", _usuarioCtrl, Icons.badge_outlined),
                    const SizedBox(height: 12),
                    _input("Teléfono (opcional)", _telefonoCtrl,
                        Icons.phone_outlined,
                        validator: (v) => null),
                    const SizedBox(height: 12),
                    _passwordField(
                      "Contraseña",
                      _passwordCtrl,
                      _obscurePassword,
                      () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _passwordField(
                      "Confirmar contraseña",
                      _password2Ctrl,
                      _obscurePassword2,
                      () {
                        setState(() {
                          _obscurePassword2 = !_obscurePassword2;
                        });
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Repite la contraseña';
                        }
                        if (v != _passwordCtrl.text.trim()) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _onRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Crear cuenta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes cuenta?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Inicia sesión",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl, IconData icon,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator ??
          (v) {
            if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
            return null;
          },
    );
  }

  Widget _passwordField(String label, TextEditingController ctrl,
      bool obscure, VoidCallback toggle,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator ??
          (v) {
            if (v == null || v.isEmpty) return 'Contraseña requerida';
            if (v.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
    );
  }
}