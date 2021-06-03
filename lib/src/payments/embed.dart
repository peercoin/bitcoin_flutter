import 'dart:convert';
import 'package:meta/meta.dart';

import '../models/networks.dart';
import '../payments/index.dart' show PaymentData;
import '../utils/script.dart' as bscript;
import '../utils/constants/op.dart';

class P2DATA {
  String words;
  PaymentData data;
  NetworkType network;
  P2DATA({@required words, network}) {
    this.network = network ?? bitcoin;
    this.words = words;
    _init();
  }

  _init() {
    if (words != null) {
      if (words.length <= 79) { //TODO Replace with MAX_OP_RETURN_SIZE - 1 byte
        _generateOutput(words);
      } else {
        throw new ArgumentError('Too much data');
      }
    } else {
      throw new ArgumentError('Data to be embedded not found');
    }
  }

  void _generateOutput(String words) {
    data.output = bscript.compile([
      OPS['OP_RETURN'],
      utf8.encode(words)
    ]);
  }
}
