# 📝 **JADH2025 poster production and TikZ layout summary**

## 📂 **Repository Structure**

```
JADH2025-poster/
├── poster.tex            % Main LaTeX file
├── images/               % Background images and figures
│   └── background.jpg
├── fonts/                % Custom fonts (if needed)
├── README.md             % Repository description (English; this file)
├── README-ja.md          % Repository description (Japanese)
├── LICENSE               % License (CC BY, etc.)
├── .gitignore            % Exclude intermediate files
└── build/                % Output PDFs and temporary files (gitignore target)
```

### 🎯 **Purpose**

- A0 vertical size academic poster
- English and Japanese language switching
- Background image and multilingual title
- Completely free layout

---

## 🌿 **Main Components**

✅ **Document Class**

```latex
\documentclass{article}
\usepackage[paperwidth=84.1cm, paperheight=118.9cm, margin=0cm]{geometry}
```

→ with `geometry` to specify paper size → using `article` + `tikz` for free layout instead of `standalone`

---

✅ **Font**

```latex
\usepackage{fontspec}
\setmainfont{Noto Sans}
\newfontfamily\jpfont{Noto Sans CJK JP}
```

→ Scalable fonts allow large text without warnings

---

✅ **TikZ Background Image**

```latex
\node[
  anchor=south west,
  inner sep=0,
  opacity=0.2
] at (current page.south west) {
  \includegraphics[width=\paperwidth,height=\paperheight]{背景画像ファイル}
};
```

→ `opacity=0.2` for transparency

---

✅ **Language Switching**

```latex
\newif\ifENG
\ENGtrue % English version
```

Change per node:

```latex
\ifENG
    English text
\else
    Japanese text
\fi
```

→ to avoid text length differences, **split by nodes**

---

✅ **Color Scheme**

```latex
\usepackage{xcolor}
\definecolor{katanoPurple}{HTML}{4B0082}
\definecolor{katanoBlue}{HTML}{4466CC}
\definecolor{katanoTextGray}{HTML}{333333}
```

→ `text=katanoPurple` for application

---

✅ **Title and Author Formatting**

- `\fontsize{...}{...}\selectfont` for arbitrary sizes
- Superscript numbers recommended with `\raisebox`

Example:

```latex
Hilofumi Yamamoto{\raisebox{1.5ex}{\fontsize{20pt}{20pt}\selectfont 1}}
```

---

✅ **Copyright and License**

```latex
Background Image courtesy of the Museum of Fine Arts, Boston; Public Domain
```

→ CC BY license for the poster

---

✅ **Comments** is composed entirely with TikZ, allowing:

- Absolute positioning
- Completely free layout
- Safe and stable operation with English-Japanese switching

---

✨ **Next Steps**

- Figure and Table Configuration
- Gridlines to devide sections
-
