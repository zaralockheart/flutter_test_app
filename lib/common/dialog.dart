import 'package:flutter/material.dart';
import 'package:untitled/common/system_padding.dart';

class MyDialog extends Dialog {

  const MyDialog({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new SystemPadding(
      child: new Center(
          child: new Container(
            decoration: new BoxDecoration(
              border: new Border.all(width: 3.0, color: Colors.white),
              borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
              color: Colors.white
            ),
              margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
              child: new ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 280.0),
                  child: new Material(
                    color: Colors.white,
                      child:new IntrinsicWidth(
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                new Center(
                                    child: child
                                )
                              ],
                            ),
                          )
                      )
              )
          )
      ),
    );
  }
}
