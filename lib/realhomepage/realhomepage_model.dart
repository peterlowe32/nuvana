import '/flutter_flow/flutter_flow_util.dart';
import 'realhomepage_widget.dart' show RealhomepageWidget;
import 'package:flutter/material.dart';

class RealhomepageModel extends FlutterFlowModel<RealhomepageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
