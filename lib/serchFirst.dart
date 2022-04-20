import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SearchFirst extends StatelessWidget {
  const SearchFirst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, AppStates state) {
        // print(" the state is $state");
        if (state is AppInsertDatabaseStatForPerson) {
          Navigator.pop(context);
        }
      }, builder: (context, AppStates state) {
        var x = AppCubit.get(context).database;
        var searchController = TextEditingController();
        return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            controller: searchController,
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
                              AppCubit.get(context)
                                  .getPersonForSearch(x, searchController.text);
                            },
                            child: Text(
                              'Search',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                          ),
                          ListView.builder(
                            itemBuilder: (BuildContext, index) {
                              return AppCubit.get(context)
                                          .personSearch
                                          .length ==
                                      0
                                  ? Container()
                                  : Card(
                                      child: ListTile(
                                        //leading: CircleAvatar(),
                                        title: Text(
                                            "${AppCubit.get(context).personSearch}"),
                                        //subtitle: Text("hazeee"),
                                      ),
                                    );
                            },
                            itemCount: 1,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                          )
                        ],
                      ),
                    ]),
              ),
            ));
      }),
      create: (context) => AppCubit()..createDatabase(),
    );
  }
}
