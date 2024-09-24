import 'package:flutter/cupertino.dart';
extension Space on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}
double figmaHeight=844;
double figmaWidth=380;