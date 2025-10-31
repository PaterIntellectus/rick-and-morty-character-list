import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

abstract class Streamer<T> {
  Streamer({T? initial})
    : _subject = initial == null
          ? BehaviorSubject<T>()
          : BehaviorSubject<T>.seeded(initial);

  @protected
  void add(T data) => _subject.add(data);

  @mustCallSuper
  void close() => _subject.close();

  final BehaviorSubject<T> _subject;

  Stream<T> get stream => _subject.stream;
  T? get current => _subject.valueOrNull;
}
