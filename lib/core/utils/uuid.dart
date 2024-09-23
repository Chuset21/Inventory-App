import 'package:uuid/uuid.dart';

const _uuid = Uuid();

String get uniqueId => _uuid.v4();