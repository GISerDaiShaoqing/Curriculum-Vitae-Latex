# Shaoqing Dai's Curriculum Vitae

This repository maintains my academic CV in **three synchronized outputs** built from the same content:

| Output | Source | Build |
|---|---|---|
| 🇬🇧 English CV (PDF) | [`enlatex/`](enlatex/) — moderncv, `cv.tex` | XeLaTeX via `latexmk` |
| 🇨🇳 Chinese CV (PDF) | [`cnlatex/`](cnlatex/) — moderncv + xeCJK, `template-zh.tex` | XeLaTeX via `latexmk` |
| 🌐 Web CV (HTML/PDF) | [`pagedown/`](pagedown/) — data-driven R Markdown | `render_cv.R` (pagedown + Chrome) |

## Live Preview

- English CV (PDF): [enlatex/cv.pdf](enlatex/cv.pdf)
- Chinese CV (PDF): [cnlatex/template-zh.pdf](cnlatex/template-zh.pdf)
- English web version: <http://gisersqdai.top/mycv/cv.html>
- Chinese web version: <http://gisersqdai.top/mycv/template-zh.html>

## Repository Structure

```
.
├── enlatex/               # English LaTeX CV
│   ├── cv.tex             #   main file (moderncv), inputs the section files below
│   └── *.tex              #   employment / education / publications / awards /
│                          #   researches / presentation / activities / teaching / software
├── cnlatex/               # Chinese LaTeX CV (same section layout, template-zh.tex)
├── pagedown/              # web versions (R Markdown + pagedown)
│   ├── cv.Rmd             #   English web CV — renders from the CSV data below
│   ├── template-zh.Rmd    #   Chinese web CV — hand-maintained markdown
│   ├── render_cv.R        #   build script (HTML + Chrome-printed PDF)
│   ├── CV_printing_functions.R / generatedatadrivencv.R
│   └── data/
│       ├── entries.csv    #   master data: publications, presentations, projects,
│       │                  #   awards, editorial roles, teaching, software, …
│       ├── text_blocks.csv#   intro paragraph
│       └── contact_info.csv
└── AGENTS.md              # maintenance guide (see below)
```

## Content

The CV covers: peer-reviewed journal articles (with SCI/SSCI tags and annual impact factors), book chapters, patents and software copyrights, research projects, conference presentations and posters, academic services (editorial boards, guest editorships, reviewer for 50+ journals and conferences grouped by field), teaching, awards and honors, and open-source software.

## Build

### LaTeX versions (English & Chinese)

Requirements: TeX Live (or equivalent) with **XeLaTeX**, `latexmk`, and the packages used by [moderncv](http://www.ctan.org/pkg/moderncv) (`biblatex`/`biber`, `academicons`, `fontawesome`; the Chinese version additionally needs `xeCJK` with SimSun/KaiTi/SimHei).

```bash
cd enlatex && latexmk -xelatex cv            # → enlatex/cv.pdf
cd cnlatex && latexmk -xelatex template-zh   # → cnlatex/template-zh.pdf
```

> Note: the bundled `Makefile` in `cnlatex/` still targets the old `cv` job — use the `latexmk` command above for the Chinese version.

### Web versions

Requirements: R with `rmarkdown` and `pagedown`; Google Chrome/Chromium is needed only for the PDF printing step.

```bash
cd pagedown && Rscript render_cv.R
```

The English web CV is rebuilt from `pagedown/data/entries.csv`; edit the CSV to add or update entries, then re-render. The Chinese web CV (`template-zh.Rmd`) is hand-maintained markdown.

## Deployment

The four site artifacts (`cv.pdf`, `template-zh.pdf`, `cv.html`, `template-zh.html`) are synced to the `static/` folder of my Hugo personal website (`D:\hugopersonalwebsite\mycv\static`) after each update; the website links stay unchanged.

## Maintenance

Any content change (new paper, presentation, project, journal impact factor, …) must be applied to **all** outputs to avoid version drift. [AGENTS.md](AGENTS.md) is the full maintenance guide and covers:

- the **sync matrix** (which files carry which content),
- copy-paste **entry templates** for 12 entry types,
- the **journal impact factor** batch-update workflow (verified JCR data source),
- style, translation and spell-check rules,
- build/verify checklists and known pitfalls.

## Template Credits

- LaTeX: [moderncv](http://www.ctan.org/pkg/moderncv), adapted from [leouieda/cv](https://github.com/leouieda/cv), [seisman/cv](https://github.com/seisman/cv) and [MaxUlysse/myCV](https://github.com/MaxUlysse/myCV)
- Web CV: based on the [datadrivencv](https://github.com/nstrayer/datadrivencv) approach (R Markdown + pagedown)
- References: [notes on moderncv](https://www.xiangsun.org/tex/notes-on-moderncv), [FontAwesome CN](http://www.fontawesome.com.cn/faicons/)

LaTeX engine: **XeLaTeX**.
