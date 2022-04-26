import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_tracker/constants/constants.dart';

class Book {
  final double? rating;
  final String? id;
  final String title;
  final String author;
  final String description;
  final String categories;
  final String? notes;
  final String? userId;
  final int pageCount;
  final String publishedDate;
  final String photoUrl;
  final Timestamp? startedReading;
  final Timestamp? finishedReading;

  Book(
      {this.rating,
      this.startedReading,
      this.finishedReading,
      required this.pageCount,
      required this.publishedDate,
      required this.photoUrl,
      this.id,
      this.userId,
      required this.title,
      required this.author,
      required this.description,
      required this.categories,
      this.notes});

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    return Book(
        // id: data.id,
        // userId: data.get('user_id'),
        // title: data.get('title'),
        // description: data.get('description'),
        // author: data.get('author'),
        // notes: data.get('notes'),
        // publishedDate: data.get('published_date'),
        // pageCount: data.get('page_count'),
        // photoUrl: data.get('photo_url'),
        // categories: data.get('categories'),
        // startedReading: data.get('started_reading_at'),
        // finishedReading: data.get('finished_reading_at')
        id: data.id,
        userId: data.get('user_id'),
        author: data.get('author'),
        title: data.get('title'),
        description: data.get('description'),
        categories: data.get('categories'),
        notes: data.get('notes'),
        pageCount: data.get('page_count'),
        startedReading: data.get('started_reading_at'),
        finishedReading: data.get('finished_reading_at'),
        publishedDate: data.get('published_date'),
        photoUrl: data.get('photo_url'),
        rating: parseDouble(data.get('rating')));
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user_id': userId,
      'author': author,
      'notes': notes,
      'photo_url': photoUrl,
      'published_date': publishedDate,
      'description': description,
      'page_count': pageCount,
      'categories': categories,
      'started_reading_at': startedReading,
      'finished_reading_at': finishedReading,
      'rating': rating
    };
  }
}
