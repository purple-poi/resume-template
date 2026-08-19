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
- `src/chicv.cls`：字体、页边距、通用页眉、Logo、章节、列表、技能表格和基础信息组件；
- `src/basic_info/basic_info.tex`：姓名、标题、头像配置和动态页眉字段；
- `src/assets/`：头像、小 Logo 和右上角大 Logo；
- `src/fonts/`：Font Awesome 图标字体和 Palatino 粗体字体。

Donk 只作为 `basic_info.example.tex` 和正文中的占位内容。以后使用模板时，使用者只需复制并编辑这个 TeX 配置文件和两个主文件，不需要创建人物专属的 adapter。

## 3. 修改简历内容

### 基础信息与页眉

姓名、职业标题、电话、头像开关、头像路径、两个 Logo 路径和页眉字段全部在 `src/basic_info/basic_info.tex` 中修改。中英文主文件已经调用：

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

英文版使用对应的 `EN` 变量。增加或删除页眉信息只需要修改 TeX 配置中的 `\ResumeExtraField`，不需要修改这段布局代码。

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

在 `basic_info.tex` 中使用 `true` 或 `false`：

```tex
\ResumeSetAvatar{false}{assets/avatar.png}
```

改为 `true` 即可显示头像。

### 替换图片

最简单的方式是保持文件名不变，直接替换：

- `src/assets/avatar.png`：头像；
- `src/assets/entry-logo.png`：经历标题前的小 Logo；
- `src/assets/header-logo.png`：右上角大 Logo。

如果更改文件名，只需同步修改 `basic_info.tex` 中的 `\ResumeSetAvatar`、`\ResumeSetEntryLogo` 或 `\ResumeSetHeaderLogo`。

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

西文字体在 `\setmainfont` 中设置，正文、粗体和斜体均使用 Overleaf 自带的 TeX Gyre Pagella；图标使用 `src/fonts/FontAwesome6.otf`。中文正文使用 Overleaf 自带的思源宋体 `Noto Serif CJK SC`，无衬线和等宽文字分别使用 `Noto Sans CJK SC` 与 `Noto Sans Mono CJK SC`；未安装 Noto CJK 的本地 TeX Live 环境自动回退到 Fandol。替换字体时需要同步修改 `src/chicv.cls` 中的字体名称。

如果内容超过一页，优先精简文字，其次小幅降低条目间距和行距。不要删除页边距、字体或图片依赖来强行压缩页面。

## 6. 使用基础信息 TeX 配置

`basic_info.example.tex` 保存可公开的 Donk 占位数据。开始填写自己的资料时，复制为：

```bash
cp src/basic_info/basic_info.example.tex src/basic_info/basic_info.tex
```

也可以直接在 Overleaf 的文件树中新建或复制这个 `.tex` 文件。它是配置片段，不是独立文档，不要在里面添加 `\documentclass`、`\begin{document}` 或 `\end{document}`。

### 固定信息

在配置文件中使用以下命令：

```tex
\ResumeSetName{你的中文姓名}{Your English Name}
\ResumeSetPhone{+86 138 0000 0000}
\ResumeSetSubtitle{职业标题}{PROFESSIONAL TITLE}
\ResumeSetAvatar{true}{assets/avatar.png}
\ResumeSetHeaderLogo{assets/header-logo.png}
\ResumeSetEntryLogo{assets/entry-logo.png}
```

不需要的电话可以写成 `\ResumeSetPhone{}`。头像开关使用 `true` 或 `false`。

### 动态页眉字段

每条字段使用一个 `\ResumeExtraField`，使用键值配置：

```tex
\ResumeExtraField{
  id = team,
  icon = F0B1,
  label-cn = 战队,
  label-en = Team,
  value-cn = Team Spirit,
  value-en = Team Spirit,
  url = https://teamspirit.gg,
  after = separator,
  show-in-header = true
}
```

可用键如下：

- `id`：字段标识，便于识别和未来扩展；
- `icon`：Font Awesome 四位十六进制编码；
- `label-cn`、`label-en`：中文和英文标签；
- `value-cn`、`value-en`：中文和英文显示值；
- `url`：可选链接，不填写时表示普通文本；
- `after`：字段后如何排版，可选 `separator`、`line` 或 `none`，省略时默认为 `none`；
- `show-in-header`：写 `true` 才显示在页眉，写 `false` 时只保留给详情表格使用，省略时默认为 `true`。

没有内容的键可以省略，例如没有链接时不需要写 `url =`。键和值之间的空格可有可无；值中如果包含逗号，建议用花括号包起来，例如 `value-cn = {北京，中华人民共和国}`。

例如，第一条字段使用 `separator`、第二条使用 `line`，就会得到“单位 | 职位”并换到下一行的效果。字段按配置文件中的顺序显示，不需要修改 `src/chicv.cls`。

主文件已经调用：

```tex
\LoadResumeBasicInfo
```

这个命令现在加载 `basic_info.tex`（找不到时自动加载 `basic_info.example.tex`），不再读取 JSON。新建其他主文件时，也在 `\documentclass` 后加入它。

如果还想在正文中以“标签 / 值”表格显示全部动态字段，可以使用：

```tex
\ResumeExtraFieldsCN[1.8cm]
\ResumeExtraFieldsEN[1.8cm]
```

`basic_info.tex` 中可以直接使用普通 LaTeX 内容；如果文字含有 `&`、`%`、`_`、`#` 等特殊字符，需要按 LaTeX 规则转义。真实的 `basic_info.tex` 已加入 `.gitignore`，公开仓库只保留示例配置。

## 7. 选择图标

打开 `ref/fontawesome-icons.pdf`，按英文名称搜索并复制四位十六进制编码。在 `basic_info.tex` 和 `\cvsection` 中都只填写编码本身，不添加 `0x` 或 `\u`：

```tex
\ResumeExtraField{
  id = location,
  icon = F3C5,
  label-cn = 所在地,
  label-en = Location,
  value-cn = 俄罗斯,
  value-en = Russia,
  after = none,
  show-in-header = true
}
```

```tex
\cvsection{F3C5}{所在地}
```

固定字段若需要图标，可以在布局中写 `\faIcon{F095}`；动态字段直接设置 `icon = F095`。

## 8. 必要上传文件

### Overleaf

同时编译中英文时，上传且只需上传：

```text
src/
  resume-cn.tex
  resume-en.tex
  chicv.cls
  basic_info/
    basic_info.tex
  assets/
    avatar.png
    entry-logo.png
    header-logo.png
  fonts/
    FontAwesome6.otf
```

只编译中文时可以省略 `resume-en.tex`；只编译英文时可以省略 `resume-cn.tex`。`build/` 不需要上传。

### GitHub 模板仓库

GitHub 中保留相同的模板源文件，但只提交示例 TeX 配置，不提交真实个人信息：

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
    basic_info.example.tex
  assets/
    avatar.png
    entry-logo.png
    header-logo.png
  fonts/
    FontAwesome6.otf
```

不要上传包含真实姓名、电话或其他隐私信息的 `basic_info.tex`。主文件找不到该文件时会自动读取 `basic_info.example.tex`，因此公开模板仍可直接编译。
