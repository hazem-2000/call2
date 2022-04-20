import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/archive.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/done.dart';
import 'package:todo/serchFirst.dart';
import 'package:todo/tasks.dart';

import 'constant.dart';

class FirstPage extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var numController = TextEditingController();
  var syNumberController = TextEditingController();
  var tableController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {
          // print(" the state is $state");
          if (state is AppInsertDatabaseStatForPerson) {
            Navigator.pop(context);
          }
        },
        builder: (context, AppStates state) {
          var x = AppCubit.get(context).database;
          var person = AppCubit.get(context).person;
          var p = AppCubit.get(context).g;
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              actions: [
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return SearchFirst();
                  }));
                }, icon: Icon(Icons.search))
              ],
              title: Text('Add'),
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/saudicall.jpeg"),
                     // fit: BoxFit.cover
                  )
              ),
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      buildTaskItemForPerson(person[index], context),
                  separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                  itemCount: person.length),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabaseForPerson(
                      name: nameController.text,
                      num: numController.text,
                      syNum: syNumberController.text,
                    );
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
                                    controller: nameController,
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
                                        labelText: "Enter name",
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
                                        labelText: "Identification number",
                                        prefixIcon: Icon(Icons
                                            .format_list_numbered_outlined),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: syNumberController,
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
                                        labelText: "Spam Number",
                                        prefixIcon: Icon(Icons
                                            .format_list_numbered_outlined),
                                        border: OutlineInputBorder()),
                                  ),
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
            ),
          );
        },
      ),
    );
  }
}
