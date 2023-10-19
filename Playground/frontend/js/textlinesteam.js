"use strict";

// Vendored from Deno -
// https://github.com/denoland/deno_std/blob/main/streams/delimiter.ts
// Copyright 2018-2022 the Deno authors. All rights reserved. MIT license.

/** Transform a stream into a stream where each chunk is divided by a newline,
 * be it `\n` or `\r\n`. `\r` can be enabled via the `allowCR` option.
 *
 * ```ts
 * import { TextLineStream } from "./delimiter.ts";
 * const res = await fetch("https://example.com");
 * const lines = res.body!
 *   .pipeThrough(new TextDecoderStream())
 *   .pipeThrough(new TextLineStream());
 * ```
 */
export class TextLineStream extends TransformStream {
  #buf = "";
  #allowCR = false;
  #returnEmptyLines = false;
  #mapperFun = (line) => line;

  constructor(options) {
    super({
      transform: (chunk, controller) => this.#handle(chunk, controller),
      flush: (controller) => this.#handle("\r\n", controller),
    });

    this.#allowCR = options?.allowCR ?? false;
    this.#returnEmptyLines = options?.returnEmptyLines ?? false;
    this.#mapperFun = options?.mapperFun ?? this.#mapperFun;
  }

  #handle(chunk, controller) {
    chunk = this.#buf + chunk;

    for (;;) {
      const lfIndex = chunk.indexOf("\n");

      if (this.#allowCR) {
        const crIndex = chunk.indexOf("\r");

        if (
          crIndex !== -1 &&
          crIndex !== chunk.length - 1 &&
          (lfIndex === -1 || lfIndex - 1 > crIndex)
        ) {
          const curChunk = this.#mapperFun(chunk.slice(0, crIndex));
          if (this.#returnEmptyLines || curChunk) {
            controller.enqueue(curChunk);
          }
          chunk = chunk.slice(crIndex + 1);
          continue;
        }
      }

      if (lfIndex !== -1) {
        let crOrLfIndex = lfIndex;
        if (chunk[lfIndex - 1] === "\r") {
          crOrLfIndex--;
        }
        const curChunk = this.#mapperFun(chunk.slice(0, crOrLfIndex));
        if (this.#returnEmptyLines || curChunk) {
          controller.enqueue(curChunk);
        }
        chunk = chunk.slice(lfIndex + 1);
        continue;
      }

      break;
    }

    this.#buf = chunk;
  }
}
