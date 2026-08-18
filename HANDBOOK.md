# ChicV 模板使用手册

## 1. 编译模板

### 本地编译

进入仓库根目录后运行：

```bash
make          # 同时编译中文和英文
make cn       # 只编译中文
make en       # 只编译英文
make clean    # 清理编译产物
```

模板必须使用 XeLaTeX。`make` 实际执行的核心命令是：

```bash
latexmk -xelatex -cd -outdir=../build src/resume-cn.tex
```

其中 `-xelatex` 选择 XeLaTeX，`-cd` 进入 `src/` 编译，`-outdir=../build` 将 PDF、日志和辅助文件写入仓库根目录的 `build/`。

### 为什么输出到 `build/`

这不是 LaTeX 默认行为，而是当前 `Makefile` 的设置。在 `src/` 中运行 `xelatex resume-cn.tex` 时，LaTeX 默认把 PDF 和辅助文件放在当前目录。

如果想改成其他目录，把 `Makefile` 中所有 `-outdir=../build` 改成例如 `-outdir=../output`；如果删除该参数，文件就会生成在 `src/` 中。Overleaf 不依赖本地 `Makefile`，会自行管理编译产物，因此不要上传 `build/`。

### Overleaf 编译

1. 创建空白项目并按“第 8 节”的清单上传文件；
2. 将主文档设为 `src/resume-cn.tex` 或 `src/resume-en.tex`；
3. 将编译器设为 XeLaTeX；
4. 点击 Recompile。

## 2. 文件职责

- `src/resume-cn.tex`：中文章节、经历和技能正文；
- `src/resume-en.tex`：英文章节、经历和技能正文；
- `src/chicv.cls`：字体、页边距、通用页眉、Logo、章节、列表、技能表格和私有字段组件；
- `src/basic_info/basic_info.json`：姓名、标题、头像配置和动态页眉字段；
- `src/assets/`：头像、小 Logo 和右上角大 Logo；
- `src/fonts/`：Font Awesome 图标字体和 Palatino 粗体字体。

Donk 只作为 `basic_info.json` 和正文中的占位内容。以后使用模板时，使用者也修改同一个 JSON 和两个主文件，不需要创建人物专属的 TeX adapter。

## 3. 修改简历内容

### 基础信息与页眉

姓名、职业标题、电话、头像开关、头像路径、两个 Logo 路径和页眉字段全部在 `src/basic_info/basic_info.json` 中修改。中英文主文件已经调用：

```tex
\LoadResumeBasicInfo
```

并使用通用变量生成页眉：

```tex
\ResumeProfileHeader
  {\ResumeNameCN}
  {\ResumeSubtitleCN}
  {\ResumeAvatarFile}
  {\ResumeHeaderLogoFile}
  {\ResumeHeaderFieldsCN}
```

英文版使用对应的 `EN` 变量。增加或删除页眉信息只需要修改 JSON 的 `extra_fields`，不需要修改这段 LaTeX。

### 章节与经历

中英文正文分别位于 `src/resume-cn.tex` 和 `src/resume-en.tex`。章节格式为：

```tex
\cvsection{F0B1}{工作经历}
```

第一个参数是 Font Awesome 十六进制编码，第二个参数是标题。经历格式为：

```tex
\cventry{单位或项目}{时间}{职位或说明}{地点或角色}{正文}
```

带项目符号的正文使用：

```tex
\begin{cvitems}
  \item 第一项内容；
  \item 第二项内容。
\end{cvitems}
```

专业技能使用：

```tex
\begin{skills}
  \skillrow{场上定位}{右侧说明；}
  \skillrow{个人能力}{右侧说明。}
\end{skills}
```

## 4. 修改头像和 Logo

### 开关头像

在 `basic_info.json` 中使用 JSON 布尔值：

```json
"show_avatar": true
```

改为 `false` 即可隐藏头像，不要加引号。

### 替换图片

最简单的方式是保持文件名不变，直接替换：

- `src/assets/avatar.png`：头像；
- `src/assets/entry-logo.png`：经历标题前的小 Logo；
- `src/assets/header-logo.png`：右上角大 Logo。

如果更改文件名，只需同步修改 `basic_info.json` 中的 `avatar`、`entry_logo` 或 `header_logo`。

### 调整图片尺寸和位置

小 Logo 默认高度为 `1.18em`；经历标题中使用：

```tex
\ResumeEntryWithLogo{\ResumeEntryLogoFile}{单位名称}
```

头像和右上角 Logo 的宽度可以在主文件中统一设置：

```tex
\SetResumeAvatarWidth{3.15cm}
\SetResumeBrandWidth{4.80cm}
\SetResumeBrandTopShift{-0.16cm}
```

宽度越小，图片越小；`\SetResumeBrandTopShift` 的负值绝对值越大，右上角 Logo 越靠上。信息栏宽度会根据头像和 Logo 宽度自动重新计算。

## 5. 修改版式

主文件顶部提供两个常用参数：

```tex
\SetResumeLeading{13.7pt}
\SetResumeEntryExtraSkip{1.2pt}
```

- `\SetResumeLeading` 控制正文行距；
- `\SetResumeEntryExtraSkip` 控制经历之间的额外间距；
- `\SetResumeSectionRuleThickness{0.9pt}` 可以调整章节分隔线粗细。

章节标题字号在 `src/chicv.cls` 的 `\cvsection` 中设置：

```tex
\fontsize{11pt}{13pt}\selectfont
```

专业技能左栏宽度位于 `skills` 环境中的 `p{2.12cm}`。数值减小会缩窄左栏，数值增大会加宽左栏。

页面边距由 `src/chicv.cls` 中的 `geometry` 设置：

```tex
\RequirePackage[a4paper,left=0.6cm,right=0.6cm,top=1cm,bottom=1cm]{geometry}
```

西文字体在 `\setmainfont` 中设置，当前正文使用 TeX Gyre Pagella，粗体使用 `src/fonts/Palatino Linotype.ttf`；图标使用 `src/fonts/FontAwesome6.otf`。中文字体按 `src/fonts/SimSun.ttf`、系统 `Songti SC`、Overleaf 自带 `FandolSong` 的顺序回退。替换字体时需要同步修改 `src/chicv.cls` 中的字体文件名或字体名称。

如果内容超过一页，优先精简文字，其次小幅降低条目间距和行距。不要删除页边距、字体或图片依赖来强行压缩页面。

## 6. 使用基础信息 JSON

`basic_info.example.json` 保存可公开的 Donk 占位数据。开始填写自己的资料时，复制为：

```bash
cp src/basic_info/basic_info.example.json src/basic_info/basic_info.json
```

固定字段如下：

- `name_cn`、`name_en`：中英文姓名；
- `phone`：电话，非空时自动追加到页眉；
- `subtitle_cn`、`subtitle_en`：姓名下方的职业标题；
- `show_avatar`：头像开关，只能填写 JSON 布尔值 `true` 或 `false`；
- `avatar`：头像路径；
- `header_logo`：右上角 Logo 路径；
- `entry_logo`：经历标题前的小 Logo 路径；
- `extra_fields`：任意数量的动态字段。

完整结构示例：

```json
{
  "name_cn": "你的姓名",
  "name_en": "Your Name",
  "phone": "",
  "subtitle_cn": "职业标题",
  "subtitle_en": "PROFESSIONAL TITLE",
  "show_avatar": true,
  "avatar": "assets/avatar.png",
  "header_logo": "assets/header-logo.png",
  "entry_logo": "assets/entry-logo.png",
  "extra_fields": [
    {
      "id": "political_affiliation",
      "icon": "F024",
      "label_cn": "政治面貌",
      "label_en": "Political Affiliation",
      "value_cn": "",
      "value_en": "",
      "url": "",
      "after": "line",
      "show_in_header": false
    }
  ]
}
```

每个动态字段的控制项为：

- `id`：便于识别的唯一名称，不参与排版；
- `icon`：Font Awesome 四位十六进制编码；
- `label_cn`、`label_en`：字段作为详情表格显示时使用的标签；
- `value_cn`、`value_en`：中英文页眉中显示的值；
- `url`：可选链接，空字符串表示普通文本；
- `show_in_header`：是否显示在页眉；
- `after`：字段后如何排版，可选 `separator`、`line` 或 `none`。

例如，第一行放“单位 | 职位”时，单位设置为 `separator`，职位设置为 `line`。最后一个可见字段通常使用 `none`。数组可以继续追加所在地、邮箱、网站、语言、证书或政治面貌等字段，不需要修改 `src/chicv.cls`。

主文件已经加载 JSON。新建其他主文件时，需要在 `\documentclass` 后加入：

```tex
\LoadResumeBasicInfo
```

如果还想在正文中以“标签 / 值”表格显示全部动态字段，可以使用：

```tex
\ResumeExtraFieldsCN[1.8cm]
\ResumeExtraFieldsEN[1.8cm]
```

当前中英文主文件使用 `private` 模式并直接显示 JSON 数据。真实的 `basic_info.json` 已被 `.gitignore` 忽略，不要手动提交到公开仓库；公开模板使用 `basic_info.example.json` 作为回退数据。

## 7. 选择图标

打开 `ref/fontawesome-icons.pdf`，按英文名称搜索并复制四位十六进制编码。JSON 和 `\cvsection` 中都只填写编码本身，不添加 `0x` 或 `\u`：

```json
"icon": "F3C5"
```

```tex
\cvsection{F3C5}{所在地}
```

固定字段若需要图标，可以在布局中写 `\faIcon{F095}`；动态字段直接设置 JSON 对象的 `icon` 值。

## 8. 必要上传文件

### Overleaf

同时编译中英文时，上传且只需上传：

```text
src/
  resume-cn.tex
  resume-en.tex
  chicv.cls
  basic_info/
    basic_info.json
  assets/
    avatar.png
    entry-logo.png
    header-logo.png
  fonts/
    FontAwesome6.otf
    Palatino Linotype.ttf
```

只编译中文时可以省略 `resume-en.tex`；只编译英文时可以省略 `resume-cn.tex`。`build/` 不需要上传。

### GitHub 模板仓库

GitHub 中保留相同的模板源文件，但用示例 JSON 代替真实 JSON，并保留构建与文档文件：

```text
.gitignore
README.md
HANDBOOK.md
Makefile
ref/
  fontawesome-icons.pdf
src/
  resume-cn.tex
  resume-en.tex
  chicv.cls
  basic_info/
    basic_info.example.json
  assets/
    avatar.png
    entry-logo.png
    header-logo.png
  fonts/
    FontAwesome6.otf
    Palatino Linotype.ttf
```

不要上传包含真实姓名、电话或其他隐私信息的 `basic_info.json`。主文件找不到该文件时会自动读取 `basic_info.example.json`，因此公开模板仍可直接编译。
