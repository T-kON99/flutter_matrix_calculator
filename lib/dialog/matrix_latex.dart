import 'package:flutter/cupertino.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter/material.dart';

class MatrixLatex extends StatefulWidget {
  final String latexText;
  final String label;
  final List<Widget> actions;
  // Fix KaTeX brocken bracket when row is bigger than 2.
  final int matrixRow;
  const MatrixLatex({Key key, this.label, this.latexText, this.actions, this.matrixRow}) : super(key: key);
  @override
  _MatrixLatexState createState() => _MatrixLatexState();
}

class _MatrixLatexState extends State<MatrixLatex> {
  double _height = 100;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.label),
      actions: widget.actions,
      content: Container(
        child: TeXView(
          child: TeXViewColumn(
            id: "matrix_latex",
            children: [
              TeXViewColumn(children: [
                TeXViewDocument(this.widget.latexText, style: TeXViewStyle(textAlign: TeXViewTextAlign.Left)),
              ]),
            ]
          ),
          renderingEngine: this.widget.matrixRow > 2 ? TeXViewRenderingEngine.mathjax() : TeXViewRenderingEngine.katex(), // Katex for fast render and MathJax for quality render.
          loadingWidgetBuilder: (BuildContext context) => Center(
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
        ),
        height: _height + 11,
      ),
    );
  }
}
