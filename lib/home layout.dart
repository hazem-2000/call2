import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/archive.dart';
import 'package:todo/bill.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/done.dart';
import 'package:todo/tasks.dart';

import 'constant.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var numController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {
          /*if (state is AppInsertDatabaseStat) {
            Navigator.pop(context);
          }*/
        },
        builder: (context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          var da =AppCubit.get(context).database;
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              actions: [
                PopupMenuButton(
                  onSelected: (value) {
                    // your logic
                    if (value == 'delete') {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Do you want to delete all the data',
                              btnOkOnPress: () {
                                AppCubit.get(context).deleteAllBill();
                                AppCubit.get(context).deleteAllSy();
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
                      print("delete");
                    }

                    else {
                      // AppCubit.get(context).generatePdf();
                      print('report');
                      print('person id is ${AppCubit.get(context).personId}');

                      AppCubit.get(context).getPdf(da);
                      AppCubit.get(context).pdfCreation2(
                          AppCubit.get(context).pdfWait,
                          AppCubit.get(context).pdfDone,
                          AppCubit.get(context).pdfNote,
                         );
                    }
                  },
                  itemBuilder: (BuildContext bc) {
                    return const [
                      PopupMenuItem(
                        child: Text("Delete all"),
                        value: 'delete',
                      ),
                      PopupMenuItem(
                        child: Text("Report"),
                        value: 'about',
                      ),

                    ];
                  },
                )
              ],
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingStat,
              builder: (context) => cubit.screen[cubit.currentIndex],
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()),
            ),

            /* floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        number: numController.text,


                    );
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   number: numController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     /* setState(() {
                    //
                    //      isBottomSheetShown=false;
                    //      fabIcon=Icons.edit;
                    //
                    //      tasks=value;
                    //    })*/;
                    //   });
                    //
                    // });

                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            color: Colors.grey[100],
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    //onFieldSubmitted: ,
                                    //onChanged: ,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'title must be not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Task title",
                                        prefixIcon: Icon(Icons.title),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: numController,
                                    keyboardType: TextInputType.number,
                                    //onFieldSubmitted: ,
                                    //onChanged: ,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'number must be not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "number",
                                        prefixIcon: Icon(Icons
                                            .format_list_numbered_outlined),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                 /* TextFormField(
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    //onFieldSubmitted: ,
                                    //onChanged: ,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Text must be not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "name",
                                        prefixIcon: Icon(Icons
                                            .format_list_numbered_outlined),
                                        border: OutlineInputBorder()),
                                  ),*/

                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  /* isBottomSheetShown=true;
                setState(() {
                  fabIcon=Icons.add;
                })*/

                }
              },
              child: Icon(cubit.fabIcon),
            ),*/
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changIndex(index);
                cubit.getDataForAll();
                cubit.getBillFromDatabase(da);
                print(cubit.sy);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu), label: "Add S.N"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.check), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.note), label: "Notes"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.signal_cellular_null), label: "Statistic"),

                BottomNavigationBarItem(
                    icon: Icon(Icons.comment_bank_outlined), label: "Bill"),

              ],
            ),
          );
        },
      ),
    );
  }
}
