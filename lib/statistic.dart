import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constant.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class Statistic extends StatelessWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var idController = TextEditingController();
          var tasks = AppCubit.get(context).wait;
          var x = AppCubit.get(context).database;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Column(
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
                      ),
                      AppCubit.get(context).personId.length==0?Container(): Column(
                        children: [
                          Text(
                            '${AppCubit.get(context).personId}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Column(
                            children: [
                              Text('S.N is waiting : ${AppCubit.get(context).wait.length}'),
                              Text('S.N dose not send bill : ${AppCubit.get(context).noteStatistic.length}'),
                              Container(
                                  height: 100,
                                  width: 150,
                                  child: ListView.builder(
                                    itemBuilder: (BuildContext, index){
                                      return Card(
                                        child: ListTile(
                                          //leading: CircleAvatar(backgroundImage: AssetImage(images[index]),),
                                          title: Text("${AppCubit.get(context).wait}"),
                                          subtitle: Text("${AppCubit.get(context).noteStatistic}"),
                                        ),
                                      );
                                    },
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(5),
                                    scrollDirection: Axis.vertical,
                                  )
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          Column(
                            children: [
                              Text(
                                "S.N is done : ${AppCubit.get(context).done.length}",
                              ),
                              Container(
                                  height: 100,
                                  width: 150,
                                  child: ListView.builder(
                                    itemBuilder: (BuildContext, index){
                                      return Card(
                                        child: ListTile(
                                          //leading: CircleAvatar(backgroundImage: AssetImage(images[index]),),
                                          title: Text("${AppCubit.get(context).done}"),
                                          //subtitle: Text("This is subtitle"),
                                        ),
                                      );
                                    },
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(5),
                                    scrollDirection: Axis.vertical,
                                  )
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
          /*ListView.separated(
              itemBuilder: (context,index)=>statisticScreen(tasks[index],context),
              separatorBuilder: (context,index)=>Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              itemCount: 1);*/
        });
  }
}
