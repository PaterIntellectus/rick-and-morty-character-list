import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

abstract class Streamer<T> {
  Streamer({T? initial})
    : _subject = initial == null
          ? BehaviorSubject<T>()
          : BehaviorSubject<T>.seeded(initial);

  final BehaviorSubject<T> _subject;

  void add(T data) => _subject.add(data);

  T? get current => _subject.valueOrNull;

  Stream<T> get stream => _subject.stream;

  @mustCallSuper
  void close() => _subject.close();
}
