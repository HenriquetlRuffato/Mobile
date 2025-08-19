import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return Auth(
      notifier: AuthController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rotas Privadas',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        initialRoute: '/public',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              final auth = Auth.of(context);
              if (settings.name == '/public') return const PublicPage();
              if (settings.name == '/restrita') {
                if (auth.authed) return const RestritaPage();
                return LoginGate(title: 'Área restrita', routeName: '/restrita', arguments: settings.arguments);
              }
              if (settings.name == '/dados') {
                if (auth.authed) return const DadosPage();
                return LoginGate(title: 'Dados do usuário', routeName: '/dados', arguments: settings.arguments);
              }
              return const Scaffold(body: Center(child: Text('404')));
            },
          );
        },
      ),
    );
  }
}

class AuthController extends ChangeNotifier {
  bool authed = false;
  void signIn() {
    authed = true;
    notifyListeners();
  }
  void signOut() {
    authed = false;
    notifyListeners();
  }
}

class Auth extends InheritedNotifier<AuthController> {
  const Auth({super.key, required AuthController notifier, required Widget child}) : super(notifier: notifier, child: child);
  static AuthController of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Auth>()!.notifier!;
}

class PublicPage extends StatelessWidget {
  const PublicPage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Auth.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pública'),
        actions: [
          TextButton(
            onPressed: () => auth.authed ? auth.signOut() : auth.signIn(),
            child: Text(auth.authed ? 'Sair' : 'Entrar'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Status: ${auth.authed ? 'Autenticado' : 'Não autenticado'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/restrita'),
              child: const Text('Ir para /restrita'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/dados',
                  arguments: {
                    'nomeCompleto': 'João da Silva',
                    'dataNascimento': '1999-08-12',
                    'telefone': '(64) 9 9999-9999',
                  },
                );
              },
              child: const Text('Ir para /dados (com Map)'),
            ),
          ],
        ),
      ),
    );
  }
}

class RestritaPage extends StatelessWidget {
  const RestritaPage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Auth.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restrita'),
        actions: [
          TextButton(onPressed: () => auth.signOut(), child: const Text('Sair')),
        ],
      ),
      body: const Center(child: Text('Conteúdo restrito.')),
    );
  }
}

class DadosPage extends StatelessWidget {
  const DadosPage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Auth.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final entries = args?.entries.map((e) => MapEntry(e.key.toString(), e.value?.toString() ?? '')).toList() ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados'),
        actions: [
          TextButton(onPressed: () => auth.signOut(), child: const Text('Sair')),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) {
          final k = entries[i].key;
          final v = entries[i].value;
          return ListTile(title: Text(k), subtitle: Text(v));
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: entries.length,
      ),
    );
  }
}

class LoginGate extends StatelessWidget {
  const LoginGate({super.key, required this.title, required this.routeName, this.arguments});
  final String title;
  final String routeName;
  final Object? arguments;
  @override
  Widget build(BuildContext context) {
    final auth = Auth.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Autenticação necessária'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                auth.signIn();
                Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
              },
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            )
          ],
        ),
      ),
    );
  }
}
