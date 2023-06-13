
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/shared/cubit/States.dart';
import 'package:sqflite/sqflite.dart';

class NoteCubit extends Cubit<NoteStates> {

  NoteCubit() : super(NoteInitialState());

  static NoteCubit get(context) => BlocProvider.of(context);

  IconData fabIcon = Icons.edit_note_outlined;
  bool isShow = false;

  void changeBottomSheet({
    required IconData icon,
    required bool isSheet,
  }){
    fabIcon = icon;
    isShow = isSheet;
    emit(NoteChangeBottomSheetState());
  }

  // List<String> colors = [
  //   '24274b',
  //   '3a485b',
  //   '2a3441',
  //   '003b3b',
  //   '353e4b',
  // ];

  Database? dataBase;
  List<Map> notes = [];

  void createDataBase(){
    openDatabase(
      'note.db',
      version: 1,
      onCreate: (dataBase , version){
        try{
          dataBase.execute('CREATE TABLE Note(id integer primary key , title text , content text , date text)');
        }catch(error){
          if (kDebugMode) {
            print(error.toString());
          }
        }
      },
      onOpen: (dataBase){
        getFromDataBase(dataBase);
        if (kDebugMode) {
          print('DataBase opened');
        }
      }
    ).then((value) {
      dataBase = value;
      emit(CreateDataBaseState());
    });
  }
  
  Future<void> insertIntoDataBase({
    required String title,
    required String content,
    required String date,
}) async{
    await dataBase?.transaction((txn) async{
      try{
        txn.rawInsert('INSERT INTO Note(title , content , date) VALUES ("$title" , "$content" , "$date")');
         emit(InsertIntoDataBaseState());
         getFromDataBase(dataBase);
      }catch(error){
        if (kDebugMode) {
          print(error.toString());
        }
      }
    });
  }
  
  
  void getFromDataBase(dataBase){
    notes = [];
    dataBase?.rawQuery('SELECT * FROM Note').then((value) {
      notes = value;
      emit(GetFromDataBaseState());
    });
  }


  void deleteFromDataBase({
    required int id,
}){
    dataBase?.rawDelete('DELETE FROM Note WHERE id = ? ',
    [id]).then((value) {
      getFromDataBase(dataBase);
      emit(DeleteFromDataBaseState());
    });
  }

}