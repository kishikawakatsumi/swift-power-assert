import { mergeReadableStreams, router, serveFile } from "./deps.ts";

Deno.serve({
  port: 8080,
  handler: router({
    "/": (req) => serveFile(req, "./dist/index.html"),
    "/health{z}?{/}?": () => responseJSON({ status: "pass" }),
    "/run{/}?": async (req) => {
      const parameters: RequestParameters = await req.json();

      await Deno.writeTextFile(
        "./TestModule/Tests/TestTarget/test.swift",
        parameters.code,
      );

      const command = new Deno.Command(
        "swift",
        {
          args: [
            "test",
            "--disable-dependency-cache",
            "--disable-build-manifest-caching",
            "--manifest-cache=none",
            "--skip-update",
          ],
          env: {
            "NSUnbufferedIO": "YES",
            "TERM": "xterm-256color",
            "LD_PRELOAD": "./faketty.so",
          },
          cwd: "./TestModule/",
          stdout: "piped",
          stderr: "piped",
        },
      );

      const process = command.spawn();

      return new Response(
        mergeReadableStreams(
          makeStreamResponse(process.stdout, "stdout"),
          makeStreamResponse(process.stderr, "stderr"),
        ),
        {
          headers: {
            "content-type": "text/plain; charset=utf-8",
            "access-control-allow-origin": "*",
          },
        },
      );
    },
    "/:file": (req, _ctx, match) => serveFile(req, `./dist/${match.file}`),
  }),
});

function makeStreamResponse(
  stream: ReadableStream<Uint8Array>,
  key: string,
): ReadableStream<Uint8Array> {
  return stream.pipeThrough(
    new TransformStream<Uint8Array, Uint8Array>({
      transform(chunk, controller) {
        const text = new TextDecoder().decode(chunk);
        controller.enqueue(
          new TextEncoder().encode(
            `${JSON.stringify(new StreamResponse(key, text))}\n`,
          ),
        );
      },
    }),
  );
}

function responseJSON(
  json: unknown,
): Response {
  return new Response(
    JSON.stringify(json),
    {
      headers: {
        "content-type": "application/json; charset=utf-8",
      },
    },
  );
}

interface RequestParameters {
  code: string;
}

class StreamResponse {
  kind: string;
  text: string;

  constructor(kind: string, text: string) {
    this.kind = kind;
    this.text = text;
  }
}
