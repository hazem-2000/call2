import 'dart:io';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:todo/billScreen.dart';
import 'package:todo/firstPage.dart';
import 'package:todo/home%20layout.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart';

import 'cubit/cubit.dart';

var formKey = GlobalKey<FormState>();

Widget buildTaskItem(Map model,BuildContext context) {
  var formKey2 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var iconField = TextEditingController();
  return Dismissible(
    background: Container(
      color: Colors.deepOrangeAccent,
      child: Center(child: Text('Move to notes',style: TextStyle(color: Colors.white),))
    ),
    key: Key(model['id'].toString()),
    onDismissed: (dir) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Do you want to move this S.N to notes',
          btnOkOnPress: () {
            AppCubit.get(context).updateData(status: 'note', id: model['idd']);
            debugPrint('OnClcik');
            print('hazem');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint(
                'Dialog Dissmiss from callback $type');
          },
          btnCancelOnPress: () {})
          .show();


    },
    child: Form(
      key: formKey2,
      child: Padding(

        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The S.N is (${model['sy']})',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('${model['name']}')
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                controller: iconField,
                keyboardType: TextInputType.number,
                //onFieldSubmitted: ,
                //onChanged: ,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bill must be not empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "bill",
                    border: OutlineInputBorder()),
              ),
            ),


            IconButton(
                onPressed: () {
                  if(formKey2.currentState!.validate()){
                    AppCubit.get(context).insertBillToDatabase(
                      number: iconField.text,

                    ).then((value) {
                      if(value==true){

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.SUCCES,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Done',
                          btnOkOnPress: () {
                            debugPrint('OnClcik');
                            print('hazem');
                          },
                          btnOkIcon: Icons.check_circle,
                          onDissmissCallback: (type) {
                            debugPrint('Dialog Dissmiss from callback $type');
                          },
                        ).show();
                        AppCubit.get(context)
                            .updateData(status: 'done', id: model['idd']);
                      }
                      else if (value==false){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'already exist',
                          btnOkOnPress: () {
                            debugPrint('OnClcik');
                            print('hazem');
                          },
                          btnOkColor: Colors.red,
                          btnOkIcon: Icons.clear,
                          onDissmissCallback: (type) {
                            debugPrint('Dialog Dissmiss from callback $type');
                          },
                        ).show();
                      }
                    });
                  }




                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            /*IconButton(
                onPressed: () {
                  AppCubit.get(context).check();
                  *//*AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);*//*
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                )),*/
          ],
        ),
      ),
    ),
  );
}


Widget buildTaskItemForNote(Map model,BuildContext context) {
  var formKey2 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var iconField = TextEditingController();
  return Form(
    key: formKey2,
    child: Padding(

      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The S.N is (${model['sy']})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('${model['name']}'),
                Text('لم يرفق فاتورة',style: TextStyle(color: Colors.red),)
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              controller: iconField,
              keyboardType: TextInputType.number,
              //onFieldSubmitted: ,
              //onChanged: ,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Bill must be not empty';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "bill",
                  border: OutlineInputBorder()),
            ),
          ),


          IconButton(
              onPressed: () {
                if(formKey2.currentState!.validate()){
                  AppCubit.get(context).insertBillToDatabase(
                    number: iconField.text,

                  ).then((value) {
                    if(value==true){

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Done',
                        btnOkOnPress: () {
                          debugPrint('OnClcik');
                          print('hazem');
                        },
                        btnOkIcon: Icons.check_circle,
                        onDissmissCallback: (type) {
                          debugPrint('Dialog Dissmiss from callback $type');
                        },
                      ).show();
                      AppCubit.get(context)
                          .updateData(status: 'done', id: model['idd']);
                    }
                    else if (value==false){
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'already exist',
                        btnOkOnPress: () {
                          debugPrint('OnClcik');
                          print('hazem');
                        },
                        btnOkColor: Colors.red,
                        btnOkIcon: Icons.clear,
                        onDissmissCallback: (type) {
                          debugPrint('Dialog Dissmiss from callback $type');
                        },
                      ).show();
                    }
                  });
                }




              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              )),
          /*IconButton(
              onPressed: () {
                AppCubit.get(context).check();
                *//*AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);*//*
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              )),*/
        ],
      ),
    ),
  );
}


/*Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeLayout();
      }));*/
Widget buildTaskItemForDone(Map model, context) {
  var iconField = TextEditingController();
  return Padding(

    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The S.N is (${model['sy']})',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('${model['name']}'),

            ],
          ),
        ),

        /*IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateData(status: 'archive', id: model['id']);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            )),*/
      ],
    ),
  );
}



Widget buildTaskItemForPerson(Map model, context) {

  return GestureDetector(
    onTap: () {

      print(model['id']);
      AppCubit.get(context).inde = model['id'];
      print('the index isss${AppCubit.get(context).inde}');
      AppCubit.get(context).getData(model['id']);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeLayout();
      }));

    },
    onLongPress: (){
      AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Do you want to delete this person',
          btnOkOnPress: () {
            AppCubit.get(context).deleteDataForPerson(id: model['id']);
            debugPrint('OnClcik');
            print('hazem');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint(
                'Dialog Dissmiss from callback $type');
          },
          btnCancelOnPress: () {})
          .show();

    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            child: Text('${model['id']}'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['name']}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Identification number is (${model['num']})',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Spam machine is (${model['syNum']})',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    ),
  );
}


Widget buildTaskItemForSearchPerson(Map model, context) {

  return GestureDetector(
    onTap: () {

      print(model['id']);
      AppCubit.get(context).inde = model['id'];
      print('the index isss${AppCubit.get(context).inde}');
      AppCubit.get(context).getData(model['id']);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomeLayout();
      }));

    },
    onLongPress: (){
      AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Do you want to delete this person',
          btnOkOnPress: () {
            AppCubit.get(context).deleteDataForPerson(id: model['id']);
            debugPrint('OnClcik');
            print('hazem');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint(
                'Dialog Dissmiss from callback $type');
          },
          btnCancelOnPress: () {})
          .show();

    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            child: Text('${model['id']}'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['name']}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Identification number is (${model['num']})',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Spam machine is (${model['syNum']})',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    ),
  );
}


Widget buildTaskItemForBill(Map model, context) {
  return Dismissible(
    background: Container(
      color: Colors.red,
      child: Icon(Icons.highlight_remove),
    ),
    key: Key(model['id'].toString()),
    onDismissed: (dir) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Do you want to delete this bill',
          btnOkOnPress: () {
            AppCubit.get(context).deleteDataFromBill(id: model['id']);
            debugPrint('OnClcik');
            print('hazem');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint(
                'Dialog Dissmiss from callback $type');
          },
          btnCancelOnPress: () {})
          .show();


    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['billNum']}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    ),
  );
}



index(Map model, context) {
  return model['id'];
}

Widget buildScreenSn(Map model, context) {
  var syNumController = TextEditingController();
  var idController = TextEditingController();
  var index = model['id'];
  var x = AppCubit.get(context).g;
  print("hazem $x");
  return Form(
    key: formKey,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(

          children: [


            TextFormField(
              controller: syNumController,
              keyboardType: TextInputType.number,
              //onFieldSubmitted: ,
              //onChanged: ,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'S.N must be not empty';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Enter S.N",
                  prefixIcon: Icon(Icons.format_list_numbered_outlined),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: idController,
              keyboardType: TextInputType.number,
              //onFieldSubmitted: ,
              //onChanged: ,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'ID must be not empty';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Enter ID",
                  prefixIcon: Icon(Icons.format_list_numbered_outlined),
                  border: OutlineInputBorder()),
            ),
            Center(
                child: MaterialButton(
              onPressed: () {
                if(formKey.currentState!.validate()){
                  AppCubit.get(context).insertToSy(
                      id: idController.text, number: syNumController.text);
                }

              },
              color: Colors.blue,
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ))
          ],
        ),
      ),
    ),
  );
}

Widget statisticScreen(Map model,context){

  var x = AppCubit.get(context).database;
  var idController = TextEditingController();
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Column(
              children: [
                Text('S.N is waiting '),
                Text('${model['sy']}'),
              ],
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              '${model['name']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              children: [
                Text(
                  "S.N is done",
                ),
                Text('963'),
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              TextFormField(
                controller: idController,
                keyboardType: TextInputType.number,
                //onFieldSubmitted: ,
                //onChanged: ,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'ID must be not empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Enter ID",
                    prefixIcon:
                    Icon(Icons.format_list_numbered_outlined),
                    border: OutlineInputBorder()),
              ),
              MaterialButton(
                onPressed: () {
                  AppCubit.get(context).getPerson(x, idController.text);
                  AppCubit.get(context).getStatisticFromDatabase(x,idController.text);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              )
            ],
          ),
        )
      ],
    ),
  );
}


/*Widget buildScreenReport(Map model, context) {
  var idController = TextEditingController();
  var x = AppCubit.get(context).g;
  print("hazem $x");
  return Form(
    key: formKey,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'name is ${model['${idController.text}']}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),

          Text('Identification number is ${model['num']}'),
          SizedBox(
            height: 10,
          ),
          Text("spam machine is ${model['syNum']}"),
          SizedBox(
            height: 20,
          ),

          TextFormField(
            controller: idController,
            keyboardType: TextInputType.number,
            //onFieldSubmitted: ,
            //onChanged: ,
            validator: (value) {
              if (value!.isEmpty) {
                return 'ID must be not empty';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Enter ID",
                prefixIcon: Icon(Icons.format_list_numbered_outlined),
                border: OutlineInputBorder()),
          ),
          Center(
              child: MaterialButton(
            onPressed: () {
              if(formKey.currentState!.validate()){
                AppCubit.get(context).insertToStatistic(
                    id: idController.text, );
              }

            },
            color: Colors.blue,
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ))
        ],
      ),
    ),
  );
}*/
