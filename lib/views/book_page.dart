import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livrosfirebase/components/my_dropdownbutton.dart';
import 'package:livrosfirebase/components/my_textfield.dart';
import 'package:livrosfirebase/service/firestore_service.dart';
import 'package:livrosfirebase/validators/book_validator.dart';

class BookPage extends StatefulWidget {
  final Book? book;

  BookPage({this.book});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late Book _editedBook;
  late bool _userEdited;
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();
  String? _genreController;
  final List<String> _genreOptions = [
    "Drama",
    "Suspense",
    "Romance",
    "Fantasia",
    "Infantil",
    "Terror",
    "Didático",
    "Outro"
  ];

  final _publisherController = TextEditingController();

  final _titleFocus = FocusNode();
  final _authorFocus = FocusNode();
  final _yearFocus = FocusNode();
  final _publisherFocus = FocusNode();
  final now = DateTime.now().year;
  final BookValidator validator = BookValidator();
  final FirestoreService firestoreService = FirestoreService(); 

  String? _titleError;
  String? _errorYear;
  String? _authorError;
  String? _genreError;
  String? _publisherError;

  @override
   void initState() {
    super.initState();
    _userEdited = false;

    if (widget.book == null) {
      _editedBook = Book();
    } else {
      _editedBook = widget.book!;
      _titleController.text = _editedBook.title ?? "";
      _authorController.text = _editedBook.author ?? "";
      _yearController.text = _editedBook.year ?? "";
      _genreController = _editedBook.genre ?? "";
      _publisherController.text = _editedBook.publisher ?? "";
      _editedBook.cover = _editedBook.cover ?? "";
    }
  }

  void _validateFields() {
    setState(() {
      _titleError = validator.validateField(_titleController);
      _errorYear = validator.validateYear(_yearController, now);
      _authorError = validator.validateField(_authorController);
      _genreError = validator.validateSelect(_genreController);
      _publisherError = validator.validateField(_publisherController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: BackButton(color: Colors.white),
          title: Text(
            _editedBook.title ?? "Novo Livro",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _validateFields();
            if (_titleError == null && _errorYear == null && _authorError == null && _genreError == null && _publisherError == null) {
              Navigator.pop(context, _editedBook);
              print(_editedBook);
            } else {
              FocusScope.of(context).requestFocus(_titleFocus);
            }
          },
          child: const Icon(
            Icons.save,
            color: Colors.white,
          ),
          backgroundColor: Colors.purple.shade300,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Stack(
                children: [
                  Container(
                    width: 150.0,
                    height: 225.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                        image: (_editedBook.cover != null && _editedBook.cover!.isNotEmpty)
                            ? FileImage(File(_editedBook.cover!))
                            : AssetImage("assets/imgs/placeholder.png")
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8.0,
                    right: 5.0,
                    child: FloatingActionButton(
                      onPressed: showPhotoOptions,
                      shape: CircleBorder(),
                      mini: true,
                      backgroundColor: Colors.purple.shade400,
                      child: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              MyTextField(
                controller: _titleController,
                error: _titleError != null,
                focusNode: _titleFocus,
                keyboardType: TextInputType.name,
                hintText: "Título",
                obscureText: false,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedBook.title = text;
                  });
                  _titleError = validator.validateField(_titleController);
                },
              ),
              if (_titleError != null)
                showAlert(_titleError),
              SizedBox(height: 8.0),
              MyTextField(
                controller: _authorController,
                error: _authorError != null,
                focusNode: _authorFocus,
                keyboardType: TextInputType.name,
                hintText: "Autor",
                obscureText: false,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedBook.author = text;
                  });
                 _authorError = validator.validateField(_authorController);
                },
              ),
              if (_authorError != null)
                showAlert(_authorError),
              SizedBox(height: 8.0),
              MyTextField(
                controller: _yearController,
                hintText: "Ano de Publicação",
                focusNode: _yearFocus,
                error: _errorYear != null,
                obscureText: false,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedBook.year = text;
                  });
                  _errorYear = validator.validateYear(_yearController, now);
                },
              ),
              if (_errorYear != null)
                showAlert(_errorYear),
              SizedBox(height: 8.0),
              MyDropdownButton(
                controller: _genreOptions,
                error: _genreError != null,
                selectedValue: _genreController,
                hintText: "Gênero",
                onChanged: (option) {
                  _userEdited = true;
                  setState(() {
                    _genreController = option;
                    _editedBook.genre = option;
                  });
                  _genreError = validator.validateSelect(_genreController);
                },
              ),
              if (_genreError != null)
                showAlert(_genreError),
              SizedBox(height: 8.0),
              MyTextField(
                controller: _publisherController,
                focusNode: _publisherFocus,
                error: _publisherError != null,
                hintText: "Editora",
                obscureText: false,
                keyboardType: TextInputType.name,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedBook.publisher = text;
                  });
                 _publisherError = validator.validateField(_publisherController);
                },
              ),
              if (_publisherError != null)
                showAlert(_publisherError),
            ],
          ),
        ),
      ),
    );
  }

  Widget showAlert(String? erro) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Text(
        erro!,
        textAlign: TextAlign.start,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  void showPhotoOptions() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            (_editedBook.cover != null && _editedBook.cover!.isNotEmpty)
                                ? "Alterar Imagem"
                                : "Adicionar Imagem",
                            style: TextStyle(
                                color: Colors.purple[900], fontSize: 20.0),
                          ),
                          onPressed: () {
                            final picker = ImagePicker();
                            picker
                                .pickImage(source: ImageSource.gallery)
                                .then((file) {
                              if (file != null) {
                                setState(() {
                                  _editedBook.cover = file.path;
                                  _userEdited = true;
                                });
                              }
                            });
                            Navigator.pop(context);
                          },
                        ),
                        if (_editedBook.cover != null && _editedBook.cover!.isNotEmpty)
                          TextButton(
                            child: Text(
                              "Remover Imagem",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0),
                            ),
                            onPressed: () {
                              setState(() {
                                _editedBook.cover = null;
                                _userEdited = true;
                              });
                              Navigator.pop(context);
                            },
                          ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Future<bool> _requestPop() {
    if (_userEdited) {

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar Alterações"),
              content: const Text("Ao sair as alterações serão perdidas!"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar",
                        style: TextStyle(color: Colors.black))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sim",
                      style: TextStyle(color: Color(0xFF6A1B9A)),
                    )),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}