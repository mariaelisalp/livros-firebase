import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livrosfirebase/components/my_alert.dart';
import 'package:livrosfirebase/service/firestore_service.dart';
import 'package:livrosfirebase/views/book_page.dart';
import 'package:livrosfirebase/views/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestoreService = FirestoreService();
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _getAllBooks();
  }

  void _getAllBooks() {
    firestoreService.getAllBooks().listen((bookList) {
      setState(() {
        books = bookList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: Padding(
          padding: const EdgeInsets.only(left: 90.0), 
          child: Image.asset(
            "assets/imgs/logoo.png",
            height: 120,
            width: 190, 
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return MyAlert(
                        title: "Sair",
                        content: "Tem certeza que deseja sair?",
                        titleColor: Colors.purple,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Erro ao sair: $error")),
                                );
                              });
                            },
                            child: const Text(
                              "Sim",
                              style: TextStyle(color: Color(0xFF4A148C)),
                            ),
                          ),
                        ]
                      );
                  }
                );
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          showBookPage();
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple.shade300,
        focusColor: Colors.white,
      ),
      body: books.isEmpty 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Seus livros aparecerão aqui.",
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
                SizedBox(height: 5.0),
                Icon(Icons.book, color: Colors.grey, size: 50.0,),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return bookCard(context, index);
            },
          ),
    );
  }

  Widget bookCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        color: Colors.purple.shade50,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 90.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: books[index].cover != null &&
                            books[index].cover!.isNotEmpty
                        ? FileImage(File(books[index].cover!))
                        : AssetImage("assets/imgs/placeholder.png")
                            as ImageProvider,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      books[index].title ?? " ",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Autor: ${books[index].author ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Ano de publicação: ${books[index].year ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Gênero: ${books[index].genre ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Editora: ${books[index].publisher ?? ""}",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showOptions(context, index);
      },
    );
  }

  void showBookPage({Book? book}) async {
    final user = FirebaseAuth.instance.currentUser?.uid;
    print("verificando se tem id ao passar: $book");

    final recBook = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookPage(book: book)),
    );

    if (recBook != null) {
      recBook.userId = user;
      if (book != null) {
        await firestoreService.update(book.id!, recBook);
        print("Editado");
      } else {
        await firestoreService.create(book: recBook);
        print("SALVO");
      }

      _getAllBooks();
    }
  }

  void showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        "Editar",
                        style:
                            TextStyle(color: Color(0xFF6A1B9A), fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showBookPage(book: books[index]);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "Excluir",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        confirmDelete(context, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlert(
          title: "Excluir livro",
          content: "Tem certeza que deseja excluir esse livro?",
          titleColor: Colors.purple,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                firestoreService.delete(books[index].id!).then((_) {
                  setState(() {
                    books.removeAt(index);
                  });
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Sim",
                style: TextStyle(color: Color(0xFF4A148C)),
              ),
            ),
          ],
        );
      },
    );
  }
}
