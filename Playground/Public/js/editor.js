"use strict";

import * as monaco from "monaco-editor/esm/vs/editor/editor.api";

export class Editor {
  constructor(container, options) {
    this.editor = monaco.editor.create(container, options);

    this.editor.onDidChangeModelContent(() => {
      this.onchange();
    });

    monaco.languages.registerHoverProvider("swift", {
      provideHover: (model, position) => {
        return this.onhover(position);
      },
    });

    monaco.languages.registerCompletionItemProvider("swift", {
      triggerCharacters: ["."],
      provideCompletionItems: (model, position) => {
        return this.oncompletion(position);
      },
    });

    this.onchange = () => {};
    this.onhover = () => {};
    this.oncompletion = () => {};
    this.onaction = () => {};
  }

  getValue() {
    return this.editor.getValue();
  }

  setValue(value) {
    this.editor.setValue(value);
  }

  setSelection(startLineNumber, startColumn, endLineNumber, endColumn) {
    this.editor.setSelection(
      new monaco.Selection(
        startLineNumber,
        startColumn,
        endLineNumber,
        endColumn
      )
    );
  }

  focus() {
    this.editor.focus();
  }

  scrollToBottm() {
    const model = this.editor.getModel();
    const lineCount = model.getLineCount();
    this.editor.setPosition({
      column: model.getLineLength(lineCount) + 1,
      lineNumber: lineCount,
    });

    this.editor.revealLine(lineCount);
  }

  updateMarkers(markers) {
    this.clearMarkers();
    monaco.editor.setModelMarkers(this.editor.getModel(), "swift", markers);
  }

  clearMarkers() {
    monaco.editor.setModelMarkers(this.editor.getModel(), "swift", []);
  }

  fold(foldingRanges) {
    monaco.languages.registerFoldingRangeProvider("swift", {
      provideFoldingRanges: function (model, context, token) {
        return foldingRanges;
      },
    });
    this.editor.trigger("fold", "editor.foldAll");
  }
}
