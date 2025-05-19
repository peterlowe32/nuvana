import '/flutter_flow/flutter_flow_util.dart';
import 'books_widget.dart' show BooksWidget;
import 'package:flutter/material.dart';

class BooksModel extends FlutterFlowModel<BooksWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for seachTextField widget.
  FocusNode? seachTextFieldFocusNode;
  TextEditingController? seachTextFieldTextController;
  String? Function(BuildContext, String?)?
      seachTextFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    seachTextFieldFocusNode?.dispose();
    seachTextFieldTextController?.dispose();
  }
}
