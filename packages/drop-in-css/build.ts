import { transform } from "lightningcss";
import { readFileSync, writeFileSync, mkdirSync, existsSync } from "fs";
import { dirname, join } from "path";

let css = readFileSync("drop-in.css", "utf8");

// Inline font files as base64
css = css.replace(/url\(["']?([^"')]+\.woff2)["']?\)/g, (match, fontPath) => {
  // Resolve path relative to CSS file
  const absolutePath = join(dirname("drop-in.css"), fontPath);

  if (existsSync(absolutePath)) {
    const fontBuffer = readFileSync(absolutePath);
    const base64 = fontBuffer.toString("base64");
    console.log(`✓ Inlined ${fontPath} (${(fontBuffer.length / 1024).toFixed(1)}KB)`);
    return `url("data:font/woff2;base64,${base64}")`;
  }

  console.warn(`⚠ Font not found: ${absolutePath}`);
  return match;
});

const { code } = transform({
  filename: "drop-in.css",
  code: Buffer.from(css),
  minify: true,
  sourceMap: false,
});

mkdirSync("dist", { recursive: true });
writeFileSync("dist/drop-in.min.css", code);

console.log("✓ Built dist/drop-in.min.css");
