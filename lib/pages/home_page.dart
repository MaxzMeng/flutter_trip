import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:trip/dao/home_dao.dart';
import 'package:trip/model/common_model.dart';
import 'package:trip/model/home_model.dart';
import 'package:trip/widget/grid_nav.dart';
import 'package:trip/widget/local_nav.dart';

const APPBAR_MAX_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(initialPage: 0);
  List _imageUrls = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg',
  ];
  double appbarAlpha = 0;
  String resultString = "";
  List<CommonModel> localNavList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_MAX_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha >= 1) {
      alpha = 1;
    }
    setState(() {
      appbarAlpha = alpha;
    });
  }

  loadData() async {
//    HomeDao.fetch().then((result) {
//      setState(() {
//        resultString = json.encode(result);
//      });
//    }).catchError((e) {
//      resultString = e.toString();
//    });
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
                onNotification: (scrollerNotification) {
                  if (scrollerNotification is ScrollUpdateNotification &&
                      scrollerNotification.depth == 0) {
                    _onScroll(scrollerNotification.metrics.pixels);
                  }
                  return true;
                },
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 160,
                      child: Swiper(
                        itemCount: _imageUrls.length,
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            _imageUrls[index],
                            fit: BoxFit.fill,
                          );
                        },
                        pagination: SwiperPagination(),
                      ),
                    ),
                    LocalNav(localNavList: localNavList),
                    Container(
                      height: 800,
                      child: ListTile(
                        title: Text(resultString),
                      ),
                    )
                  ],
                ))),
        Opacity(
          opacity: appbarAlpha,
          child: Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 20), child: Text('首页'))),
          ),
        )
      ],
    ));
  }
}
