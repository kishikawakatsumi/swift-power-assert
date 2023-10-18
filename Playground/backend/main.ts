import {
  copy,
  mergeReadableStreams,
  router,
  serveFile,
  TextLineStream,
} from "./deps.ts";

Deno.serve({
  port: 8080,
  handler: router({
    "/": (req) => serveFile(req, "./dist/index.html"),
    "/health{z}?{/}?": () => responseJSON({ status: "pass" }),
    "/run{/}?": async (req) => {
      const parameters: RequestParameters = await req.json();

      const tmpDir = crypto.randomUUID();
      await copy("./TestModule/", tmpDir);

      await Deno.writeTextFile(
        `${tmpDir}/Tests/TestTarget/test.swift`,
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
            "TERM": "xterm-256color",
            "LD_PRELOAD": "./faketty.so",
          },
          cwd: tmpDir,
          stdout: "piped",
          stderr: "piped",
        },
      );

      const process = command.spawn();

      return new Response(
        mergeReadableStreams(
          process.stdout,
          process.stderr,
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
