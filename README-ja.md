# 📝 **JADH2025ポスター・TikZレイアウト**

[Japanese](README-ja.md) | [English](README.md)

## 📂 **リポジトリ構成**

```
JADH2025-poster/
├── poster.tex            % メインのLaTeXファイル
├── images/               % 背景画像や図表
│   └── background.jpg
├── fonts/                % カスタムフォント (必要なら)
├── README.md             % リポジトリ説明
├── LICENSE               % ライセンス (CC BYなど)
├── .gitignore            % 中間ファイル除外
└── build/                % 出力PDFや一時ファイル (gitignore対象)
```

### 🎯 **目的**

- A0縦サイズの学会ポスター
- 英語・日本語の切り替え対応
- 背景画像・多言語タイトル
- 完全自由レイアウト

---

## 🌿 **主な構成**

✅ **ドキュメントクラス**

```latex
\documentclass{article}
\usepackage[paperwidth=84.1cm, paperheight=118.9cm, margin=0cm]{geometry}
```

→ `geometry` で用紙サイズを指定→ `standalone` は使わず `article` + `tikz` で自由レイアウト

---

✅ **フォント**

```latex
\usepackage{fontspec}
\setmainfont{Noto Sans}
\newfontfamily\jpfont{Noto Sans CJK JP}
```

→ スケーラブルフォントで大きな文字も警告なし

---

✅ **TikZ背景画像**

```latex
\node[
  anchor=south west,
  inner sep=0,
  opacity=0.2
] at (current page.south west) {
  \includegraphics[width=\paperwidth,height=\paperheight]{背景画像ファイル}
};
```

→ `opacity=0.2`で薄く

---

✅ **英日切り替え**

```latex
\newif\ifENG
\ENGtrue % 英語版
```

ノードごとに切り替え：

```latex
\ifENG
  英語テキスト
\else
  日本語テキスト
\fi
```

→ 文字数差の影響を避けるため**ノード単位で分ける**

---

✅ **色定義**

```latex
\usepackage{xcolor}
\definecolor{katanoPurple}{HTML}{4B0082}
\definecolor{katanoBlue}{HTML}{4466CC}
\definecolor{katanoTextGray}{HTML}{333333}
```

→ `text=katanoPurple`で適用

---

✅ **文字装飾**

- `\fontsize{...}{...}\selectfont`で任意サイズ
- 上付き番号は `\raisebox` 推奨

例：

```latex
Hilofumi Yamamoto{\raisebox{1.5ex}{\fontsize{20pt}{20pt}\selectfont 1}}
```

---

✅ **著作権表記**

```latex
Background Image courtesy of the Museum of Fine Arts, Boston; Public Domain
```

→ 非営利利用なら十分

---

✅ **コメント** TikZのみで構成することで

- 絶対座標で配置
- 完全自由レイアウト
- 英日分岐も安全とても安定した運用が可能

---

✨ **次にやりたいこと**

- 図表配置
- 区切り罫線
