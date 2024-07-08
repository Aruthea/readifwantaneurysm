import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeapp/providers/recipe.dart';
import 'package:recipeapp/providers/recipes.dart';
import 'package:recipeapp/widgets/appbar.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  static const routeName = '/import';

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController(text: 'imageUrl');
  final _form = GlobalKey<FormState>();
  File? _selectedImage;
  File? reImage;
  String? shownText;
  var _isInit = true;
  var _isLoading = false;
  var _hasImported = false;
  var _initValues = {
    'title': '',
    'description': '',
    'image': '',
  };
  var _editedRecipe = Recipe(
    id: null,
    title: '',
    description: '',
    image: '',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final recipeId = ModalRoute.of(context)!.settings.arguments as String?;
      if (recipeId != null) {
        _editedRecipe =
            Provider.of<Recipes>(context, listen: false).findById(recipeId);
        _initValues = {
          'title': _editedRecipe.title,
          'description': _editedRecipe.description,
          'image': _editedRecipe.image,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedRecipe.id != null) {
      if (context.mounted) {
        await Provider.of<Recipes>(context, listen: false)
            .updateRecipe(_editedRecipe.id.toString(), _editedRecipe);
      }
    } else {
      try {
        if (context.mounted) {
          await Provider.of<Recipes>(context, listen: false)
              .addRecipe(_editedRecipe);
        }
      } catch (error) {
        if (context.mounted) {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('An error occurred!'),
              content: const Text('Something went wrong.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                )
              ],
            ),
          );
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
    if (context.mounted) Navigator.of(context).pop();
  }

  Future _pickImage(ImageSource source) async {
    XFile? image = await ImagePicker()
        .pickImage(source: source, maxHeight: 600, maxWidth: 600);
    setState(() {
      _selectedImage = File(image!.path);
    });
    if (image == null) return;
    log(image.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('images').child(image.path);
    try {
      _isLoading = true;
      await ref.putFile(File(image.path));
      log('success');
      var url = await ref.getDownloadURL();
      setState(() {
        _editedRecipe = Recipe(
          id: _editedRecipe.id,
          title: _editedRecipe.title,
          description: _editedRecipe.description,
          image: url,
        );
        _isLoading = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future _importImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        reImage = File(image.path);
      });
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final InputImage inputImage = InputImage.fromFile(reImage!);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      textRecognizer.close();
      log(text);
      setState(() {
        shownText = text;
        _hasImported = true;
      });
      // return text;
    } else {
      return;
    }
    log(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBars(title: 'Impor Resep'),
      body: _hasImported
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(children: [
                  const Text(
                    "Judul",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: const InputDecoration(
                      hintText: 'misal: Kue Bolu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a title';
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      _editedRecipe = Recipe(
                        id: _editedRecipe.id,
                        title: value!,
                        description: _editedRecipe.description,
                        image: _editedRecipe.image,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _descriptionFocusNode,
                    initialValue: shownText ?? _initValues['description'],
                    decoration: const InputDecoration(
                      hintText: 'Deskripsi, Bahan, Langkah, dll',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a description';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _editedRecipe = Recipe(
                        id: _editedRecipe.id,
                        title: _editedRecipe.title,
                        description: value!,
                        image: _editedRecipe.image,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pilih Gambar (opsional)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc71565),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _pickImage(ImageSource.gallery);
                        },
                        child: const Text("Gallery"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc71565),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          _pickImage(ImageSource.camera);
                        },
                        child: const Text("Camera"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _selectedImage != null
                      ? _isLoading == true
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: LoadingAnimationWidget.hexagonDots(
                                    color: Colors.black, size: 30),
                              ),
                            )
                          : Stack(children: [
                              ClipRRect(
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    radius: 20,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              )
                            ])
                      : _editedRecipe.image != null
                          ? _isLoading == true
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: LoadingAnimationWidget.hexagonDots(
                                        color: Colors.black, size: 30),
                                  ),
                                )
                              : ClipRRect(
                                  child: _editedRecipe.image != ''
                                      ? Image.network(
                                          _editedRecipe.image,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset('assets/images/logo.png'),
                                )
                          : Image.asset("assets/images/logo.png"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveForm,
                    child: const Text('Simpan'),
                  ),
                ]),
              ),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _importImage(ImageSource.gallery);
                    },
                    child: const Text("Gallery"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc71565),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      _importImage(ImageSource.camera);
                    },
                    child: const Text("Camera"),
                  ),
                ],
              ),
            ),
    );
  }
}
