import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

import 'constant.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var p = AppCubit.get(context).g;

          //var x=AppCubit.get(context).getData(person);
          print("list $p");

          var syNumController = TextEditingController();
          var idController = TextEditingController();

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
                                  id: idController.text, number: syNumController.text).then((value) {
                                    if(value==false){
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'This S.N is already exist',
                                        btnOkOnPress: () {
                                          debugPrint('OnClcik');
                                          print('hazem');
                                        },
                                        btnOkColor: Colors.red,
                                        btnOkIcon: Icons.error,
                                        onDissmissCallback: (type) {
                                          debugPrint('Dialog Dissmiss from callback $type');
                                        },
                                      ).show();
                                    }
                              });
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
          /*Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('name is hazem',style: TextStyle(fontSize: 20),),
              SizedBox(
                height: 10,
              ),
              Text('Identification number is 2165440641'),
              SizedBox(
                height: 10,
              ),
              Text("spam machine is 333"),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: syNumController,
                keyboardType: TextInputType.text,
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
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder()),
              ),
              MaterialButton(onPressed: (){
                AppCubit.get(context).getData(2);
              },child: Text("hhhhh"),)

            ],
          ),
        );*/
        });
  }
}
