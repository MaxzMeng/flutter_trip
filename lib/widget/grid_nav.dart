import 'package:flutter/material.dart';
import 'package:trip/model/grid_nav_model.dart';

class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('test');
  }
}
