import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart';

Future<void> main() async {
  try {
    await doMain();
  } catch (e) {
    print(e);
  }
}

Future<void> doMain() async {
  SelectElement dropDown = querySelector('#exercises') as SelectElement;
  List<Exercise> exercisesList = await exercises();
  for (var exercise in exercisesList) {
    print(''
        'Adding $exercise');
    dropDown.children
        .add(OptionElement(data: exercise.title, value: exercise.title));

   // dropDown.onChange = () => {};
  }
}

Future<List<Exercise>> exercises() async {
  return await fetchExercises();
}

Future<List<Exercise>> fetchExercises() async {
  print('--start fetching---');
  final response = await Client().get(Uri.parse('exercise1.json'));
  print('--fetched---');
  var b = jsonDecode(response.body);
  var parsed = b as Map<String, dynamic>;
  print(parsed);
  List<Exercise> result = <Exercise>[];
  for (var item in parsed['exercises']) {
    result.add(Exercise.fromJson(item));
  }
  return result;
}

class Exercise {
  String title = "none";
  bool skip = false;
  List<Question> questions = [];

  Exercise(this.title, this.skip, this.questions);

  Exercise.fromJson(Map input) {
    title = input["title"];
    skip = input["skip"] == "true";
    var qs = input["questions"] as List;

    for (var element in qs) {
      var question = Question(element["q"], element["a"]);
      questions.add(question);
    }
  }
}

class Question {
  final String q;
  final String a;

  Question(this.q, this.a);
}
