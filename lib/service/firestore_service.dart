import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference books = FirebaseFirestore.instance.collection('books');

  Future<void> create({
    required Book book}) {
    return books.add({
      'title': book.title,
      'year': book.year,
      'author': book.author,
      'genre': book.genre,
      'publisher': book.publisher,
      'cover': book.cover,
      'userId' : book.userId,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<List<Book>> getAllBooks() {
    return books.where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid ).orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> update(String docID, Book book){

    final Map<String, dynamic> data = {
      'title': book.title,
      'year': book.year,
      'author': book.author,
      'genre': book.genre,
      'publisher': book.publisher,
      'cover': book.cover,
      'timestamp': Timestamp.now(),
    };

    return books.doc(docID).update(data);
  }

  Future<void> delete(String docID) {
    return books.doc(docID).delete();
  }
}

class Book{
  String? id;
  String? title;
  String? year;
  String? author;
  String? genre;
  String? publisher;
  String? cover;
  String? userId;

  Book({
    this.id,
    this.title,
    this.year,
    this.author,
    this.genre,
    this.publisher,
    this.cover,
    this.userId
  });

  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      title: data['title'],
      year: data['year'],
      author: data['author'],
      genre: data['genre'],
      publisher: data['publisher'],
      cover: data['cover'],
      userId: data['userId']
    );
  }
}
