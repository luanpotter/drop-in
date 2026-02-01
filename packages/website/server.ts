import { readFileSync, existsSync } from "fs";
import { join, extname } from "path";

const PORT = 3000;
const PUBLIC_DIR = "./public";
const DROP_IN_CSS = "../drop-in-css/drop-in.css";

const MIME_TYPES: Record<string, string> = {
  ".html": "text/html",
  ".css": "text/css",
  ".js": "application/javascript",
  ".json": "application/json",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".svg": "image/svg+xml",
  ".woff2": "font/woff2",
};

function serveFile(path: string): Response {
  try {
    const content = readFileSync(path);
    const ext = extname(path);
    const contentType = MIME_TYPES[ext] || "application/octet-stream";
    return new Response(content, {
      headers: { "Content-Type": contentType },
    });
  } catch {
    return new Response("Not Found", { status: 404 });
  }
}

Bun.serve({
  port: PORT,
  fetch(req) {
    const url = new URL(req.url);
    let pathname = url.pathname;

    // Serve drop-in.css from the library package
    if (pathname === "/drop-in.css") {
      return serveFile(DROP_IN_CSS);
    }

    // Serve assets (fonts, etc.) from the library package
    if (pathname.startsWith("/assets/")) {
      const assetPath = join("../drop-in-css", pathname);
      if (existsSync(assetPath)) {
        return serveFile(assetPath);
      }
    }

    // Default to index.html for root
    if (pathname === "/") {
      pathname = "/index.html";
    }

    const filePath = join(PUBLIC_DIR, pathname);
    return serveFile(filePath);
  },
});

console.log(`🚀 Dev server running at http://localhost:${PORT}`);
