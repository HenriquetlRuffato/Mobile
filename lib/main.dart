import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNav com Tabs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Page1(),
    const Page2WithTabs(),
    const Page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Módulo 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Módulo 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Módulo 3',
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Conteúdo do Módulo 1'),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Conteúdo do Módulo 3'),
    );
  }
}

class Page2WithTabs extends StatefulWidget {
  const Page2WithTabs({super.key});

  @override
  State<Page2WithTabs> createState() => _Page2WithTabsState();
}

class _Page2WithTabsState extends State<Page2WithTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulo 2 com Abas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.cloud), text: 'Aba 1'),
            Tab(icon: Icon(Icons.beach_access), text: 'Aba 2'),
            Tab(icon: Icon(Icons.brightness_5), text: 'Aba 3'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TabContent(title: 'Conteúdo da Aba 1'),
          TabContent(title: 'Conteúdo da Aba 2'),
          TabContent(title: 'Conteúdo da Aba 3'),
        ],
      ),
    );
  }
}

class TabContent extends StatelessWidget {
  final String title;

  const TabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(tabTitle: title),
                ),
              );
            },
            child: const Text('Ver Detalhes'),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String tabTitle;

  const DetailPage({super.key, required this.tabTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes de $tabTitle'),
      ),
      body: Center(
        child: Text(
          'Detalhes do conteúdo de $tabTitle',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}