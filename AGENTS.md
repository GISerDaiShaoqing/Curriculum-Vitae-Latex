# AGENTS.md — 戴劭勍简历仓库维护指南

本仓库用三套技术栈维护同一份简历。你的核心任务是:**任何内容更新都必须同步落盘到所有载体**,并按本文件约定的格式、顺序、风格执行。用户丢来一个论文/汇报/奖项/项目/IF 等信息时,按第 4 节流程自动更新,不需要逐步确认。

## 1. 仓库概览

| 目录 | 产出 | 主文件 | 构建方式 |
|---|---|---|---|
| `enlatex/` | 英文 LaTeX 简历 | `cv.tex` → `cv.pdf` | `latexmk -xelatex cv`(可用 `make`) |
| `cnlatex/` | 中文 LaTeX 简历 | `template-zh.tex` → `template-zh.pdf` | `latexmk -xelatex template-zh`(**Makefile 仍指向 cv,已过时,勿用 make**) |
| `pagedown/` | 英文网页版 | `cv.Rmd` → `cv.html/cv.pdf` | `Rscript render_cv.R`(PDF 走 Chrome,需本机 Chrome) |
| `pagedown/` | 中文网页版 | `template-zh.Rmd` → `template-zh.html/pdf` | 同上,但内容是**手工维护**的 markdown,不读 CSV |

- `pagedown/data/entries.csv` 是英文网页版的数据源,`pagedown/data/text_blocks.csv` 是网页简介,`cv.Rmd` 通过 `print_section('<section>')` 渲染。
- `cv.Rmd` 中 `academic_confpaper` 和 `academic_paperrs` 两个节的 `print_section` **被注释掉**,这两类 CSV 数据行目前不渲染(数据仍要维护,便于以后开启)。
- 生成物(`*.pdf` `*.html` `*.aux` `*.log` `*.bbl` `*.fls` `*.fdb_latexmk` `*.synctex.gz` `*.xdv` `*.run.xml` `*.bcf` `*.out` 等)不要手改;`pagedown/.Rhistory` 是 R 会话噪音,忽略。
- 备用/未引用文件:`enlatex/`、`cnlatex/` 下的 `*_selected.tex`、`talk.tex`、`poster.tex`、`abstracts.tex`、`experience.tex`、`language.tex`、`skills.tex`、`referees.tex` 不被 `\input`,默认**不同步**;只有用户点名时才更新。`enlatex/referees.tex` 内容已过时,留着不动。

## 2. 同步矩阵(最重要——每次改动照此落盘)

同一内容在 **4 组文件**中各有一份,漏一处就版本漂移:

| 内容 | 英文 LaTeX | 中文 LaTeX | 英文网页 | 中文网页 |
|---|---|---|---|---|
| 期刊论文 | `enlatex/publications.tex` | `cnlatex/publications.tex` | `entries.csv` 行 `academic_articles` | `template-zh.Rmd` 出版物节 |
| 会议论文/摘要 | `enlatex/presentation.tex` 或 `talk.tex` | 同左 | `entries.csv` 行 `academic_confpaper`(不渲染) | `template-zh.Rmd` |
| 学术报告 | `enlatex/presentation.tex` | `cnlatex/presentation.tex` | `entries.csv` 行 `academic_pres` | `template-zh.Rmd` 学术报告节 |
| 海报 | `enlatex/poster.tex` | `cnlatex/poster.tex` | `entries.csv` 行 `academic_posters` | `template-zh.Rmd` |
| 科研项目 | `enlatex/researches.tex` | `cnlatex/researches.tex` | `entries.csv` 行 `academic_projects` | `template-zh.Rmd` 科研项目节 |
| 奖励荣誉 | `enlatex/awards.tex` | `cnlatex/awards.tex` | `entries.csv` 行 `awards_honors` | `template-zh.Rmd` |
| 专利/软著/书章/成果 | `publications.tex` 对应小节 | 同 | `academic_patent`/`academic_softcopy`/`academic_books`/`academic_technology`/`academic_code` | `template-zh.Rmd` |
| 编辑/审稿/会员 | `enlatex/activities.tex` | `cnlatex/activities.tex` | `entries.csv` 行 `academic_service` | `template-zh.Rmd` |
| 授课 | `enlatex/teaching.tex` | `cnlatex/teaching.tex` | `entries.csv` 行 `teaching_experience` | `template-zh.Rmd` |
| 期刊 IF 更新 | `publications.tex` 的 `[SCI, IF=x.x]` | 同 | `entries.csv` 第 9 列 | `template-zh.Rmd`(该文条目里的 `[SCI, IF = x.x]`) |
| 联系方式(电话/邮箱/地址) | `cv.tex` `\extrainfo` | `template-zh.tex` | `data/contact_info.csv` | `template-zh.Rmd` 头部 |
| 个人简介 | — | — | `data/text_blocks.csv` `intro` | `template-zh.Rmd` 开头 |

`entries.csv` 各节列结构(逗号分隔,注意多行引号字段):`section,title,loc,institution,start,end,description_1,description_2,description_3,in_resume`。新增行**照抄同节相邻行的列布局**;`in_resume` 填 `TRUE` 才进精简版 `resume.rmd`,拿不准就与相邻条目一致。

## 3. 条目格式规范

### enlatex(宏定义见 `cv.tex`)
- 首部主控:`\Shaoqing`(本人姓名加粗)、`\CS`(通讯作者上标 `*`)、`\CF`(共同第一作者上标 `#`)、`\DOI{10.xxxx/xxxx}`(自动生成 doi 链接)。
- 期刊论文条目:
  ```latex
  \item
      作者1, 作者2, \Shaoqing\CS, Peng Jia (2025).
      论文标题.
      \textbf{\textit{期刊名}} \textit{卷}(期): 页码.
      \DOI{10.xxxx/xxxxx}. \textbf{[SSCI, IF=5.4]}.
  ```
- 小节归属(在 `publications.tex` 的三个 enumerate 里):本人第一作者或通讯作者 → `First/corresponding author` 段;`#` 共同一作等重要合作 → `Key author` 段;普通合作 → `other author` 段。每个 `\begin{enumerate}` 内**新条目插在最上方**(倒序)。
- 学术报告:`\mycvitemXP{YYYY.MM.DD}{标题}{会议名}{地点}`,按日期**倒序**插在最上;受邀标题加 `(\textbf{invited})`。
- 科研项目:`\mycvitemac{2022-2025}{"项目名", 经费来源(编号)}{PI 或 Investigator}`;主持=PI,参与=Investigator。
- 奖项:`\mycvitemPP{YYYY.MM}{内容}`(日期倒序)。
- 授课:`\mycvitemac{YYYY}{"课程名", 单位}{N class hours}`(1 学时写 `1 class hour`)。
- 教育/工作/编辑等宏:`\mycvitemEDU`(8 参)、`\mycvitemCOM`(5)、`\mycvitemac`/`\mycvitemacl`(3)、`\mycvitemcomment`(3),沿用现有用法即可。

### cnlatex
宏与英文版同名;**中文文本用 `\songti{}`(正文)/`\songtix{}`(仿斜体)包裹**,英文书名期刊保持原样不加。章节标题为中文(学术报告/科研项目/奖励 & 荣誉等)。引用条目(作者、期刊)仍是英文,与英文版同文。受邀写 `(\textbf{受邀})`。

### template-zh.Rmd(中文网页,手工维护)
- 出版物条目:`### 英文标题` / 空行 / `期刊名. 卷(期), 页码. doi:xx. [SCI, IF = x.x].` / `N/A` / `年份` / 作者行(`**Shaoqing Dai**` 加粗,通讯 `\*`,共同一 `#`)。新条目插到对应年份分组的**最上**,新年份组放在最前。
- 学术报告:日期行(`YYYY.MM` 或 `YYYY.MM.DD`) → `### 中文标题` → 会议名 → 地点(`中国, 城市`),整体倒序。
- 中文报告/项目标题需自行翻译(见第 5 节术语表),人名、英文期刊名保持英文。

## 4. 标准任务流程(用户丢标题来时)

1. **判断类型**:期刊论文 / 会议报告 / 海报 / 奖项 / 项目 / 软著 / 书章 / IF 更新。
2. **补全元数据**。用户常只给标题,先确认缺失字段:
   - 论文:作者顺序(谁是通讯/共同一作)、期刊、年卷期页、DOI、IF 及 SCI/SSCI/EI 分类;
   - 报告:日期(YYYY.MM.DD)、会议全称、地点、是否 invited、中文译名;
   - **IF、分类等以用户口径为准,不要自行猜测或联网编造**;用户给了 DOI 才可用其查证元数据;
   - **元数据自动查证链路(2026-09 验证可用)**:Crossref API(`api.crossref.org/works?query.bibliographic=…`,取 DOI/期刊/年卷期页/作者顺序)+ OpenAlex API(`api.openalex.org/works/doi:<DOI>`,`authorships[].is_corresponding` 可自动判定通讯作者,已实测正确);期刊 IF/分类查 ShowJCR 的 JCR2025 数据(见第 7 节)。通讯作者查到后按仓库惯例标注(LaTeX `\CS`、CSV/RMD `\*`),共同第一作者(`\CF`/`#`)各开放库均无该字段,仍需用户提供;
   信息不全时一次性问齐(不要挤牙膏)。
3. **按第 2 节矩阵落盘**所有文件;每个文件保持该文件的既有排序、格式、宏;各条目类型的四组"复制即用"模板见**第 10 节**。
4. **自检**(见第 6 节 lint)。
5. **构建验证**(见第 7 节),向用户报告:改了哪些文件、新条目位置、编译/渲染结果。
6. **git 习惯**:改动不主动 commit;若用户要求提交,沿用 `Update YYYYMMDD` 风格的信息。

## 5. 中英对照与译名约定(新增中文条目用)

固定译法(与现有条目保持一致):
- Health Geography 健康地理 | Spatial Lifecourse Health 空间全生命周期健康 | Street view imagery 街景图像 | GeoAI 地理人工智能 | Built environment 建成环境 | Spatial-Temporal Big Data 时空大数据 | Urban Visual Intelligence 城市视觉智能 | Spatial Statistics 空间统计
- PI 主持 | Investigator 参与 | invited 受邀 | Online 线上 | class hour(s) 课时 | Yangtze River Delta 长三角 | Spring Festival 春节 | Wuhan University 武汉大学 | School of Resource and Environmental Sciences, Wuhan University 武汉大学资源与环境科学学院 | Fujian Normal University 福建师范大学(**注意拼写是 Fujian,不是 Fuajian**)
- 报告标题中文译名风格参考既有条目(动宾式,如"基于街景图像与地理人工智能的健康城市感知";"以……为例")。
- 机构/期刊名、论文英文标题:中英文版保持**完全一致**,不要各自发挥。

## 6. 风格与拼写规则(2025-09 全库校对沉淀,新增内容必须遵守)

- `Prof. ` 后有空格:`Prof. Peng Jia`(不是 `Prof.Peng Jia`)。
- 英文语境下:括号前有空格(`Observation (ITC)`、`Plan (2023YFC3604704)`),冒号、逗号后有空格(`GIS: A Case Study`、`Ying Shao, Xing Zhao`)。
- `an R package`;`presented as a poster at`;`human-centered observation`;`Editorial Board Member`;`1 class hour`(复数 `2 class hours`)。
- 期刊名规范:Applied Economic**s** Letters、City and Environment Interactions、**ISPRS**(不是 IPSRS)、Urban & Building Science。
- 内部 key 固定写法:`academic_paperrs`(多一个 r,是历史 key,不要"改对",R 代码引用它)、`mets_severiity_calculator` 的 URL 拼写(应用已随论文发表,保持原样)。
- **保护规则**:
  - 人名不可改:`Tianjing He` 是合作者(只有 `Beijing-Tianjin-Hebei` 里的 Tianjin 才是地名);
  - DOI 字符串(`\DOI{...}`、`doi:` 后)不做任何加空格等"美化";
  - 已发表论著标题一律照抄,不按语法"纠错";机构新名统一用 International Institute of Spatial Lifecourse Health (ISLE)。
- 改完跑拼写 lint(全清零才算完):
  ```bash
  grep -rnE "Pbulic|Helath|Inovation|Scholoarship|Chanlleges|Stastistics|Eoclogy|Techonology|Mehtods|Soical|Postdoctral|Fuajian|neighbohood|Urabn|predition|wearble|saftety|monitation|Agreicultural|Disater|Researchg|Tianjing-Hebei|Assement|Servcie|IBSN|XiaomanZheng|emissions emissions|Prof\.[A-Za-z]|Schoolof| a R package|resented the poster|human-center |Editor Board|Peer-reviewer Journal|Applied Economic Letters|environment interactions|IPSRS|BuildingScience|Collegiate Developed|1 class hours|health commission|The Organizations|Instititue|Chinese Academic|GIS:A Case|Thesis:[A-Z]|GeographicEnvironment|GeoDa\(contributor\)" --include="*.tex" --include="*.csv" --include="*.Rmd" .
  ```

## 7. 期刊 IF 批量更新流程(数据源已验证可用)

用户认可的数据源(2026-09 起):GitHub 仓库 `hitfyd/ShowJCR`,数据在 `中科院分区表及JCR原始数据文件/` 目录。注意:`FQBJCR*.csv` 是中科院分区表(无 IF 列),**用 `JCR2025-UTF8.csv`**(JCR2025 版,2026-06-17 发布,`IF(2025)` 列)。旧备用源:`theabhijitdn/WoS-JCR-Impact-Factor-Explorer-2025`(JIF 2024)。

```bash
# 下载:本机 curl 走 api.github.com 可通(github.com 网页与 raw.githubusercontent 时通时断);
# contents API + Accept 头最稳,中文路径需 URL 编码
curl -sL --max-time 90 -H "Accept: application/vnd.github.raw" \
  -o /tmp/jcr.csv \
  "https://api.github.com/repos/hitfyd/ShowJCR/contents/%E4%B8%AD%E7%A7%91%E9%99%A2%E5%88%86%E5%8C%BA%E8%A1%A8%E5%8F%8AJCR%E5%8E%9F%E5%A7%8B%E6%95%B0%E6%8D%AE%E6%96%87%E4%BB%B6/JCR2025-UTF8.csv?ref=master"
```

步骤:
1. 用脚本从 `enlatex/publications.tex` 提取"期刊 → 现有标注"对(跟踪 `\textbf{\textit{期刊}}` 行,其下一行的 `\textbf{[SCI, IF=x.x]}` 即标签),得到带 IF 的约 29 本期刊清单。
2. 归一化匹配 JCR CSV(全大写、去 `THE`、`&`→`AND`、去标点;注意 CSV 字段带引号,用 `Text::ParseWords` 解析)。
3. 用 `IF(2025)` 列的新值回写 4 组文件,保持各文件**既有格式**:en/cn tex 是 `IF=x.x`(无空格),`entries.csv` 第 9 列两种写法都有,`template-zh.Rmd` 多为 `IF = x.x`(带空格)——只改数值与分类,不要顺手统一格式。
4. 分类按 `Web of Science` 列:仅 SCIE → `SCI`;仅 SSCI → `SSCI`;双收录 → `SCI/SSCI`(2025 版起 Frontiers in Public Health、The Lancet Global Health、The Lancet Regional Health–Western Pacific 为双收录)。
5. 已知坑:
   - *Journal of Urban Health* 在 JCR 里全名是 `JOURNAL OF URBAN HEALTH-BULLETIN OF THE NEW YORK ACADEMY OF MEDICINE`,按全名匹配;
   - *International Journal of Environmental Research and Public Health*(2023 除名,旧值 4.6)与 *Science of the Total Environment*(已除名,旧值 8.0):**用户已拍板(2026-09)——永久保留旧值,不再更新**;批量刷新 IF 时跳过这两本;
   - 中文期刊(Scientia Geographica Sinica、上海城市规划、Resources & Industries、环境科学学报、中国人口·资源与环境、Geomatics World)不在 JCR,标注为 C journal/CSSCI/CSCD/JST,不更新;
   - **tex 的 IF 标签在期刊行的下一行**(逐行跟踪期刊名);`entries.csv` 里 Nature Communications、IJAEOG、Chemical Science 三条是多行 CSV 记录,IF 在续行(按整条记录缓冲处理);`template-zh.Rmd` 的期刊名与 IF 在同一行。
6. 更新后跑第 6 节 lint,重编译验证。

2026-09 执行记录:全库 30 本期刊 IF 已从 JIF 2024 更新为 JIF 2025(共 32 本带 IF 标注的期刊,其中 Nature Communications 15.7→18.1、Lancet Global Health 18.0→22.5、Remote Sensing 4.1→4.3、Chemical Science 7.4→8.1 等),3 本升级 SCI→SCI/SSCI;IJERPH(4.6)与 STOTEN(8.0)经用户确认永久保留旧值;另有 6 本中文期刊(C journal/CSSCI/CSCD/JST 标注)不在 JCR,不涉及。

## 8. 构建与验证

```bash
cd enlatex && latexmk -xelatex cv        # 英文 PDFcd cnlatex && latexmk -xelatex template-zh  # 中文 PDF(Makefile 过时,勿 make)
cd pagedown && Rscript render_cv.R       # 英文+中文网页 HTML/PDF(需 Chrome)
```
- 编译后检查 `*.log` 无 `!` 错误;抽查 PDF 里新条目渲染正常(字体、上标 *、#、DOI 链接)。
- 渲染 pagedown 需要 Chrome(pagedown::chrome_print);R 包缺失时先装 `rmarkdown pagedown`。

## 9. 技术红线(踩过的坑)

1. **不要用 `sed -i`**:它会把 CRLF 行尾转成 LF,造成几十个文件的"幽灵修改"(内容没变但 git status 全标 M)。统一用 `perl -i -p -e '...'`(perl 保留行尾字节)。改完执行 `git diff --numstat`,若有 `0 0` 行的文件,`git checkout -- <file>` 恢复。
2. `pagedown/data/entries.csv` 是**混合行尾**且被 git 视为非文本:只能用 perl 逐行替换,禁止用编辑器批量重存或重排。
3. perl 正则里**避免直接写中文**(shell 传输可能字节不匹配导致静默失败):用行内 ASCII 锚点定位(条目日期、会议名、`\songtix{...}` 等),再配 `if (/锚点/) { s/.../.../ }`。
4. `entries.csv` 与 `text_blocks.csv` 中的引号必须成对:双引号 `“X”`、单引号 `‘X’`;CSV 结构性引号(字段包裹的 `"` )不要碰。
5. 同一标题在三处(EN tex / CN tex / CSV / Rmd)的措辞可能有细微历史差异——**以 enlatex 为基准**统一,发现不一致先报告用户再改。
6. 批量 `s///` 替换时,替换串里引用捕获组要先核对序号(曾把期刊分类误插成 `IFSCI=`,回写后必须立即抽查数值);缓冲式处理 CSV 时,处理结果要真正写回文件,不要打印到 STDOUT。
7. **写回脚本必须先校验后写盘,且只用一次 `print`**:曾因 `open(my $o,">",$file)` 先截断文件、随后 print 报错,导致 `enlatex/publications.tex` 被清空——所有修改前先备份目标文件到 /tmp,写盘前完成全部校验,写回后立即核对文件大小与关键内容,发现异常立刻 `git checkout` 恢复。
8. **LaTeX 条目里的 `&` 必须写成 `\&`**(会议名带 & 时极易忘,曾致 cv 编译 exit 12);且行内 perl 的 `\\` 会被 bash 吞掉一级、`-i -p` 多次重写会互相覆盖——凡含反斜杠/中文的修改一律用脚本文件(Write 生成)执行,插入或修改后必须立即重新编译验证。

## 10. 条目类型与样例模板(复制即用)

未来更新条目共 12 类。所有条目**新内容插到对应列表最上**(各节均为时间倒序);期刊论文先按作者位置选小节。`<…>` 为占位符;每类四组文件都要落盘(见第 2 节矩阵)。

### 10.1 期刊论文
小节归属(2026-09 修订):本人第一或通讯作者 → `First/corresponding author` 段(加 `\CS`);**其余一律进 `other author`/共同作者 段(含第二作者)**;`Key author`/关键作者 段仅保留既有历史条目(共同一作、导师一作),不再新增。
**段内排序**:新条目置顶;**同年内按 Crossref 的 `published-online` 日期倒序**(Elsevier 等不提交该字段的,用 `created` 日期近似,2026-09 用户拍板)。条目块结构固定 5 行:`\item` + 作者 + 标题 + 期刊卷期页 + DOI/IF。
**enlatex/cnlatex publications.tex**(对应小节 enumerate 最上;cnlatex 与英文同文):
```latex
\item
    A. Author, \Shaoqing\CS, Peng Jia\CS (2026).
    Title of the paper.
    \textbf{\textit{Journal Name}} \textit{12}(3): 45-56.
    \DOI{10.xxxx/xxxxx}. \textbf{[SCI, IF=x.x]}.
```
共同一作用 `\Shaoqing\CF`;`[SCI|SSCI|SCI/SSCI|ESCI|EI, IF=x.x]` 分类照 JCR 的 `Web of Science` 列。
**entries.csv**(academic_articles 节最上):
```
academic_articles,<Title>,<Journal>,,,<Year>,"A. Author, **Shaoqing Dai\***, B. Author","12(3): 45-56. doi:10.xxxx/xxxxx.","SCI, IF=x.x",TRUE
```
通讯 `\*`、共同一 `#`(放在作者名后);`in_resume` 与相邻条目一致。
**template-zh.Rmd**(出版物节最上;新年份组放最前):
```markdown
### <Title>

<Journal>. <vol>(<issue>), <pages>. doi:10.xxxx/xxxxx. [SCI, IF = x.x].

N/A

<Year>

A. Author, **Shaoqing Dai**, B. Author.
```

### 10.2 学术报告
**enlatex/presentation.tex**(最上):`\mycvitemXP{2026.03.15}{Talk title}{Conference full name}{City, China}`;受邀版 `{Talk title(\textbf{invited})}`。
**cnlatex/presentation.tex**:`\mycvitemXP{2026.03.15}{\songti{中文译名(\textbf{受邀})}}{\songtix{会议中文名}}{中国,城市}`。
**entries.csv**:`academic_pres,<Talk title>(invited),<Conference>,"City, China",,<2026>,,,,,`
**template-zh.Rmd**(学术报告节最上,结构:日期→标题→会议→地点):
```markdown
2026.03

### 中文译名

会议名

中国, 城市
```

### 10.3 海报
enlatex/poster.tex 与 cnlatex/poster.tex 同报告格式;entries.csv 节名 `academic_posters`(title 含 `(poster)`),template-zh.Rmd 照报告格式。

### 10.4 会议论文/摘要
entries.csv:`academic_confpaper,<Title>,"<Conference>, abstract <编号>",,,<Year>,"<authors>",,,TRUE`(注意:该节 cv.Rmd 中 print_section 被注释,网页不渲染)。正式 proceedings 论文按 10.1 格式进 publications.tex 对应小节,标签 `[EI]`。

### 10.5 科研项目
**enlatex/researches.tex**(最上):`\mycvitemac{2026-2028}{"项目名", 经费来源(批准号)}{PI}`;参与写 `{Investigator}`。
**cnlatex/researches.tex**:`\mycvitemac{2026-2028}{"项目名", 经费来源(批准号)}{主持}`;参与写 `{参与}`。
**entries.csv**:`academic_projects,<title>,<funder(No.)>,,<2026>,<2028>,**PI**,,,TRUE`
**template-zh.Rmd**:`2026-2028` / `### 中文项目名` / `经费来源(批准号), **主持**`。

### 10.6 奖励荣誉
**enlatex/awards.tex**(最上):`\mycvitemPP{2026.05}{Award name and organizer}`。
**cnlatex/awards.tex**:`\mycvitemPP{2026.05}{中文内容}`。
**entries.csv**:`awards_honors,<title>,,,,<2026>,"<颁发单位>",,,TRUE`
**template-zh.Rmd**:奖励节,格式同上。

### 10.7 书章(publications.tex Book Chapter 段;cnlatex 同文)
```latex
\item
    \Shaoqing, Huixian Jiang (2027).
    Chapter title.
    In \textbf{\textit{书名 (in Chinese)}} edited by 编辑名, 北京: 出版社.
    ISBN:978-7-xxx-xxxxx-x.
```
entries.csv:`academic_books,<chapter title>,"In <书名>(in Chinese) edited by ..., City: Publisher. ISBN:...",,,<2027>,"authors",,,`

### 10.8 专利(publications.tex Patent 段)
```latex
\item
     Yin Ren, \Shaoqing, Shudi Zuo.
     Patent title.
     \textit{CN123456789A}. (2026).
```
entries.csv:`academic_patent,<title>,CN123456789A,,,<2026>,"inventors",,,TRUE`

### 10.9 软件著作权(publications.tex Software Copyright 段)
```latex
\item
    软件名. V1.0.
    \textit{RN: 2026SRxxxxxxx}. (2026).
```
entries.csv:`academic_softcopy,<名称 V1.0>,,,,<2026>,RN: 2026SRxxxxxxx,,,TRUE`

### 10.10 开源软件/工具
**enlatex/software.tex**(最上):`\mycvitemcomment{from 2026}{工具名}{一句话描述. \myurl{https://...}}`。
**entries.csv**:`software,<工具名>,,,<2026>,,<描述 [url](https://...)>,,,TRUE`
**template-zh.Rmd**:`### 工具名` / 描述 / 链接。

### 10.11 学术职务/编辑/审稿/会员(activities.tex 对应小节;entries.csv academic_service)
- 期刊编委:`\mycvitemac{from 2026}{Journal Name}{Editorial Board Member}` / cnlatex `\songti{编委成员}`。
- 客座编辑:`\mycvitemac{from 2026}{<Journal> Special Issue, "题目"}{Guest Editor}`。
- 分会场召集:`\mycvitemac{2026}{会议名, "session 题目" session}{Convener}`。
- 审稿人:把期刊名追加到 activities.tex 末尾 `\mycvitemacl{from 2019}{...}{Reviewer}` 的长列表(逗号+空格分隔),同步 entries.csv 该长行与 template-zh.Rmd 审稿人列表。**列表按 7 个主题分组、主题标签加粗(LaTeX 用 `\textbf{}`/`\textbf{\songti{}}`,网页用 `**`),组内按 JCR IF 降序,无 IF 的(会议/中文刊/未收录新刊)放组尾**(2026-09 定);期刊名含 `&` 时 LaTeX 侧必须 `\&`。
- entries.csv:`academic_service,<类别>,<组织>,,<2026>,,<角色>,,,TRUE`

### 10.12 授课
**enlatex/teaching.tex**(最上):`\mycvitemac{2026}{"课程名", 单位}{2 class hours}`(1 学时写 `1 class hour`)。
**cnlatex/teaching.tex**:`\mycvitemac{2026}{“课程名”, 单位}{2课时}`。
**entries.csv**:`teaching_experience,<title>,"<单位>",,<2026>,,<2 class hours>,,`
**template-zh.Rmd**:`### 中文课程名` / 单位 / `N课时`。

## 11. 快捷指令:发布到 Hugo 个人主页

当用户说 **"请粘贴hugo个人主页"** 时,无需逐步确认,直接执行:
1. 检查四个产物是否存在且为最新(若仓库刚改过内容而未构建,先按第 8 节编译/渲染);
2. 复制到 `D:\hugopersonalwebsite\mycv\static\`,**覆盖原有文件**(目标文件夹不存在时先创建):
   - `enlatex/cv.pdf` → `D:\hugopersonalwebsite\mycv\static\cv.pdf`
   - `cnlatex/template-zh.pdf` → `D:\hugopersonalwebsite\mycv\static\template-zh.pdf`
   - `pagedown/cv.html` → `D:\hugopersonalwebsite\mycv\static\cv.html`
   - `pagedown/template-zh.html` → `D:\hugopersonalwebsite\mycv\static\template-zh.html`
3. 完成后报告四个文件的复制结果与时间戳。文件名保持源文件原名(带 `-zh` 后缀),与网站既有链接一致。
