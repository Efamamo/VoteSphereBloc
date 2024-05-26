import 'package:flutter/cupertino.dart';
import '../screens/questions_model.dart';

class PollProvider with ChangeNotifier {
  List<Question> _questions = [];
  List<Object?> _index = [];
  List<List> _votes = [];
  List<bool> _disabled = [];

  List<Question> get questions => _questions;
  List<List> get votes => _votes;
  List<Object?> get index => _index;
  List<bool> get disabled => _disabled;

  void addquestions(question) {
    _questions.add(question);
    notifyListeners();
  }

  void addIndex(index) {
    _index.add(index);
    notifyListeners();
  }

  void addVote(vote) {
    _votes.add(vote);
    notifyListeners();
  }

  void addDisable(disable) {
    _disabled.add(disable);
    notifyListeners();
  }

  void removeQuestion(question) {
    _questions.remove(question);
    notifyListeners();
  }

  void removeVote(vote) {
    _votes.remove(vote);
    notifyListeners();
  }

  void removeIndex(index) {
    _index.remove(index);
    notifyListeners();
  }

  void removeDisabled(disable) {
    _disabled.remove(disable);
    notifyListeners();
  }

  void removeComment(comment, question) {
    _questions[_questions.indexOf(question)].comment.remove(comment);
    notifyListeners();
  }

  void addComment(comment, question) {
    _questions[_questions.indexOf(question)].comment.add(comment);
    notifyListeners();
  }

  void increamentVote(choice, question, value) {
    _votes[_questions.indexOf(question)][question.answers.indexOf(choice)] += 1;
    _index[_questions.indexOf(question)] = value;
    notifyListeners();
  }

  int sum(arr) {
    int res = arr.fold(0, (previousValue, element) => previousValue + element);
    if (res == 0.0) {
      return 1;
    }
    return res;
  }
}
