import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedBackForm extends StatelessWidget {
  const FeedBackForm({Key? key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 34, 82),
          title: const Text(
            "FEEDBACK",
            style: TextStyle(color: Colors.white, letterSpacing: 2.0),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  "Choose the category of your feedback",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    FeedbackWidget(text: "login"),
                    FeedbackWidget(text: "signup"),
                    FeedbackWidget(text: "poll"),
                    FeedbackWidget(text: "complient"),
                    FeedbackWidget(text: "suggestion"),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  child: TextField(
                    autofocus: false,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText:
                          "Please briefly describe the issue you have faced",
                      hintStyle:
                          TextStyle(fontSize: 13, color: Color(0xffc5c5c5)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffe5e5e5))),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Submit",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackWidget extends StatefulWidget {
  final String text;
  const FeedbackWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
        MaterialState.selected,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }

    return Row(
      children: [
        Checkbox(
          checkColor: Colors.grey,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: isChecked ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
