import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/appbar.dart';
import 'result_screen.dart';
// import 'dart:math' as math;
import '/homepagerepo.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  static const routeName = '/edit';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController controller;
  late FocusNode focusNode;
  late TextEditingController controller1;
  late FocusNode focusNode1;
  late TextEditingController controller2;
  late FocusNode focusNode2;
  final List<String> judul = [];
  final List<String> bahan = [];
  final List<String> detail = [];
  String response = '';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    controller1 = TextEditingController();
    focusNode1 = FocusNode();
    controller2 = TextEditingController();
    focusNode2 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    controller1.dispose();
    focusNode1.dispose();
    controller2.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String result = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBars(title: 'Resep Milik Mu (Edit)'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      autocorrect: true,
                      focusNode: focusNode,
                      controller: controller,
                      onFieldSubmitted: (value) {
                        controller.clear();
                        setState(() {
                          judul.add(value);
                          focusNode.requestFocus();
                        });
                        print(judul);
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.5),
                            bottomLeft: Radius.circular(5.5),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: "Judul (opsional)",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        hintText: "Salad Sehat, Sup Ayam, Kue Bolu, ...",
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xffc71565),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            judul.add(controller.text);
                            controller.clear();
                            focusNode.requestFocus();
                          });
                          print(judul);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      autocorrect: true,
                      focusNode: focusNode1,
                      controller: controller1,
                      onFieldSubmitted: (value) {
                        controller1.clear();
                        setState(() {
                          bahan.add(value);
                          focusNode.requestFocus();
                        });
                        print(bahan);
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.5),
                            bottomLeft: Radius.circular(5.5),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: "Bahan (opsional)",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        hintText: "telur, 2kg daging, 10L air, ...",
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xffc71565),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            bahan.add(controller1.text);
                            controller1.clear();
                            focusNode.requestFocus();
                          });
                          print(bahan);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      autocorrect: true,
                      focusNode: focusNode2,
                      controller: controller2,
                      onFieldSubmitted: (value) {
                        controller2.clear();
                        setState(() {
                          detail.add(value);
                          focusNode.requestFocus();
                        });
                        print(detail);
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.5),
                            bottomLeft: Radius.circular(5.5),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: "Detail (opsional)",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        hintText:
                            "rendah kalori, tinggi protein, 2 gram karbohidrat, ...",
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xffc71565),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            detail.add(controller2.text);
                            controller2.clear();
                            focusNode.requestFocus();
                          });
                          print(detail);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  children: [
                    for (int i = 0; i < judul.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.5)),
                          backgroundColor: Colors.red[400],
                          label: Text(judul[i]),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                          onDeleted: () {
                            setState(() {
                              judul.remove(judul[i]);
                            });
                          },
                        ),
                      ),
                    for (int i = 0; i < bahan.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.5)),
                          backgroundColor: Colors.amber[300],
                          label: Text(bahan[i]),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                          onDeleted: () {
                            setState(() {
                              bahan.remove(bahan[i]);
                            });
                          },
                        ),
                      ),
                    for (int i = 0; i < detail.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.5)),
                          backgroundColor: Colors.brown[200],
                          label: Text(detail[i]),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                          onDeleted: () {
                            setState(() {
                              detail.remove(detail[i]);
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        response,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text(
                    'Ubah Resep',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffc71565),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    fixedSize: const Size(500, 50),
                  ),
                  onPressed: () async {
                    setState(() => response = 'Thinking...');
                    var temp = await HomePageRepo().askAI2(judul.toString(),
                        bahan.toString(), detail.toString(), result.toString());
                    setState(() => response = '');
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamed(ResultScreen.routeName, arguments: temp);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
