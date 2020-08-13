import 'package:flutter/cupertino.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter/material.dart';

class MatrixLatex extends StatefulWidget {
  final String latexText;
  final String label;
  final List<Widget> actions;
  const MatrixLatex({Key key, this.label, this.latexText, this.actions}) : super(key: key);
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
                TeXViewDocument(this.widget.latexText, style: TeXViewStyle(textAlign: TeXViewTextAlign.Center)),
              ]),
            ]
          ),
          renderingEngine: TeXViewRenderingEngine.katex(), // Katex for fast render and MathJax for quality render.
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
