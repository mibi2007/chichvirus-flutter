import 'package:chichvirus/game/view/components/text_style.dart';
import 'package:flutter/material.dart';

Future<void> showLoseDialog(BuildContext context, {Function? callback}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(''),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                'You Lose',
                textAlign: TextAlign.center,
                style: defaultTextStyle,
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close', style: defaultTextStyle),
            onPressed: () {
              Navigator.of(context).pop();
              if (callback != null) {
                Future.delayed(const Duration(seconds: 2)).then((value) => callback());
              }
            },
          ),
        ],
      );
    },
  );
}
