\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{chicv}[2026/08/19 Overleaf-ready CV class]

\newif\ifResumePrivate
\ResumePrivatefalse
\DeclareOption{public}{\ResumePrivatefalse}
\DeclareOption{private}{\ResumePrivatetrue}
\ProcessOptions\relax

\LoadClass[10pt,a4paper]{article}

\RequirePackage{iftex}
\ifXeTeX\else
  \ClassError{chicv}{This template requires XeLaTeX}
    {In Overleaf, open Menu -> Compiler and select XeLaTeX.}
\fi

\RequirePackage{fontspec}
\RequirePackage{xeCJK}
\RequirePackage[a4paper,left=0.6cm,right=0.6cm,top=1cm,bottom=1cm]{geometry}
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{hyperref}
\RequirePackage{lastpage}
\RequirePackage{ragged2e}
\RequirePackage{tabularx}
\RequirePackage[normalem]{ulem}
\RequirePackage{xcolor}
\RequirePackage{expl3}
\RequirePackage{xparse}
\RequirePackage[abspath]{currfile}

% The class works both when compiled from src/ and when src/resume-*.tex is
% selected as the root document from the repository root (as in Overleaf).
% Resolve from the main document's absolute directory so TeX's TEXINPUTS search
% and fontspec's Path option cannot disagree about what a relative path means.
\edef\ResumeMainPath{\currfileabsdir}
\newcommand{\ResumeProjectPath}{}
\newcommand{\ResumeAssetPath}{}
\IfFileExists{\ResumeMainPath fonts/FontAwesome6.otf}{%
  \edef\ResumeProjectPath{\ResumeMainPath}%
  \edef\ResumeAssetPath{\ResumeMainPath fonts/}%
}{%
  \IfFileExists{\ResumeMainPath src/fonts/FontAwesome6.otf}{%
    \edef\ResumeProjectPath{\ResumeMainPath src/}%
    \edef\ResumeAssetPath{\ResumeMainPath src/fonts/}%
  }{%
    \ClassError{chicv}{FontAwesome6.otf was not found}
      {Keep the fonts directory beside chicv.cls.}%
  }%
}

% TeX Gyre Pagella ships with TeX Live and Overleaf, so the template does not
% depend on a separately uploaded Latin text font.
\setmainfont{texgyrepagella-regular.otf}[
  BoldFont=texgyrepagella-bold.otf,
  ItalicFont=texgyrepagella-italic.otf,
  BoldItalicFont=texgyrepagella-bolditalic.otf,
  Ligatures=TeX
]

% Overleaf includes the Noto CJK (Source Han) families. Keep Fandol as a
% fallback for smaller local TeX Live installations which omit the Noto fonts.
\IfFontExistsTF{Noto Serif CJK SC}{
  \setCJKmainfont{Noto Serif CJK SC}
  \setCJKsansfont{Noto Sans CJK SC}
  \setCJKmonofont{Noto Sans Mono CJK SC}
}{
    \setCJKmainfont{FandolSong-Regular.otf}[
      BoldFont=FandolSong-Bold.otf,
      ItalicFont=FandolKai-Regular.otf
    ]
    \setCJKsansfont{FandolHei-Regular.otf}[
      BoldFont=FandolHei-Bold.otf
    ]
    \setCJKmonofont{FandolFang-Regular.otf}
}

\newfontface\ResumeFA{FontAwesome6.otf}[Path=\ResumeAssetPath]

\hypersetup{
  colorlinks=true,
  allcolors=black,
  pdfcreator={XeLaTeX with the chicv class},
  pdfencoding=auto
}
\urlstyle{same}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[C]{\thepage\ / \pageref*{LastPage}}
\setlength{\footskip}{0.55cm}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\tabcolsep}{0pt}
\setlength{\emergencystretch}{1.2em}
\justifying

\newlength{\ResumeBaselineSkip}
\setlength{\ResumeBaselineSkip}{15.5pt}
\newcommand{\SetResumeLeading}[1]{\setlength{\ResumeBaselineSkip}{#1}}
\newlength{\ResumeEntryExtraSkip}
\setlength{\ResumeEntryExtraSkip}{0pt}
\newcommand{\SetResumeEntryExtraSkip}[1]{\setlength{\ResumeEntryExtraSkip}{#1}}
\newlength{\ResumeSectionRuleThickness}
\setlength{\ResumeSectionRuleThickness}{0.7pt}
\newcommand{\SetResumeSectionRuleThickness}[1]{\setlength{\ResumeSectionRuleThickness}{#1}}
\AtBeginDocument{%
  \fontsize{10pt}{\ResumeBaselineSkip}\selectfont
  \setlength{\parindent}{0pt}%
}

\definecolor{resumegray}{RGB}{70,70,70}
\definecolor{resumerule}{RGB}{160,160,160}

\newcommand{\faIcon}[1]{{\normalfont\ResumeFA\char"#1\relax}}
\newcommand{\faPhone}{\faIcon{F095}}
\newcommand{\faEnvelope}{\faIcon{F0E0}}
\newcommand{\faGithub}{\faIcon{F09B}}
\newcommand{\faGlobe}{\faIcon{F0AC}}
\newcommand{\faGraduationCap}{\faIcon{F19D}}
\newcommand{\faBriefcase}{\faIcon{F0B1}}
\newcommand{\faProjectDiagram}{\faIcon{F542}}
\newcommand{\faRust}{\faIcon{E07A}}
\newcommand{\faCodeBranch}{\faIcon{F126}}
\newcommand{\faLaptopCode}{\faIcon{F5FC}}
\newcommand{\faList}{\faIcon{F00B}}

\NewDocumentCommand{\ResumeLink}{m m}{\href{#1}{\uline{#2}}}

\NewDocumentCommand{\Repo}{s m}{%
  \IfBooleanF{#1}{\faGithub\,}%
  \ResumeLink{https://github.com/#2}{%
    \begingroup
    \def\do##1/##2\@nil{{\color{resumegray}##1}/\textbf{##2}}%
    \expandafter\do#2\@nil
    \endgroup
  }%
}

\NewDocumentCommand{\ResumeIdentity}{m m}{%
  \ifResumePrivate #2\else #1\fi
}

\NewDocumentCommand{\ResumeSecret}{O{} m}{%
  \ifResumePrivate
    #2%
  \else
    \begingroup
    \def\ResumeSecretWidth{#1}%
    \ifx\ResumeSecretWidth\@empty
      \setbox0=\hbox{#2}%
      \rule[-0.12ex]{\wd0}{1.08ex}%
    \else
      \rule[-0.12ex]{#1}{1.08ex}%
    \fi
    \endgroup
  \fi
}

\NewDocumentCommand{\ResumeHeader}{m m}{%
  \noindent{\fontsize{28pt}{30pt}\selectfont #1\par}%
  \vspace{0.45em}%
  \noindent{\fontsize{10pt}{12pt}\selectfont #2\par}%
  \vspace{0.15em}%
}

\NewDocumentCommand{\cvsection}{m m}{%
  \par\vspace{0.18em}\vspace{-\ResumeEntryExtraSkip}%
  \noindent{\color{resumerule}\rule{\linewidth}{\ResumeSectionRuleThickness}}\par
  \nobreak\vspace{0.08em}%
  \noindent{\fontsize{11pt}{13pt}\selectfont\bfseries \faIcon{#1}\enspace #2\par}%
  \nobreak\vspace{0.12em}%
}

\NewDocumentCommand{\cventry}{m m m m +m}{%
  \par\noindent
  \begin{tabular*}{\linewidth}{@{}l@{\extracolsep{\fill}}r@{}}
    {\fontsize{11.6pt}{13pt}\selectfont\bfseries #1} & #2
  \end{tabular*}\par
  \ifboolexpr{ not test {\ifstrempty{#3}} or not test {\ifstrempty{#4}} }{%
    \noindent
    \begin{tabular*}{\linewidth}{@{}l@{\extracolsep{\fill}}r@{}}
      #3 & #4
    \end{tabular*}\par
  }{}%
  #5\par\vspace{0.18em}\vspace{\ResumeEntryExtraSkip}%
}

\newlist{cvitems}{itemize}{2}
\setlist[cvitems,1]{
  label={\raisebox{0.10ex}{\fontsize{7pt}{7pt}\selectfont\textbullet}},
  leftmargin=1.10em,
  labelsep=0.48em,
  itemindent=0pt,
  topsep=0pt,
  partopsep=0pt,
  parsep=0pt,
  itemsep=0pt
}
\setlist[cvitems,2]{
  label={\raisebox{0.12ex}{\fontsize{6pt}{6pt}\selectfont\faIcon{F0DA}}},
  leftmargin=0.90em,
  labelsep=0.42em,
  itemindent=0pt,
  topsep=0pt,
  partopsep=0pt,
  parsep=0pt,
  itemsep=0pt
}

\NewDocumentEnvironment{skills}{+b}{%
  \noindent\begin{tabularx}{\linewidth}{@{}>{\bfseries\raggedleft\arraybackslash}p{2.12cm}@{\hspace{0.55em}}>{\arraybackslash}X@{}}
    #1
  \end{tabularx}
  \vspace{-1.35em}% Match Typst's grid-to-following-section spacing.
}{}

\NewDocumentCommand{\skillrow}{O{0pt} m +m}{%
  \raisebox{-#1}[0pt][0pt]{#2} & #3\\[0.45em]
}

\NewDocumentCommand{\contactsep}{}{\enspace|\enspace}

% Generic, content-agnostic profile header. The root résumé supplies all text
% and image paths, while a small TeX configuration file supplies basic info.
\providecommand{\ResumeShowAvatar}{true}
\newif\ifResumeAvatarVisible
\ResumeAvatarVisibletrue
\AtBeginDocument{%
  \ifdefstring{\ResumeShowAvatar}{false}
    {\ResumeAvatarVisiblefalse}
    {\ResumeAvatarVisibletrue}%
}

\newlength{\ResumeHeaderInfoWidth}
\newlength{\ResumeAvatarWidth}
\newlength{\ResumeBrandWidth}
\newlength{\ResumeHeaderSpacingWithAvatar}
\newlength{\ResumeHeaderSpacingWithoutAvatar}
\newlength{\ResumeBrandTopShift}
\setlength{\ResumeAvatarWidth}{3.15cm}
\setlength{\ResumeBrandWidth}{4.80cm}
\setlength{\ResumeHeaderSpacingWithAvatar}{1.40cm}
\setlength{\ResumeHeaderSpacingWithoutAvatar}{0.85cm}
\setlength{\ResumeBrandTopShift}{-0.16cm}

\NewDocumentCommand{\SetResumeAvatarWidth}{m}{%
  \setlength{\ResumeAvatarWidth}{#1}%
}

\NewDocumentCommand{\SetResumeBrandWidth}{m}{%
  \setlength{\ResumeBrandWidth}{#1}%
}

\NewDocumentCommand{\SetResumeBrandTopShift}{m}{%
  \setlength{\ResumeBrandTopShift}{#1}%
}

\NewDocumentCommand{\ResumeHeaderItem}{m m}{%
  \faIcon{#1}\enspace #2%
}

\NewDocumentCommand{\ResumeHeaderLine}{+m}{%
  #1\par\vspace{0.13em}%
}

% #1 display name, #2 subtitle, #3 avatar path, #4 brand-logo path,
% #5 arbitrary metadata rows built with \ResumeHeaderLine/\ResumeHeaderItem.
\NewDocumentCommand{\ResumeProfileHeader}{m m m m +m}{%
  \noindent
  \ifResumeAvatarVisible
    \setlength{\ResumeHeaderInfoWidth}{%
      \dimexpr\linewidth-\ResumeAvatarWidth-\ResumeBrandWidth-\ResumeHeaderSpacingWithAvatar\relax
    }%
    \begin{minipage}[t]{\ResumeAvatarWidth}
      \vspace{0pt}%
      \includegraphics[width=\ResumeAvatarWidth]{\ResumeProjectPath#3}%
    \end{minipage}%
    \hfill
  \else
    \setlength{\ResumeHeaderInfoWidth}{%
      \dimexpr\linewidth-\ResumeBrandWidth-\ResumeHeaderSpacingWithoutAvatar\relax
    }%
  \fi
  \begin{minipage}[t]{\ResumeHeaderInfoWidth}
    \vspace{0pt}%
    {\fontsize{23.5pt}{25.5pt}\selectfont\bfseries #1\par}%
    \vspace{0.32em}%
    {\fontsize{10.5pt}{12.5pt}\selectfont\bfseries\color{resumegray}#2\par}%
    \vspace{0.48em}%
    {\fontsize{9.7pt}{12.2pt}\selectfont #5}%
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{\ResumeBrandWidth}
    \vspace{\ResumeBrandTopShift}%
    \raggedleft
    \includegraphics[width=\ResumeBrandWidth]{\ResumeProjectPath#4}\par
  \end{minipage}%
  \par\vspace{0.22em}%
}

\NewDocumentCommand{\ResumeEntryLogo}{O{1.18em} m}{%
  \raisebox{-0.15em}{%
    \includegraphics[height=#1]{\ResumeProjectPath#2}%
  }%
}

\NewDocumentCommand{\ResumeEntryWithLogo}{O{1.18em} m m}{%
  \ResumeEntryLogo[#1]{#2}\hspace{0.38em}#3%
}

% --------------------------------------------------------------------------
% Basic information configuration
% --------------------------------------------------------------------------
% The values below are populated by src/basic_info/basic_info.tex.  They
% are initialized here so the class remains well-defined while the config is
% being loaded and so a missing optional value degrades gracefully.
\providecommand{\ResumeNameCN}{}
\providecommand{\ResumeNameEN}{}
\providecommand{\ResumePhone}{}
\providecommand{\ResumeSubtitleCN}{}
\providecommand{\ResumeSubtitleEN}{}
\providecommand{\ResumeAvatarFile}{}
\providecommand{\ResumeHeaderLogoFile}{}
\providecommand{\ResumeEntryLogoFile}{}

\NewDocumentCommand{\ResumeSetName}{m m}{%
  \renewcommand{\ResumeNameCN}{#1}%
  \renewcommand{\ResumeNameEN}{#2}%
}

\NewDocumentCommand{\ResumeSetPhone}{m}{%
  \renewcommand{\ResumePhone}{#1}%
}

\NewDocumentCommand{\ResumeSetSubtitle}{m m}{%
  \renewcommand{\ResumeSubtitleCN}{#1}%
  \renewcommand{\ResumeSubtitleEN}{#2}%
}

\NewDocumentCommand{\ResumeSetAvatar}{m m}{%
  \renewcommand{\ResumeShowAvatar}{#1}%
  \renewcommand{\ResumeAvatarFile}{#2}%
}

\NewDocumentCommand{\ResumeSetHeaderLogo}{m}{%
  \renewcommand{\ResumeHeaderLogoFile}{#1}%
}

\NewDocumentCommand{\ResumeSetEntryLogo}{m}{%
  \renewcommand{\ResumeEntryLogoFile}{#1}%
}

% Each field is stored as a small TeX command rather than as JSON.  The
% public interface uses named keys so the configuration remains readable:
% id, icon, label-cn, label-en, value-cn, value-en, url, after, and
% show-in-header.  The id is kept for identification and future extensions;
% the remaining keys control the rendered field.
\ExplSyntaxOn
\seq_new:N \g_resume_extra_fields_seq

\tl_new:N \l_resume_field_id_tl
\tl_new:N \l_resume_field_icon_tl
\tl_new:N \l_resume_field_label_cn_tl
\tl_new:N \l_resume_field_label_en_tl
\tl_new:N \l_resume_field_value_cn_tl
\tl_new:N \l_resume_field_value_en_tl
\tl_new:N \l_resume_field_url_tl
\tl_new:N \l_resume_field_after_tl
\tl_new:N \l_resume_field_show_in_header_tl

\keys_define:nn { resume / extra-field }
  {
    id .tl_set:N = \l_resume_field_id_tl,
    icon .tl_set:N = \l_resume_field_icon_tl,
    label-cn .tl_set:N = \l_resume_field_label_cn_tl,
    label-en .tl_set:N = \l_resume_field_label_en_tl,
    value-cn .tl_set:N = \l_resume_field_value_cn_tl,
    value-en .tl_set:N = \l_resume_field_value_en_tl,
    url .tl_set:N = \l_resume_field_url_tl,
    after .choice:,
    after / separator .code:n =
      { \tl_set:Nn \l_resume_field_after_tl {separator} },
    after / line .code:n =
      { \tl_set:Nn \l_resume_field_after_tl {line} },
    after / none .code:n =
      { \tl_set:Nn \l_resume_field_after_tl {none} },
    show-in-header .choice:,
    show-in-header / true .code:n =
      { \tl_set:Nn \l_resume_field_show_in_header_tl {true} },
    show-in-header / false .code:n =
      { \tl_set:Nn \l_resume_field_show_in_header_tl {false} },
    show-in-header .default:n = true
  }

\cs_new_protected:Npn \resume_current_field_handler:nnnnnnnnn
  #1#2#3#4#5#6#7#8#9
  { }

\cs_new_protected:Npn \resume_extra_field:nnnnnnnnn
  #1#2#3#4#5#6#7#8#9
  {
    \resume_current_field_handler:nnnnnnnnn
      {#1}{#2}{#3}{#4}{#5}{#6}{#7}{#8}{#9}
  }

\cs_new_protected:Npn \resume_add_extra_field:n #1
  {
    \group_begin:
    \tl_clear:N \l_resume_field_id_tl
    \tl_clear:N \l_resume_field_icon_tl
    \tl_clear:N \l_resume_field_label_cn_tl
    \tl_clear:N \l_resume_field_label_en_tl
    \tl_clear:N \l_resume_field_value_cn_tl
    \tl_clear:N \l_resume_field_value_en_tl
    \tl_clear:N \l_resume_field_url_tl
    \tl_set:Nn \l_resume_field_after_tl {none}
    \tl_set:Nn \l_resume_field_show_in_header_tl {true}
    \keys_set:nn { resume / extra-field } {#1}
    \seq_gput_right:Ne \g_resume_extra_fields_seq
      {
        \exp_not:N \resume_extra_field:nnnnnnnnn
          {\exp_not:V \l_resume_field_id_tl}
          {\exp_not:V \l_resume_field_icon_tl}
          {\exp_not:V \l_resume_field_label_cn_tl}
          {\exp_not:V \l_resume_field_label_en_tl}
          {\exp_not:V \l_resume_field_value_cn_tl}
          {\exp_not:V \l_resume_field_value_en_tl}
          {\exp_not:V \l_resume_field_url_tl}
          {\exp_not:V \l_resume_field_after_tl}
          {\exp_not:V \l_resume_field_show_in_header_tl}
      }
    \group_end:
  }

\NewDocumentCommand{\ResumeExtraField}{m}
  {\resume_add_extra_field:n {#1}}

\cs_new_protected:Npn \resume_map_extra_fields:N #1
  {
    \cs_set_eq:NN \resume_current_field_handler:nnnnnnnnn #1
    \seq_map_inline:Nn \g_resume_extra_fields_seq { ##1 }
  }

\cs_new_protected:Npn \resume_header_value:nn #1#2
  {
    \tl_if_blank:nTF {#1}
      {#2}
      {\ResumeLink{#1}{#2}}
  }

\cs_new_protected:Npn \resume_header_after:n #1
  {
    \str_case:nnF {#1}
      {
        {separator}{\contactsep}
        {line}{\par\vspace{0.13em}}
        {none}{}
      }
      {}
  }

\cs_new_protected:Npn \resume_header_field_cn:nnnnnnnnn
  #1#2#3#4#5#6#7#8#9
  {
    \str_if_eq:nnT {#9}{true}
      {
        \ResumeHeaderItem{#2}{\resume_header_value:nn {#7}{#5}}
        \resume_header_after:n {#8}
      }
  }

\cs_new_protected:Npn \resume_header_field_en:nnnnnnnnn
  #1#2#3#4#5#6#7#8#9
  {
    \str_if_eq:nnT {#9}{true}
      {
        \ResumeHeaderItem{#2}{\resume_header_value:nn {#7}{#6}}
        \resume_header_after:n {#8}
      }
  }

\tl_new:N \l_resume_extra_rows_tl

% Build table rows before opening tabular.  Alignment tabs and row breaks
% generated while a sequence is being mapped can otherwise terminate the map
% after the first row on some TeX engines.
\cs_new_protected:Npn \resume_collect_extra_row_cn:nnnnnnnnn
  #1#2#3#4#5#6#7#8#9
  {
    \tl_put_right:Nn \l_resume_extra_rows_tl
      {\faIcon{#2}\enspace #3 & #5\\[0.32em]}
  }

\cs_new_protected:Npn \resume_collect_extra_row_en:nnnnnnnnn
  #1#2#3#4#5#6#7#8#9
  {
    \tl_put_right:Nn \l_resume_extra_rows_tl
      {\faIcon{#2}\enspace #4 & #6\\[0.32em]}
  }

\NewDocumentCommand{\ResumeHeaderFieldsCN}{}{%
  \group_begin:
  \resume_map_extra_fields:N \resume_header_field_cn:nnnnnnnnn
  \ResumeHeaderPhoneField
  \group_end:
}

\NewDocumentCommand{\ResumeHeaderFieldsEN}{}{%
  \group_begin:
  \resume_map_extra_fields:N \resume_header_field_en:nnnnnnnnn
  \ResumeHeaderPhoneField
  \group_end:
}

\NewDocumentCommand{\ResumeExtraFieldsCN}{O{2.12cm}}{%
  \group_begin:
  \tl_clear:N \l_resume_extra_rows_tl
  \resume_map_extra_fields:N \resume_collect_extra_row_cn:nnnnnnnnn
  \noindent
  \begin{tabular}{@{}>{\bfseries\raggedleft\arraybackslash}p{#1}@{\hspace{0.55em}}>{\arraybackslash}p{\dimexpr\linewidth-#1-0.55em\relax}@{}}%
    \tl_use:N \l_resume_extra_rows_tl
  \end{tabular}%
  \group_end:
}

\NewDocumentCommand{\ResumeExtraFieldsEN}{O{2.12cm}}{%
  \group_begin:
  \tl_clear:N \l_resume_extra_rows_tl
  \resume_map_extra_fields:N \resume_collect_extra_row_en:nnnnnnnnn
  \noindent
  \begin{tabular}{@{}>{\bfseries\raggedleft\arraybackslash}p{#1}@{\hspace{0.55em}}>{\arraybackslash}p{\dimexpr\linewidth-#1-0.55em\relax}@{}}%
    \tl_use:N \l_resume_extra_rows_tl
  \end{tabular}%
  \group_end:
}

\ExplSyntaxOff

\newcommand{\ResumeHeaderPhoneField}{%
  \ifdefempty{\ResumePhone}{}{%
    \par\vspace{0.13em}%
    \ResumeHeaderItem{F095}{\ResumePhone}%
  }%
}

\NewDocumentCommand{\LoadResumeBasicInfo}{}{%
  \IfFileExists{basic_info/basic_info.tex}{%
    \input{basic_info/basic_info.tex}%
  }{%
    \IfFileExists{src/basic_info/basic_info.tex}{%
      \input{src/basic_info/basic_info.tex}%
    }{%
      \IfFileExists{basic_info/basic_info.example.tex}{%
        \input{basic_info/basic_info.example.tex}%
      }{%
        \IfFileExists{src/basic_info/basic_info.example.tex}{%
          \input{src/basic_info/basic_info.example.tex}%
        }{%
          \ClassError{chicv}{basic_info.tex was not found}
            {Create src/basic_info/basic_info.tex from the example file.}%
        }%
      }%
    }%
  }%
}

\AtEndDocument{\label{resume:lastpage}}
