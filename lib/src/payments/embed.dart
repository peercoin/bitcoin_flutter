import 'dart:convert';
import 'dart:typed_data';
import 'package:meta/meta.dart';

import '../models/networks.dart';
import '../utils/script.dart' as bscript;
import '../utils/constants/op.dart';

const int MAX_OP_RETURN_SIZE = 80; //TODO Replace with correct value

class P2DATA {
  String words;
  Uint8List output;
  NetworkType network;
  P2DATA({@required words, network}) {
    this.network = network ?? bitcoin;
    this.words = words;
    _init();
  }

  _init() {
    if (words != null) {
      if (words.length <= MAX_OP_RETURN_SIZE-1) {
        _generateOutput(words);
      } else {
        throw new ArgumentError('Too much data');
      }
    } else {
      throw new ArgumentError('Data to be embedded not found');
    }
  }

  void _generateOutput(String words) {
    output = bscript.compile([
      OPS['OP_RETURN'],
      utf8.encode(words)
    ]);
  }
}
