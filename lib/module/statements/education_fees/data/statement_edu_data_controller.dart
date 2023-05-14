import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/statement_edu_info_model.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 01,April,2023.

class StatementEduDataController {
  StatementEduDataController._internal();

  factory StatementEduDataController() => instance;
  static final StatementEduDataController instance = StatementEduDataController._internal();

  StatementEduInfoModel eduInfo = StatementEduInfoModel();



}

final statementEduDataControllerProvider = Provider<StatementEduDataController>((_) => StatementEduDataController.instance);