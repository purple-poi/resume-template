# Resume template

这是一个面向 XeLaTeX 和 Overleaf 的 A4 单页中英文简历模板。当前 Donk 履历是
占位示例：基础信息统一保存在 `basic_info/basic_info.json`，章节正文分别位于
`resume-cn.tex` 和 `resume-en.tex`，不存在人物专属的 TeX adapter。

模板支持头像开关、动态页眉字段、页眉大 Logo、经历项小 Logo、Font Awesome
图标以及中英文双版本。

## 快速开始

本地需要安装包含 `latexmk` 和 XeLaTeX 的 TeX Live。在本目录运行：

```bash
make
```

生成文件为：

```text
build/resume-cn.pdf
build/resume-en.pdf
```

`build/` 本项目在 `Makefile` 中通过`latexmk -outdir=build` 设置的。它只保存编译产物，不需要上传到 Overleaf。

## Overleaf 最小上传清单

同时保留中英文版本时，只需保持下面的相对目录结构：

```text
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

如果只编译一种语言，可以不上传另一个 `resume-*.tex`。上传后将主文档设为
`resume-cn.tex` 或 `resume-en.tex`，并在 Overleaf 的 **Menu → Compiler** 中
选择 **XeLaTeX**。

公开 GitHub 仓库只保留 `basic_info.example.json`，不要提交包含真实个人信息的
`basic_info.json`。具体字段、内容修改、头像与 Logo、图标和版式说明见
[HANDBOOK.md](./HANDBOOK.md)。
