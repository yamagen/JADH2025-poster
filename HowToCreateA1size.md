# 🧾 Poster.pdf 分割顛末まとめ（A0 → A1×2）

## 🎯 目的

* 元ファイル `poster.pdf`（A0サイズ）を、**上下に分割し、横A1サイズの2ページPDF**として作成したい
* 印刷所にA1×2で渡せるようにすることが目的

---

## 📄 元PDFの確認

* `poster.pdf` のページサイズは **正しくA0（841 × 1189 mm）** であることを確認済み。

---

## 🧪 試行された方法と課題

### 1. `pdfposter` で `-pA1` を指定（→ ❌ 失敗）

```bash
pdfposter -mA0 -pA1 poster.pdf posterA1.pdf
```

* 結果：**左右に分割されてしまい**、上下ではなかった
* 理由：`pdfposter` は短辺方向を優先して自動分割するため

---

### 2. `pdfposter` にスケール指定（→ ❌ `-p`と併用不可）

```bash
pdfposter -mA0 -p841x594mm -s 1 poster.pdf ...
```

* 結果：**エラー**
* 原因：`-p`（出力サイズ）と `-s`（スケール）は**同時に使えない仕様**

---

### 3. `-s 1x2` のような書き方（→ ❌ サポート外）

```bash
pdfposter -mA0 -s 1x2 ...
```

* 結果：**"invalid float value" エラー**
* 理由：先生の環境の `pdfposter` は「分割数（1x2）」を受け付けない旧仕様

---

### 4. `pdfcrop` による強制裁断（→ ⚠️ 不正確な裁断）

```bash
pdfcrop --bbox "0 594 841 1189" poster.pdf poster-top.pdf
```

* 結果：**思ったように切れない／レイアウト崩れ**
* 理由：`pdfcrop` はBoundingBox依存で、正確な物理寸法裁断には不向き

---

## 💡 最終的な成功手法

### ✅ `mutool poster`（MuPDFツール）で上下2分割

```bash
mutool poster -y 2 poster.pdf posterA1.pdf
```

* 成功！**A0を上下に切り、2ページ構成のPDFを生成**
* 各ページは実質的に「横A1サイズ」になっている
* 中身のレイアウトも崩れず、内容は完全に保持される
* 印刷所への入稿用として理想的

---

## 🐛 表示の落とし穴：Zathura の誤認識

* `zathura` では**ページ間の境界が曖昧**に表示されることがあり、
* 分割後のPDFも\*\*「真ん中に線が入った1ページ」に見える\*\*現象が発生

📌 実際には：

* **ページ数は2になっており**
* **各ページは正しく上下に分割された内容を保持している**

👉 解決策：`evince` や `okular` など他のビューアで確認、または `pdfinfo` で物理サイズとページ数を検証

---

## 📎 教訓と再利用ポイント

| 課題                   | 解決策                  | 備考                |
| -------------------- | -------------------- | ----------------- |
| `pdfposter` の自動分割が不適 | `mutool poster -y 2` | 確実に上下分割される        |
| スケール指定の制限            | `-p`と`s`の併用不可に注意     | 分割目的なら`mutool`が簡単 |
| レイアウト崩れ（pdfcrop）     | 使用避ける                | BoundingBox裁断は不正確 |
| 表示の誤解（Zathura）       | 他ビューアで確認             | ページ数確認も重要         |

---

## ✅ 結論

* 今後、**A0→A1×2** の印刷用PDFが必要な場合は：

```bash
mutool poster -y 2 input.pdf output.pdf
```

* これ一発で、**安全・精密・印刷所向きの分割PDF**が得られます！

---

## 🛠 推奨ツールまとめ

| 目的          | ツール                           | 備考              |
| ----------- | ----------------------------- | --------------- |
| PDFページ分割    | `mutool poster`               | 最速・確実           |
| ページ確認       | `evince`, `okular`, `pdfinfo` | レイアウトとサイズの目視確認に |
| PDF編集（回転など） | `pdftk`, `qpdf`               | 必要に応じて          |

---

### **この手順と教訓は次回以降のポスター作成でも確実に再利用**
以下に、`poster.pdf` を **A0→A1横×2分割**して `posterA1.pdf` を生成するための **Makefile** 


## 🛠️ Makefile（保存名: `Makefile`）

```makefile
# Makefile for splitting A0 poster.pdf into 2 A1 horizontal pages using mutool

INPUT     = poster.pdf
OUTPUT    = posterA1.pdf
TMPDIR    = tmp_pages

.PHONY: all clean info

all: $(OUTPUT)

$(OUTPUT): $(INPUT)
	@echo "🔧 Splitting A0 → A1 x 2 (horizontal)..."
	mkdir -p $(TMPDIR)
	mutool poster -y 2 $(INPUT) $(TMPDIR)/page.pdf
	@echo "🧹 Merging 2 pages into $(OUTPUT)..."
	# If available, use pdfunite or ghostscript to merge
	if command -v pdfunite >/dev/null; then \
		pdfunite $(TMPDIR)/page-1.pdf $(TMPDIR)/page-2.pdf $@; \
	elif command -v gs >/dev/null; then \
		gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$@ $(TMPDIR)/page-*.pdf; \
	else \
		echo "⚠️ Error: neither pdfunite nor ghostscript (gs) is available to merge PDFs."; \
		exit 1; \
	fi
	@echo "✅ Done: $(OUTPUT) created."

info:
	@echo "📄 Page info for $(OUTPUT):"
	pdfinfo $(OUTPUT) || echo "(install poppler to use pdfinfo)"

clean:
	rm -rf $(TMPDIR) $(OUTPUT)
	@echo "🧼 Cleaned temporary files and output."
```

---

## 📦 必要なツール（どれかあればOK）

| 用途   | ツール                | 備考                           |
| ---- | ------------------ | ---------------------------- |
| 分割   | `mutool`           | `sudo pacman -S mupdf-tools` |
| 結合   | `pdfunite`         | `sudo pacman -S poppler`     |
| 代替結合 | `gs` (Ghostscript) | `sudo pacman -S ghostscript` |
| 情報確認 | `pdfinfo`          | （同上 poppler に含まれる）           |

---

## ✅ 使い方

ターミナルで対象フォルダに移動して：

```bash
make
```

→ `posterA1.pdf` が生成されます（横A1が2ページに分割されたもの）

その他：

```bash
make info   # PDFのページサイズ・数を確認
make clean  # 中間ファイル・出力PDFを削除
```

---

## 📁 出力構造

```text
.
├── poster.pdf         # 元のA0ポスター
├── posterA1.pdf       # 出力されたA1×2ページPDF
└── tmp_pages/         # 中間PDFページ（自動で消せます）
    ├── page-1.pdf
    └── page-2.pdf
```

---

もし別の入力ファイル名（例：`abstract2025.pdf`）で使いたい場合は、`INPUT = abstract2025.pdf` に書き換えてください。



