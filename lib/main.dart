import 'package:flutter/material.dart';

void main() {
  runApp(const YoyoIptvApp());
}

class YoyoIptvApp extends StatelessWidget {
  const YoyoIptvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOYO IPTV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101116),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1B1D25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _server = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _server.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _connect() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HomeScreen(username: _username.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.live_tv_rounded, size: 76, color: Color(0xFFB69CFF)),
                    const SizedBox(height: 18),
                    const Text(
                      'YOYO IPTV',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your entertainment, in one place',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: .65)),
                    ),
                    const SizedBox(height: 36),
                    _field(_server, 'Server URL', Icons.dns_outlined,
                        hint: 'http://example.com:8080'),
                    const SizedBox(height: 14),
                    _field(_username, 'Username', Icons.person_outline),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: _hidePassword,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter password' : null,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _connect,
                      icon: const Icon(Icons.login),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('CONNECT', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Xtream Codes login • Live TV • Movies • Series',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .5)),
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

  Widget _field(TextEditingController controller, String label, IconData icon, {String? hint}) {
    return TextFormField(
      controller: controller,
      keyboardType: label == 'Server URL' ? TextInputType.url : TextInputType.text,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter $label' : null,
      decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon)),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final sections = [
      (Icons.live_tv, 'Live TV'),
      (Icons.movie_outlined, 'Movies'),
      (Icons.video_library_outlined, 'TV Series'),
      (Icons.favorite_border, 'Favorites'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('YOYO IPTV')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, $username', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Your account details are ready. Connect the Xtream API to load content.'),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                children: sections.map((item) => Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.$2} will be available after API integration.')),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.$1, size: 42, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 12),
                        Text(item.$2, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
