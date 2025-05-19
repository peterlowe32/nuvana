import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
    this.reflectivePrompt,
  });

  final String? reflectivePrompt;

  static String routeName = 'home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;
  bool _showFullVerse = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResultlw2 = await VerseoftheDayCall.call();

      if ((_model.apiResultlw2?.succeeded ?? true)) {
        _model.apiResultpxl = await ReflectivePromptCall.call();
        if ((_model.apiResultpxl?.succeeded ?? true)) {
          safeSetState(() {});
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final today = 'Monday, May 12';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        top: true,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Daily Word',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .copyWith(color: Colors.white)),
                                Text(today,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                            FlutterFlowIconButton(
                              borderRadius: 12,
                              fillColor: Color(0x33FFFFFF),
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Daily Verse Card
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFullVerse = !_showFullVerse;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Clouds_Background_Image.png"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2),
                              BlendMode.darken,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black12,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '“For I know the plans I have for you,” declares the Lord...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_showFullVerse) ...[
                              SizedBox(height: 12),
                              Text(
                                '...plans to prosper you and not to harm you, plans to give you a hope and a future. — Jeremiah 29:11',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              FFButtonWidget(
                                onPressed: () {
                                  // TODO: launch chat with AI
                                },
                                text: 'Reflect with AI',
                                options: FFButtonOptions(
                                  width: 200,
                                  height: 40,
                                  color: Color(0xFF5C6AC4),
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Reflective Prompt
                    Text(
                      valueOrDefault(widget.reflectivePrompt, '...'),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),

                    SizedBox(height: 16),

                    // Main content reused from original
                    _buildMainTiles(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainTiles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bible and Devotionals section
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildTile(context, Icons.menu_book, 'Bible'),
            _buildTile(context, Icons.favorite, 'Devotionals'),
            _buildTile(context, Icons.bookmark_border, 'Bookmarks'),
            _buildTile(context, Icons.note_alt, 'Notes'),
          ],
        ),
        SizedBox(height: 24),

        Text('Daily Plans',
            style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                )),

        SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E24AA), Color(0xFF5C258D)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('21 Days of Prayer',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .copyWith(color: Colors.white)),
                      Text('Day 7 of 21',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .copyWith(color: Colors.white)),
                      SizedBox(height: 8),
                      FFButtonWidget(
                        onPressed: () {},
                        text: 'Continue',
                        options: FFButtonOptions(
                          height: 36,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          color: Color(0x33FFFFFF),
                          textStyle: TextStyle(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Text(
                    '7',
                    style: FlutterFlowTheme.of(context)
                        .headlineSmall
                        .copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 32),
            SizedBox(height: 8),
            Text(label,
                style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
          ],
        ),
      ),
    );
  }
}
