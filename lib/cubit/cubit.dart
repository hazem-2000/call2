import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/bill.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/note%20screen.dart';
import 'package:todo/photo.dart';

import '../archive.dart';
import '../done.dart';
import '../statistic.dart';
import '../tasks.dart';
import 'package:pdf/widgets.dart' as pw;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database? database;
  List<Map> newTasks = [];
  List<Map> notes = [];
  List<Map> pdfNote = [];
  int inde = 0;
  List<Map> doneTasks = [];
  List<Map> pdfWait = [];
  List<Map> pdfDone = [];
  List<Map> bill = [];
  List<Map> billOk = [];
  List<Map> billFalse = [];
  List<Map> sy = [];
  List<Map> done = [];
  List<Map> noteStatistic = [];
  List<Map> wait = [];
  List<Map> archiveTasks = [];
  List<Map> person = [];
  List<Map> personSearch = [];
  List<Map> personId = [];
  List<Map> g = [];
  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screen = [
    NewTasksScreen(),
    ArchiveScreen(),
    DoneScreen(),
    NoteScreen(),
    Statistic(),
    Bill(),
  ];
  List<String> title = [
    "Add S.N",
    "Tasks",
    "Done",
    "Notes",
    "Statistic",
    "Bills",

  ];



  void changIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  void chang(int index) {
    inde = index;
    emit(AppChangeIndexState());
  }

  ImagePicker picker = ImagePicker();

  getFromCamera() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image;
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print("database created");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
      )
          .then((value) {
        print('table tasks created');
      }).catchError((error) {
        print('error when creating table  ${error.toString()}');
      });
      database
          .execute(
              'CREATE TABLE sales (id INTEGER PRIMARY KEY, name TEXT, num TEXT, syNum TEXT)')
          .then((value) {
        print('table sales created');
      }).catchError((error) {
        print('error when creating table sales ${error.toString()}');
      });
      database
          .execute(
          'CREATE TABLE syrial (idd INTEGER PRIMARY KEY,id TEXT, sy TEXT UNIQUE,status TEXT)')
          .then((value) {
        print('table syrial created');
      }).catchError((error) {
        print('error when creating table syrial ${error.toString()}');
      });
      database
          .execute(
          'CREATE TABLE bill (id INTEGER PRIMARY KEY, billNum TEXT UNIQUE)')
          .then((value) {
        print('table bill created');
      }).catchError((error) {
        print('error when creating table bill ${error.toString()}');
      });
      database
          .execute(
          'CREATE TABLE cbill (id INTEGER PRIMARY KEY, billNum TEXT)')
          .then((value) {
        print('table cbill created');
      }).catchError((error) {
        print('error when creating table cbill ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      getDataFromDatabaseForPerson(database);
      getSyFromDatabase(database);
      print("database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseStat());
    });
  }

  insertToDatabase(
      {String? title,
      String? number,
      }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$number","","new")')
          .then((value) {
        print('$value inserted successfully to task');
        emit(AppInsertDatabaseStat());
        getDataFromDatabase(database);

      }).catchError((error) {
        print('error when insert data to tasks${error.toString()}');
      });

    });
  }
  bool xa=false;

 Future insertBillToDatabase(
      {
        String? number,
      }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO bill(billNum) VALUES("$number")')
          .then((value) {
        print('$value inserted successfully to bill');
        emit(AppInsertDatabaseStat());
        getBillFromDatabase(database);
        xa=true;

      }).catchError((error) {
        xa=false;
        print('error when insert data to bill${error.toString()}');
      });

    });
    return xa;
  }


  bool aa=false;
  Future insertToSy(
      {
        String?id,
        String? number
      }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO syrial(id,sy,status) VALUES("$id","$number","new")')
          .then((value) {
        print('$value inserted successfully to syrial');
        emit(AppInsertDatabaseStat());
        getSyFromDatabase(database);
        aa=true;

      }).catchError((error) {
        aa=false;
        print('error when insert data to syrial${error.toString()}');
      });

    });
    return aa;
  }



  insertToDatabaseForPerson(
      {
        String? name,
        String? num,
        String? syNum,
        String? sy
      }) async {
    await database!.transaction((txn) async {

      txn
          .rawInsert(
          'INSERT INTO sales(name, num, syNum) VALUES("$name","$num","$syNum")')
          .then((value) {
        print('$value inserted successfully to sales');
        emit(AppInsertDatabaseStatForPerson());
        getDataFromDatabaseForPerson(database);

      }).catchError((error) {
        print('error when insert data to sales${error.toString()}');
      });
    });
  }

  /*void openPar(TextEditingController text){
    text.clear();
    print('iam here');
    emit(AppOpen());
  }*/

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT * FROM tasks').then((value) {
      // print(value);
      value.forEach((element) {
        print(element['status']);
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });

      emit(AppGetDatabaseStat());
    });
  }




  void getBillFromDatabase(database) {
    bill=[];
    billOk=[];
    billFalse=[];
    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT billNum , id FROM bill  ').then((value) {
      // print(value);
      value.forEach((element) {

        //print('bill is  $element');
         bill.add(element);
         /*bill.forEach((e) {
          if(e==element)
            print(" already $element");
          *//*else
            print('bill Done ');*//*
        });*/
      });
      print("bill iss $bill");



      emit(AppGetDatabaseStat());
    });
  }

  void getDataFromDatabaseForPerson(database) {
    person = [];
    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT * FROM sales').then((value) {
      // print(value);
      //print(value);
      value.forEach((elements){
        //print(elements);
        person.add(elements);
      });
     // person.add(value['name']);

      emit(AppGetDatabaseForPersonStat());
    });
  }
   getPerson(database,id) {
    personId = [];

    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT name FROM sales WHERE sales.id = $id').then((value) {
       print('hhhhhhhhhhhhhhhhhhh $value');
      //print(value);
      value.forEach((elements){
        //print(elements);
        personId.add(elements);
      });
     // person.add(value['name']);

      emit(AppGetDatabaseForPersonStat());
    });
  }


  getPersonForSearch(database,num) {
    personSearch = [];

    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT * FROM sales WHERE sales.num = $num').then((value) {
       print('hhhhhhhhhhhhhhhhhhh $value');
      //print(value);
      value.forEach((elements){
        print('search is $elements');
        personSearch.add(elements);
      });
     // person.add(value['name']);

      emit(AppGetDatabaseForPersonStat());
    });
  }
  final pdf=pw.Document();



  Future pdfCreation2(List x,List y,List z)async{

    var data = await rootBundle.load("fonts/Cairo-Bold.ttf");
    var myFont = pw.Font.ttf(data);

    pdf.addPage(

      pw.Page(
        build: (pw.Context context){
          return pw.Column(

            children: [
              pw.Text('Saudi Call',style: pw.TextStyle(font: myFont,fontSize: 50)),
              pw.Divider(),
              pw. Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [





                  pw.SizedBox(
                    height: 10
                  ),

                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text('S.N is waiting : ${pdfWait.length}'),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          for(var i in x)
                            pw.Text('$i\n',style: pw.TextStyle(font: myFont)),
                        ]
                      )


                    ],
                  ),
                  pw.SizedBox(
                    height: 15,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text('S.N waiting to bill : ${pdfNote.length}'),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          children: [
                            for(var i in z)
                              pw.Text('$i\n',style: pw.TextStyle(font: myFont)),
                          ]
                      )


                    ],
                  ),
                  pw.SizedBox(
                    height: 15,
                  ),

                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text(
                        "S.N is done : ${pdfDone.length}",
                      ),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          children: [
                            for(var i in y)
                              pw.Text('$i\n',style: pw.TextStyle(font: myFont)),
                          ]
                      )

                    ],
                  )
                ],
              )

            ],
          );

        },
        pageFormat: PdfPageFormat.a4,
      ),

    );

    var output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    OpenFile.open('${output.path}/example.pdf');
    //file.writeAsBytesSync(pdf.save());
    file.writeAsBytesSync(await pdf.save());
    emit(AppPdfState());


  }



  void getSyFromDatabase(database) {
    notes = [];
    sy=[];
    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT * FROM syrial INNER JOIN sales ON syrial.id=sales.id').then((value) {


      // print(value);
      //print(value);
      value.forEach((elements){
        if (elements['status'] == "new")
          sy.add(elements);
        else if (elements['status'] == "done")
          doneTasks.add(elements);
        else
          notes.add(elements);
        //print(elements);
        //sy.add(elements);
      });
      // person.add(value['name']);

      emit(AppGetDatabaseForPersonStat());
    });
  }


  void getPdf(database) {
    pdfDone=[];
    pdfWait=[];
    pdfNote=[];
    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT name , num , sy , status FROM sales INNER JOIN syrial ON sales.id=syrial.id').then((value) {


      // print(value);
      //print(value);
      value.forEach((elements){
        print('element is $elements');
        if (elements['status'] == "new")
          pdfWait.add(elements);
        else if (elements['status'] == "done")
          pdfDone.add(elements);
        else
          pdfNote.add(elements);
        //print(elements);
        //sy.add(elements);
      });
      // person.add(value['name']);

      emit(AppGetDatabaseForPersonStat());
    });
  }

   getStatisticFromDatabase(database,id) {
    done=[];
    wait=[];
    noteStatistic=[];
    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT sy,status FROM syrial WHERE syrial.id=$id').then((value) {


      // print(value);
      //print(value);
      value.forEach((elements){
        if (elements['status'] == "new"){
          wait.add(elements);
          print('wait is $wait');
        }


        else if (elements['status'] == "done"){
          done.add(elements);
          print('done  is $done');
        }
        else{
          noteStatistic.add(elements);
        }

        //print(elements);
        //sy.add(elements);
      });
      // person.add(value['name']);

      emit(AppGetDatabaseForPersonStat());
    });
  }

  void updateData({required String status, required  id}) async {
    database!.rawUpdate('UPDATE syrial SET status = ? WHERE idd = ? ',
        ['$status', id]).then((value) {
      getSyFromDatabase(database);
      emit(AppUpdateDatabaseStat());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void deleteData({required int id}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ? ', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseStat());
    });
  }

  void deleteAllBill() async {
    database!.rawDelete('DELETE FROM bill ').then((value) {
      getBillFromDatabase(database);
      emit(AppDeleteDatabaseStat());
    });
  }
  void deleteAllSy() async {
    database!.rawDelete('DELETE FROM syrial ').then((value) {
      getSyFromDatabase(database);
      emit(AppDeleteDatabaseStat());
    });
  }

  void deleteSy({required int id}) async {
    database!.rawDelete('DELETE FROM syrial WHERE id = ? ', [id]).then((value) {
      getSyFromDatabase(database);
      emit(AppDeleteDatabaseStat());
    });
  }

  void deleteDataForPerson({required int id}) async {
    database!.rawDelete('DELETE FROM sales WHERE id = ? ', [id]).then((value) {
      getDataFromDatabaseForPerson(database);
      emit(AppDeleteDatabaseStat());
    });
  }


  void deleteDataFromBill({required int id}) async {
    database!.rawDelete('DELETE FROM bill WHERE id = ? ', [id]).then((value) {
      getBillFromDatabase(database);
      emit(AppDeleteDatabaseStat());
    });
  }



   getData(id) {
    g = [];
    emit(AppGetDatabaseLoadingStat());

    database!.rawQuery('SELECT * FROM sales WHERE id=$id').then((value) {
       //print(value);
      //print(value);
      value.forEach((elements){
        g.add(elements);
       // print(elements);

      });
     // print('the g is $g');
      // person.add(value['name']);

      emit(AppGetDatabaseForGetStat());
    });
  }

  getDataForAll(){
    getSyFromDatabase(database);
    getDataFromDatabaseForPerson(database);
    getDataFromDatabase(database);
  }

}
