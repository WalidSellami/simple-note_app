import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note/shared/components/Components.dart';
import 'package:note/shared/cubit/Cubit.dart';
import 'package:note/shared/cubit/States.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var contentController = TextEditingController();

  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NoteCubit()..createDataBase(),
      child: BlocConsumer<NoteCubit, NoteStates>(
        listener: (context, state) {
          if (state is InsertIntoDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = NoteCubit.get(context);
          var listNote = NoteCubit.get(context).notes;
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 26.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 0,
            ),
            body: ConditionalBuilder(
              condition: listNote.isNotEmpty,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildItemNote(listNote[index], context),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12.0,
                  ),
                  itemCount: listNote.length,
                ),
              ),
              fallback: (context) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Notes Yet',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDataBase(
                        title: titleController.text,
                        content: contentController.text,
                        date: dateController.text);
                    titleController.text = '';
                    contentController.text = '';
                    dateController.text = '';
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) {
                          return Container(
                            color: HexColor('1e2020'),
                            padding: const EdgeInsets.only(
                              top: 40.0,
                              left: 20.0,
                              right: 20.0,
                            ),
                            height: MediaQuery.of(context).size.height / 2,
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    text: 'Note Title',
                                    validate: (String? value) {
                                      if ((value ?? '').isEmpty) {
                                        return 'Title must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    maxLines: 1,
                                    minLines: 1,
                                    maxLength: 15,
                                  ),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  defaultTextField(
                                    controller: contentController,
                                    type: TextInputType.text,
                                    text: 'Note Content',
                                    validate: (String? value) {
                                      if ((value ?? '').isEmpty) {
                                        return 'Content must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    minLines: 1,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(
                                    height: 42.0,
                                  ),
                                  defaultTextField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    text: 'Note Date',
                                    validate: (String? value) {
                                      if ((value ?? '').isEmpty) {
                                        return 'Date must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onPress: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse(
                                          '2035-01-01',
                                        ),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        elevation: 25.0,
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheet(
                            icon: Icons.edit_note_outlined, isSheet: false);
                      });
                }
                cubit.changeBottomSheet(icon: Icons.add, isSheet: true);
              },
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
