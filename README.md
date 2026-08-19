# Resume Template

An A4 resume template with Chinese and English versions, designed for XeLaTeX and Overleaf. The current resume content about donk is placeholder data. Basic information is kept in the editable TeX configuration `src/basic_info/basic_info.tex`, while the section content lives in `src/resume-cn.tex` and `src/resume-en.tex`.

The template supports optional avatars, dynamic header fields, header and entry logos, Font Awesome icons, and separate Chinese and English layouts. No JSON parser or JSON data file is required.

## Quick Start

Install a TeX Live distribution that includes `latexmk` and XeLaTeX, then run the following command from the repository root:

```bash
make
```

The generated PDFs are written to:

```text
build/resume-cn.pdf
build/resume-en.pdf
```

The root-level `Makefile` manages the `build/` directory. It contains generated files only and does not need to be uploaded to Overleaf.

## Minimum Overleaf File Set

To compile both language versions, preserve the following relative directory structure:

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

If you start from the public template, copy `src/basic_info/basic_info.example.tex` to `src/basic_info/basic_info.tex` and edit that file in Overleaf. If only one language is needed, the other `resume-*.tex` file may be omitted. Set `src/resume-cn.tex` or `src/resume-en.tex` as the main document, then select **XeLaTeX** under **Menu → Compiler** in Overleaf.

The checked-in example file contains placeholder data. Keep your edited `basic_info.tex` private; it is ignored by Git.

See [HANDBOOK.md](./HANDBOOK.md) for the configuration commands, field syntax, image paths, icons, and layout customization.

## Reference

- [roife/resume](https://github.com/roife/resume/tree/master) — the original resume project used as a design and structure reference.
