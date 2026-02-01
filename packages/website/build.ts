import { copyFileSync, mkdirSync, readdirSync, statSync, existsSync } from "fs";
import { join } from "path";

const PUBLIC_DIR = "./public";
const DIST_DIR = "./dist";
const DROP_IN_DIR = "../drop-in-css";

function copyDir(src: string, dest: string) {
  mkdirSync(dest, { recursive: true });

  for (const entry of readdirSync(src)) {
    const srcPath = join(src, entry);
    const destPath = join(dest, entry);

    if (statSync(srcPath).isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      copyFileSync(srcPath, destPath);
    }
  }
}

// Clean and create dist directory
mkdirSync(DIST_DIR, { recursive: true });

// Copy public files
if (existsSync(PUBLIC_DIR)) {
  copyDir(PUBLIC_DIR, DIST_DIR);
}

// Copy minified CSS (use minified version for production)
const minCssPath = join(DROP_IN_DIR, "dist/drop-in.min.css");
const cssPath = join(DROP_IN_DIR, "drop-in.css");

if (existsSync(minCssPath)) {
  copyFileSync(minCssPath, join(DIST_DIR, "drop-in.css"));
  console.log("✓ Copied minified drop-in.css");
} else if (existsSync(cssPath)) {
  copyFileSync(cssPath, join(DIST_DIR, "drop-in.css"));
  console.log("✓ Copied drop-in.css (not minified - run build:drop-in-css first for minified version)");
}

// Copy assets directory if it exists
const assetsDir = join(DROP_IN_DIR, "assets");
if (existsSync(assetsDir)) {
  copyDir(assetsDir, join(DIST_DIR, "assets"));
  console.log("✓ Copied assets");
}

console.log(`✓ Website built to ${DIST_DIR}`);
