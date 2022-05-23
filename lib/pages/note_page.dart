import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_notes/models/note_model.dart';
import "dart:math";

import '../consts.dart';
import '../database.dart';
import 'home_page.dart';

class NotePage extends StatefulWidget {
  const NotePage(
      {Key? key,
      required this.isNew,
      this.id = 0,
      this.title = '',
      this.message = '',
      this.date = ''})
      : super(key: key);

  final bool isNew;
  final int id;
  final String title;
  final String message;
  final String date;

  @override
  NotePageState createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  String todayDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  late DatabaseHandler handler;

  bool isLoading = false;

  List<String> listColors = [
    '4294945681',
    '4294954112',
    '4293324190',
    '4286635754',
    '4291794138',
    '4286565315',
    '4294217649'
  ];

  @override
  void initState() {
    handler = DatabaseHandler();
    handler.initializeDB();

    setState(() {
      titleController.text = widget.title;
      messageController.text = widget.message;
      widget.date.length < 2 ? null : todayDate = widget.date;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: kDefaultPadding * 1.4,
            left: kDefaultPadding,
            right: kDefaultPadding,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kButtonColor,
                        borderRadius: BorderRadius.circular(kButtonRadius),
                      ),
                      padding: EdgeInsets.all(kButtonPadding),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: kAppTitleColor,
                        size: kButtonSize,
                      ),
                    ),
                  ),
                  !isLoading
                      ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            Note note = Note(
                                id: widget.isNew ? null : widget.id,
                                title: titleController.text,
                                message: messageController.text,
                                date: todayDate,
                                color: listColors[
                                    Random().nextInt(listColors.length)]);
                            widget.isNew
                                ? await handler.insertNote(note)
                                : await handler.updateNotes(note);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kButtonColor,
                              borderRadius:
                                  BorderRadius.circular(kButtonRadius),
                            ),
                            padding: EdgeInsets.all(kButtonPadding),
                            child: Icon(
                              Icons.done_outlined,
                              color: Colors.greenAccent,
                              size: kButtonSize,
                            ),
                          ),
                        )
                      : const CircularProgressIndicator()
                ],
              ),
              SizedBox(height: kDefaultPadding * 1.4),
              TextField(
                controller: titleController,
                minLines: 1,
                maxLines: 3,
                maxLength: 70,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.title,
                  hintStyle: const TextStyle(color: Colors.grey),
                  counterStyle: TextStyle(color: kAppTitleColor),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  todayDate,
                  style: const TextStyle(fontSize: 16, color: Colors.white38),
                ),
              ),
              SizedBox(height: kDefaultPadding * 1.4),
              Expanded(
                child: TextField(
                  controller: messageController,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    counterStyle: TextStyle(color: kAppTitleColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
