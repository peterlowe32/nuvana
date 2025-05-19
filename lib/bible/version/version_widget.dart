import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'version_model.dart';
import '/flutter_flow/nav/nav.dart';
export 'version_model.dart';

class VersionWidget extends StatefulWidget {
  const VersionWidget({super.key});

  static String routeName = 'Version';
  static String routePath = '/version';

  @override
  State<VersionWidget> createState() => _VersionWidgetState();
}

class _VersionWidgetState extends State<VersionWidget> {
  late VersionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VersionModel());

    _model.seachTextFieldTextController ??= TextEditingController();
    _model.seachTextFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              Navigator.of(context).maybePop(); // ✅ FIXED HERE
            },
          ),
          title: Text(
            'Bible Versions',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.plusJakartaSans(
                    fontWeight: FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _model.seachTextFieldTextController,
                      focusNode: _model.seachTextFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search',
                        hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.plusJakartaSans(
                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                              ),
                              letterSpacing: 0.0,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).lineColor, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).secondaryText, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 18.0,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                            ),
                            letterSpacing: 0.0,
                          ),
                      validator: _model.seachTextFieldTextControllerValidator.asValidator(context),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 5.0, thickness: 1.0, color: FlutterFlowTheme.of(context).accent4),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<ApiCallResponse>(
                        future: BibleForUApiGroup.listOfVersionsCall.call(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: LinearProgressIndicator(color: FlutterFlowTheme.of(context).primary),
                            );
                          }
                          final versions = getJsonField(snapshot.data!.jsonBody, r'''$.data''').toList();

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: versions.length,
                            itemBuilder: (context, i) {
                              final item = versions[i];
                              return InkWell(
                                onTap: () async {
                                  FFAppState().getVersionsShortNameVar =
                                      getJsonField(item, r'''$.ref''').toString();
                                  FFAppState().update(() {});
                                  context.pushNamed(BibleIndexWidget.routeName);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getJsonField(item, r'''$.ref''').toString(),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Text(
                                        getJsonField(item, r'''$.name''').toString(),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              color: FlutterFlowTheme.of(context).accent1,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
