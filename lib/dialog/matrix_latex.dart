import 'package:flutter/cupertino.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter/material.dart';

class MatrixLatex extends StatefulWidget {
  final String latexText;
  final String label;
  const MatrixLatex({Key key, this.label, this.latexText}) : super(key: key);
  @override
  _MatrixLatexState createState() => _MatrixLatexState();
}

class _MatrixLatexState extends State<MatrixLatex> {
  double _height = 100;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Matrix ${this.widget.label}'),
      content: Container(
        //  TODO  BUG: Need to be able to wait until the tex finishes rendering and then set the container height
        child: TeXView(
          teXHTML: this.widget.latexText,
          renderingEngine: RenderingEngine
              .Katex, // Katex for fast render and MathJax for quality render.
          loadingWidget: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Rendering LaTeX...")
              ],
            ),
          ),
          onRenderFinished: (height) {
            print("Widget Height is : $height");
            this.setState(() => _height = height);
          },
          onPageFinished: (string) {
            print("Page Loading finished");
          },
        ),
        height: _height + 11,
      ),
    );
  }
}
