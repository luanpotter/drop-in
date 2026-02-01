# drop-in

[![CI](https://img.shields.io/github/actions/workflow/status/luanpotter/drop-in/ci.yaml?logo=github&style=flat-square)](https://github.com/luanpotter/drop-in/actions/workflows/ci.yaml)
[![NPM](https://img.shields.io/npm/v/drop-in-css?style=flat-square&logo=npm&color=%23e07020)](https://www.npmjs.com/package/drop-in-css)
[![Examples](https://img.shields.io/badge/examples-live-blue?style=flat-square)](https://luan.xyz/projects/drop-in)
[![License](https://img.shields.io/github/license/luanpotter/drop-in?style=flat-square)](./LICENSE)

The simplest "drop-in" replacement for the browser's default styling.

Just **drop-in** to your app and _don't think about CSS again_.

<img src="./assets/screenshot.png" alt="drop-in logo" width="720" />

## Installation

```bash
bun add drop-in-css
```

And then import with your bundler:

```ts
import "drop-in-css";
```

Or link it directly:

```html
<link rel="stylesheet" href="https://luan.xyz/projects/drop-in/drop-in.css" />
```

## Features

- minimize ad-hoc CSS - things should look good with just HTML
- dark theme out-of-the-box; light theme out of the box
- basic layouts for single column content with menus and content boxes
- simplified color schema and nice monospace [Writer](https://github.com/tonsky/font-writer) font by [@tonsky](https://github.com/tonsky)
- basic styling for links, lists, form elements, buttons
- add your own specific styles on top as needed

## Standard Classes

While the main objective is to have as minimal as possible ad-hoc CSS or custom classes, there are a few standard classes you can use to modify certain elements:

- `.accent` - for buttons and inline code for that extra highlight
- `.danger` - for buttons (for destructive actions)
- `.error` - for fieldsets and spans in certain contexts (such as inside labels or legends)

## Variables

Customize the theme by overriding these variables:

```css
:root {
  --bg: #3c3c3c;
  --text: #ccc;
  --accent: #e07020;
  --danger: #c04040;
  --border: #666;
  --font: "Writer", monospace;
}
```
