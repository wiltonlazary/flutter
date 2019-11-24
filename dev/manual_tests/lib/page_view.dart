// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardModel {
  CardModel(this.value, this.size, this.color);
  int value;
  Size size;
  Color color;
  String get label => 'Card $value';
  Key get key => ObjectKey(this);
}

class PageViewApp extends StatefulWidget {
  @override
  PageViewAppState createState() => PageViewAppState();
}

class PageViewAppState extends State<PageViewApp> {
  @override
  void initState() {
    super.initState();
    const List<Size> cardSizes = <Size>[
      Size(100.0, 300.0),
      Size(300.0, 100.0),
      Size(200.0, 400.0),
      Size(400.0, 400.0),
      Size(300.0, 400.0),
    ];

    cardModels = List<CardModel>.generate(cardSizes.length, (int i) {
      final Color color = Color.lerp(Colors.red.shade300, Colors.blue.shade900, i / cardSizes.length);
      return CardModel(i, cardSizes[i], color);
    });
  }

  static const TextStyle cardLabelStyle =
    TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold);

  List<CardModel> cardModels;
  Size pageSize = const Size(200.0, 200.0);
  Axis scrollDirection = Axis.horizontal;
  bool itemsWrap = false;

  Widget buildCard(CardModel cardModel) {
    final Widget card = Card(
      color: cardModel.color,
      child: Container(
        width: cardModel.size.width,
        height: cardModel.size.height,
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(cardModel.label, style: cardLabelStyle)),
      ),
    );

    final BoxConstraints constraints = (scrollDirection == Axis.vertical)
      ? BoxConstraints.tightFor(height: pageSize.height)
      : BoxConstraints.tightFor(width: pageSize.width);

    return Container(
      key: cardModel.key,
      constraints: constraints,
      child: Center(child: card),
    );
  }

  void switchScrollDirection() {
    setState(() {
      scrollDirection = (scrollDirection == Axis.vertical)
        ? Axis.horizontal
        : Axis.vertical;
    });
  }

  void toggleItemsWrap() {
    setState(() {
      itemsWrap = !itemsWrap;
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(child: Center(child: Text('Options'))),
          ListTile(
            leading: const Icon(Icons.more_horiz),
            selected: scrollDirection == Axis.horizontal,
            trailing: const Text('Horizontal Layout'),
            onTap: switchScrollDirection,
          ),
          ListTile(
            leading: const Icon(Icons.more_vert),
            selected: scrollDirection == Axis.vertical,
            trailing: const Text('Vertical Layout'),
            onTap: switchScrollDirection,
          ),
          ListTile(
            onTap: toggleItemsWrap,
            title: const Text('Scrolling wraps around'),
            // TODO(abarth): Actually make this checkbox change this value.
            trailing: Checkbox(value: itemsWrap, onChanged: null),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const Text('PageView'),
      actions: <Widget>[
        Text(scrollDirection == Axis.horizontal ? 'horizontal' : 'vertical'),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return PageView(
      children: cardModels.map<Widget>(buildCard).toList(),
      // TODO(abarth): itemsWrap: itemsWrap,
      scrollDirection: scrollDirection,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: const IconThemeData(color: Colors.white),
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: _buildBody(context),
      ),
    );
  }
}

void main() {
  if (!kIsWeb && Platform.isMacOS) {
    // TODO(gspencergoog): Update this when TargetPlatform includes macOS. https://github.com/flutter/flutter/issues/31366
    // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MaterialApp(
    title: 'PageView',
    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      accentColor: Colors.redAccent,
    ),
    home: PageViewApp(),
  ));
}
