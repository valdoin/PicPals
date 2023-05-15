import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picpals/eraser_icon_icons.dart';
import 'package:picpals/home_page.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:picpals/requests/phrase_requests.dart';
import 'dart:typed_data';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'requests/post_requests.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawingBoard(),
    );
  }
}

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  State<DrawingBoard> createState() => DrawingBoardState();
}

class DrawingPoints {
  Offset point;
  Paint paint;
  DrawingPoints({
    required this.point,
    required this.paint,
  });
}

class MyPainter extends CustomPainter {
  List<DrawingPoints?> points;
  MyPainter({required this.points});
  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < points.length - 1; i++) {
      var currentPoint = points[i];
      var nextPoint = points[i + 1];
      if (currentPoint != null && nextPoint != null) {
        canvas.drawLine(
            currentPoint.point, nextPoint.point, currentPoint.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawingBoardState extends State<DrawingBoard> {
  List<DrawingPoints?> points = [];
  Color strokeColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  void startDrawing(DragStartDetails details) {
    setState(() {
      addPoint(details.globalPosition);
    });
  }

  void updateDrawing(DragUpdateDetails details) {
    setState(() {
      addPoint(details.globalPosition);
    });
  }

  void endDrawing(DragEndDetails details) {
    setState(() {
      points.add(null);
    });
  }

  void addPoint(Offset position) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(position);
    double adjustY =
        -140.0; //j'ai du ajuster manuellement le tracé du widget CustomPaint, sans quoi il était décalé par rapport à la position de mon doigt
    localPosition = localPosition.translate(0.0, adjustY);
    points.add(
      DrawingPoints(
        paint: Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt,
        point: localPosition,
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<http.Response> resPhrase = PhraseRequests.getPhrase();

  @override
  Widget build(BuildContext context) {
    WidgetsToImageController controller = WidgetsToImageController();
    var boardSize = MediaQuery.of(context).size.width * 0.95;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Text(
            "PicPals",
            style: GoogleFonts.getFont(
              'Varela Round',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          //bouton dans l'appbar qui permet d'envoyer le dessin une fois celui-ci fini
          IconButton(
            tooltip: 'Envoyer le dessin',
            onPressed: () async {
              final bytes = await controller.capture();
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Center(child: Text("Envoyer le dessin ?")),
                  content: SizedBox(
                    height: boardSize * 0.7,
                    width: boardSize * 0.7,
                    child: Image.memory(bytes!),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        PostRequests.create(bytes);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const HomePage();
                          },
                        ));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Center(child: Text('Envoyer')),
                      ),
                    ),
                    TextButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Center(child: Text('Annuler')),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            //ici texte d'exemple, sera remplacé par notre phrase aléatoire générée chaque jour
            child: FutureBuilder(
              future: resPhrase,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    jsonDecode(snapshot.data!.body)["phrase"]["phrase"]
                        .toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Text(
                    'erreur',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  );
                }
              }),
            ),
          ),
          const SizedBox(height: 10.0),
          //toile de dessin user
          SizedBox(
            height: boardSize * 1.3,
            width: boardSize * 1.3,
            //ClipRect permet de garder le dessin au sein de la toile, pas de débordement possible
            child: ClipRect(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                //detecte touch input user et fait appel aux fonctions de dessin crées précedemment
                child: GestureDetector(
                  onPanStart: startDrawing,
                  onPanUpdate: updateDrawing,
                  onPanEnd: endDrawing,
                  child: WidgetsToImage(
                    controller: controller,
                    child: CustomPaint(
                      size: const Size(475, 475),
                      painter: MyPainter(
                        points: points,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 75.0),
              //slider qui permet de régler l'épaisseur du trait
              child: Slider(
                activeColor: Theme.of(context).primaryColor,
                value: strokeWidth,
                onChanged: (value) {
                  setState(() {
                    strokeWidth = value;
                  });
                },
                min: 0,
                max: 12,
                divisions: 4,
                label: (() {
                  switch (strokeWidth.round()) {
                    case 0:
                      return 'Très fin';
                    case 3:
                      return 'Fin';
                    case 6:
                      return 'Normal';
                    case 9:
                      return 'Epais';
                    case 12:
                      return 'Très épais';
                    default:
                      return '';
                  }
                }()),
              ),
            ),
          ),
        ],
      ),
      //container de fonctionnalités dessin
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //bouton qui permet de changer la couleur du tracé en rouge
            FloatingActionButton(
                mini: true,
                shape: const CircleBorder(),
                backgroundColor: Colors.red,
                onPressed: () {
                  setState(() {
                    strokeColor = Colors.red;
                  });
                }),
            //bouton qui permet de changer la couleur du tracé en vert
            FloatingActionButton(
                mini: true,
                shape: const CircleBorder(),
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    strokeColor = Colors.green;
                  });
                }),
            //bouton qui permet de changer la couleur du tracé en bleu
            FloatingActionButton(
                mini: true,
                shape: const CircleBorder(),
                backgroundColor: Colors.blue,
                onPressed: () {
                  setState(() {
                    strokeColor = Colors.blue;
                  });
                }),
            //bouton qui permet de changer la couleur du tracé en noir
            FloatingActionButton(
                mini: true,
                shape: const CircleBorder(),
                backgroundColor: Colors.black,
                onPressed: () {
                  setState(() {
                    strokeColor = Colors.black;
                  });
                }),
            //bouton qui permet de choisir sa couleur depuis une palette
            FloatingActionButton(
              mini: true,
              shape: const CircleBorder(),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Center(child: Text('Choisis ta couleur !')),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        labelTypes: const [ColorLabelType.rgb],
                        enableAlpha: false,
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Center(child: Text('OK')),
                        onPressed: () {
                          setState(() {
                            strokeColor = pickerColor;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.indigo,
                      Colors.purple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.color_lens,
                  color: Colors.black,
                ),
              ),
            ),
            //bouton qui permet de gommer
            FloatingActionButton(
              mini: true,
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  strokeColor = Colors.white;
                });
              },
              child: const Icon(
                EraserIcon.eraser,
                color: Colors.black,
              ),
            ),
            //bouton qui permet d'annuler une action
            FloatingActionButton(
              mini: true,
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  if (points.length >= 30) {
                    points.removeRange(points.length - 30, points.length);
                  } else {
                    points.clear();
                  }
                });
              },
              child: const Icon(Icons.undo),
            ),
            //bouton qui permet de remettre la toile à son état initial
            FloatingActionButton(
              mini: true,
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  points.clear();
                });
              },
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
