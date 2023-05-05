"use strict";

export function unescapeHTML(text) {
  const parser = new DOMParser().parseFromString(text, "text/html");
  return parser.documentElement.textContent;
}
