import 'package:flutter/material.dart';
import 'package:mini_notes/consts.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../database.dart';
import '../models/note_model.dart';
import '../widgets/grid_tile.dart';

import 'note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> lastNotes = [];
  bool isEndDate = false;
  bool isLongTitle = false;
  bool isPreLastWide = false;

  int crossSize = 1;
  int mainSize = 1;
  int titleMaxLines = 4;

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 12, bottom: 10),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotePage(
                      isNew: true,
                    )),
          ),
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white, size: kButtonSize + 3),
        ),
      ),
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
                  Text(
                    'Notes',
                    style: TextStyle(
                      color: kAppTitleColor,
                      fontSize: 36,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kButtonColor,
                        borderRadius: BorderRadius.circular(kButtonRadius),
                      ),
                      padding: EdgeInsets.all(kButtonPadding),
                      child: Icon(
                        Icons.refresh,
                        color: kAppTitleColor,
                        size: kButtonSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kDefaultPadding * 1.4),
              Expanded(
                child: FutureBuilder(
                  future: handler.retrieveNotes(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Note>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: StaggeredGrid.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children:
                              List.generate(snapshot.data!.length, (index) {
                            if (index >= 2 && index % 3 == 0) {
                              isEndDate = false;
                              isLongTitle = true;
                              crossSize = 1;
                              mainSize = 2;
                              titleMaxLines = 10;
                            } else if (index >= 7 && index % 8 == 0) {
                              isEndDate = true;
                              isLongTitle = false;
                              crossSize = 2;
                              mainSize = 1;
                              titleMaxLines = 3;
                            } else {
                              isEndDate = false;
                              isLongTitle = false;
                              crossSize = 1;
                              mainSize = 1;
                              titleMaxLines = 4;
                            }
                            return StaggeredGridTile.count(
                              crossAxisCellCount: crossSize,
                              mainAxisCellCount: mainSize,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotePage(
                                            isNew: false,
                                            id: snapshot.data![index].id!,
                                            title: snapshot.data![index].title,
                                            message:
                                                snapshot.data![index].message,
                                            date: snapshot.data![index].date,
                                          )),
                                ),
                                child: Dismissible(
                                  direction: DismissDirection.horizontal,
                                  key: ValueKey<int>(snapshot.data![index].id!),
                                  onDismissed:
                                      (DismissDirection direction) async {
                                    await handler
                                        .deleteNote(snapshot.data![index].id!);
                                    setState(() {
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                  },
                                  background: Container(
                                    color: Colors.redAccent,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.delete_forever,
                                      size: 38,
                                    ),
                                  ),
                                  child: KGridTile(
                                      title: snapshot.data![index].title,
                                      date: snapshot.data![index].date,
                                      color: int.parse(
                                          snapshot.data![index].color),
                                      maxLines: titleMaxLines,
                                      isEndDate: isEndDate),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
