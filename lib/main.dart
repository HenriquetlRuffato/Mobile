import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carrossel de Micro-Formulários',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const FormCarouselPage(),
    );
  }
}

class Registro {
  Registro({required this.id, this.nome = '', this.nascimento, this.sexo});
  final String id;
  String nome;
  DateTime? nascimento;
  String? sexo;
}

class FormCarouselPage extends StatefulWidget {
  const FormCarouselPage({super.key});
  @override
  State<FormCarouselPage> createState() => _FormCarouselPageState();
}

class _FormCarouselPageState extends State<FormCarouselPage> {
  final ScrollController _scroll = ScrollController();
  final List<Registro> _cards = List.generate(3, (i) => Registro(id: DateTime.now().microsecondsSinceEpoch.toString() + i.toString()));

  void _addCard() {
    setState(() {
      _cards.add(Registro(id: DateTime.now().microsecondsSinceEpoch.toString()));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 400), curve: Curves.easeOut));
  }

  void _removeCard(String id) {
    if (_cards.length <= 1) return;
    setState(() {
      _cards.removeWhere((e) => e.id == id);
    });
  }

  String _fmt(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  Future<void> _pickDate(int index) async {
    final now = DateTime.now();
    final initial = _cards[index].nascimento ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 1),
      helpText: 'Data de Nascimento',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (picked != null) {
      setState(() => _cards[index].nascimento = picked);
    }
  }

  void _salvarTudo() {
    for (final c in _cards) {
      debugPrint('Registro: nome=${c.nome}, nascimento=${_fmt(c.nascimento)}, sexo=${c.sexo ?? ''}');
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Valores exibidos no console')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrossel de Micro-Formulários'),
        actions: [
          IconButton(onPressed: () => _scroll.animateTo((_scroll.offset - 360).clamp(0, _scroll.position.maxScrollExtent), duration: const Duration(milliseconds: 250), curve: Curves.easeOut), icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: () => _scroll.animateTo((_scroll.offset + 360).clamp(0, _scroll.position.maxScrollExtent), duration: const Duration(milliseconds: 250), curve: Curves.easeOut), icon: const Icon(Icons.chevron_right)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: ElevatedButton.icon(onPressed: _addCard, icon: const Icon(Icons.add), label: const Text('Adicionar')),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scroll,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final c = _cards[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width.clamp(320, 420),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Registro ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
                                TextButton(onPressed: () => _removeCard(c.id), child: const Text('Remover')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Nome Completo', style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 6),
                            TextFormField(
                              initialValue: c.nome,
                              onChanged: (v) => setState(() => c.nome = v),
                              decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))), hintText: 'Digite o nome'),
                            ),
                            const SizedBox(height: 14),
                            Text('Data de Nascimento', style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _pickDate(index),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)))),
                                  controller: TextEditingController(text: _fmt(c.nascimento)),
                                  readOnly: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text('Sexo', style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: c.sexo,
                              items: const [
                                DropdownMenuItem(value: 'Homem', child: Text('Homem')),
                                DropdownMenuItem(value: 'Mulher', child: Text('Mulher')),
                              ],
                              onChanged: (v) => setState(() => c.sexo = v),
                              decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))), hintText: 'Selecione'),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _salvarTudo,
                                child: const Text('Salvar Tudo'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemCount: _cards.length,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text('Arraste horizontalmente ou use as setas. Sem pacotes externos para data.'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _salvarTudo, icon: const Icon(Icons.save), label: const Text('Salvar')),
    );
  }
}
