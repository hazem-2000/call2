import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/constant.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class BillScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var bill=AppCubit.get(context).bill;
    return ListView.separated(
              itemBuilder: (context,index)=>buildTaskItemForBill(bill[index],context),
              separatorBuilder: (context,index)=>Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              itemCount: bill.length);
  }
}
