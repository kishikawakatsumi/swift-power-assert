"use strict";

import "xterm/css/xterm.css";
import { Terminal } from "xterm";
import { FitAddon } from "xterm-addon-fit";
import { WebLinksAddon } from "xterm-addon-web-links";

const ESC = "\u001B[";

export class Console {
  constructor(container) {
    this.terminal = new Terminal({
      theme: {
        // https://github.com/sonph/onehalf
        background: "#282C34",
        black: "#282C34",
        blue: "#61AFEF",
        brightBlack: "#282C34",
        brightBlue: "#61AFEF",
        brightCyan: "#56B6C2",
        brightGreen: "#98C379",
        brightPurple: "#C678DD",
        brightRed: "#E06C75",
        brightWhite: "#DCDFE4",
        brightYellow: "#E5C07B",
        cyan: "#56B6C2",
        foreground: "#DCDFE4",
        green: "#98C379",
        name: "One Half Dark",
        purple: "#C678DD",
        red: "#E06C75",
        white: "#DCDFE4",
        yellow: "#E5C07B",
      },
      fontFamily:
        "Menlo, Consolas, 'DejaVu Sans Mono', 'Ubuntu Mono', monospace",
      fontSize: 15,
      lineHeight: 1.1,
      convertEol: true,
      cursorStyle: "block",
      cursorBlink: true,
      scrollback: 100000,
    });
    this.terminal.open(container);

    this.terminal.loadAddon(new WebLinksAddon());

    const fitAddon = new FitAddon();
    this.terminal.loadAddon(fitAddon);
    fitAddon.fit();
  }

  get rows() {
    return this.terminal.rows;
  }

  get cols() {
    return this.terminal.cols;
  }

  moveCursorTo(x, y) {
    if (typeof x !== "number") {
      throw new TypeError("The `x` argument is required");
    }
    if (typeof y !== "number") {
      this.terminal.write(ESC + (x + 1) + "G");
    }
    this.terminal.write(ESC + (y + 1) + ";" + (x + 1) + "H");
  }

  cursorUp(count = 1) {
    this.terminal.write(`${ESC}${count}A`);
  }

  cursorDown(count = 1) {
    this.terminal.write(`${ESC}${count}B`);
  }

  cursorForward(count = 1) {
    this.terminal.write(`${ESC}${count}C`);
  }

  cursorBackward(count = 1) {
    this.terminal.write(`${ESC}${count}D`);
  }

  saveCursorPosition() {
    this.terminal.write(`${ESC}s`);
  }

  restoreCursorPosition() {
    this.terminal.write(`${ESC}u`);
  }

  hideCursor() {
    this.terminal.write(`${ESC}?25l`);
  }

  showCursor() {
    this.terminal.write(`${ESC}?25h`);
  }

  eraseLine() {
    this.terminal.write(`${ESC}2K\r`);
  }

  eraseLines(count) {
    for (let i = 0; i < count; i++) {
      this.terminal.write(`${ESC}1F`);
      this.terminal.write(`${ESC}2K\r`);
    }
  }

  switchNormalBuffer() {
    this.terminal.write("\x9B?47l");
  }

  switchAlternateBuffer() {
    this.terminal.write("\x9B?47h");
  }

  showSpinner(message) {
    const self = this;
    const startTime = performance.now();
    const interval = 200;
    const SPINNER = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
    let spins = 0;
    function updateSpinner(message) {
      const progressText = `${SPINNER[spins % SPINNER.length]} ${message}`;
      const dotCount = Math.floor((spins * 2) / 4) % 4;
      const animationText = `${progressText} ${".".repeat(dotCount)}`;
      const endTime = performance.now();
      const seconds = `${((endTime - startTime) / 1000).toFixed(0)}s`;
      const speces = " ".repeat(
        self.terminal.cols - animationText.length - seconds.length
      );
      self.terminal.write(
        `${ESC}1m${ESC}34m${animationText}${ESC}0m${speces}${seconds}`
      );
      spins++;
    }

    updateSpinner(message);
    return setInterval(() => {
      this.eraseLine();
      updateSpinner(message);
    }, interval);
  }

  hideSpinner(cancelToken) {
    clearInterval(cancelToken);
    this.eraseLine();
  }

  write(text) {
    this.terminal.write(text);
  }

  writeln(text) {
    this.terminal.writeln(text);
  }

  clear() {
    this.terminal.clear();
  }

  reset() {
    this.terminal.reset();
  }
}
