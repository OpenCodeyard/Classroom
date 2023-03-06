import 'package:classroom/blocs/classroom_bloc.dart';
import 'package:classroom/blocs/user_bloc.dart';
import 'package:classroom/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({Key? key}) : super(key: key);

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  Color selectedColor = Colors.green;
  final TextEditingController _classroomnamecontroller =
      TextEditingController();
  final TextEditingController _classroomdescriptioncontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    ClassroomBloc cb = Provider.of<ClassroomBloc>(context);
    UserBloc ub = Provider.of<UserBloc>(context);

    void openColorPicker() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick a color'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Widget customIconButton(Color iconColor) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedColor = iconColor;
            });
          },
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedColor == iconColor
                    ? Colors.black
                    : Colors.transparent,
                width: 3.0,
              ),
            ),
            child: Center(
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        title: const Text(
          "Create Classroom",
          style: TextStyle(
            fontFamily: "PublicSans",
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.deepPurpleAccent,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              customText("Classroom Name"),
              const SizedBox(height: 9.0),
              customTextInputField(_classroomnamecontroller, "Classroom Name"),
              const SizedBox(height: 16.0),
              customText("Classroom Description"),
              const SizedBox(height: 9.0),
              customTextInputField(
                  _classroomdescriptioncontroller, "Classroom Description"),
              const SizedBox(height: 16.0),
              customText("Classroom Color"),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  customIconButton(Colors.yellow[900]!),
                  customIconButton(Colors.green),
                  customIconButton(Colors.red),
                  customIconButton(Colors.deepPurpleAccent),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      openColorPicker();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    cb.createClass(
                        context,
                        _classroomnamecontroller.text,
                        ub.uid,
                        selectedColor.value.toString(),
                        _classroomdescriptioncontroller.text);
                    Navigator.pop(context);
                  },
                  child: const Text("CREATE"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
