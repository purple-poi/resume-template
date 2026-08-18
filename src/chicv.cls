\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{chicv}[2026/08/18 Overleaf-ready CV class]

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
\RequirePackage{jsonparse}
\RequirePackage{ragged2e}
\RequirePackage{tabularx}
\RequirePackage[normalem]{ulem}
\RequirePackage{xcolor}
\RequirePackage{xparse}

% The class works both when compiled from src/ and when src/resume-*.tex is
% selected as the root document from the repository root (as in Overleaf).
\newcommand{\ResumeProjectPath}{}
\newcommand{\ResumeAssetPath}{}
\IfFileExists{fonts/FontAwesome6.otf}{%
  \renewcommand{\ResumeAssetPath}{fonts/}%
}{%
  \IfFileExists{src/fonts/FontAwesome6.otf}{%
    \renewcommand{\ResumeProjectPath}{src/}%
    \renewcommand{\ResumeAssetPath}{src/fonts/}%
  }{%
    \ClassError{chicv}{FontAwesome6.otf was not found}
      {Keep the fonts directory beside chicv.cls.}%
  }%
}

% The repository contains the original Palatino Linotype Bold face. TeX Gyre
% Pagella is the metrically close, Overleaf-shipped Palatino face used for the
% other styles.
\setmainfont{texgyrepagella-regular.otf}[
  BoldFont={\ResumeAssetPath Palatino Linotype.ttf},
  ItalicFont=texgyrepagella-italic.otf,
  BoldItalicFont=texgyrepagella-bolditalic.otf,
  Ligatures=TeX
]

% Prefer the Songti face used by the Typst source. If a licensed SimSun.ttf is
% placed in fonts/, it takes priority. FandolSong ships with Overleaf.
\IfFileExists{\ResumeAssetPath SimSun.ttf}{
  \setCJKmainfont{SimSun.ttf}[Path=\ResumeAssetPath,AutoFakeBold=2.2]
}{
  \IfFontExistsTF{Songti SC}{
    \setCJKmainfont{Songti SC}
  }{
    \setCJKmainfont{FandolSong-Regular.otf}[
      BoldFont=FandolSong-Bold.otf,
      ItalicFont=FandolKai-Regular.otf
    ]
  }
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
% and image paths, so example data never requires a person-specific adapter.
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

\newcommand{\LoadResumeBasicInfo}{%
  \IfFileExists{basic_info/basic_info.json}{%
    \JSONParseFromFile{\ResumeBasicInfoJSON}{basic_info/basic_info.json}%
  }{%
    \IfFileExists{src/basic_info/basic_info.json}{%
      \JSONParseFromFile{\ResumeBasicInfoJSON}{src/basic_info/basic_info.json}%
    }{%
      \IfFileExists{basic_info/basic_info.example.json}{%
        \JSONParseFromFile{\ResumeBasicInfoJSON}{basic_info/basic_info.example.json}%
      }{%
        \JSONParseFromFile{\ResumeBasicInfoJSON}{src/basic_info/basic_info.example.json}%
      }%
    }%
  }%
  \JSONParseValue[rescan,store in=\ResumeNameCN]{\ResumeBasicInfoJSON}{name_cn}%
  \JSONParseValue[rescan,store in=\ResumeNameEN]{\ResumeBasicInfoJSON}{name_en}%
  \JSONParseValue[rescan,store in=\ResumePhone]{\ResumeBasicInfoJSON}{phone}%
  \JSONParseValue[rescan,store in=\ResumeSubtitleCN]{\ResumeBasicInfoJSON}{subtitle_cn}%
  \JSONParseValue[rescan,store in=\ResumeSubtitleEN]{\ResumeBasicInfoJSON}{subtitle_en}%
  \JSONParseValue[rescan,store in=\ResumeShowAvatar]{\ResumeBasicInfoJSON}{show_avatar}%
  \JSONParseValue[rescan,store in=\ResumeAvatarFile]{\ResumeBasicInfoJSON}{avatar}%
  \JSONParseValue[rescan,store in=\ResumeHeaderLogoFile]{\ResumeBasicInfoJSON}{header_logo}%
  \JSONParseValue[rescan,store in=\ResumeEntryLogoFile]{\ResumeBasicInfoJSON}{entry_logo}%
}

\newcommand{\ResumeHeaderFieldRow}{%
  \ifdefstring{\JSONParseArrayValueV}{true}{%
    \ResumeHeaderItem{\JSONParseArrayValueI}{%
      \ifdefempty{\JSONParseArrayValueIII}
        {\JSONParseArrayValueII}
        {\ResumeLink{\JSONParseArrayValueIII}{\JSONParseArrayValueII}}%
    }%
    \ifdefstring{\JSONParseArrayValueIV}{separator}{%
      \contactsep
    }{%
      \ifdefstring{\JSONParseArrayValueIV}{line}{%
        \par\vspace{0.13em}%
      }{}%
    }%
  }{}%
}

\newcommand{\ResumeHeaderPhoneField}{%
  \ifdefempty{\ResumePhone}{}{%
    \par\vspace{0.13em}%
    \ResumeHeaderItem{F095}{\ResumePhone}%
  }%
}

\NewDocumentCommand{\ResumeHeaderFieldsCN}{}{%
  \JSONParseArrayMapFunction[rescan]
    {\ResumeBasicInfoJSON}{extra_fields}
    [icon,value_cn,url,after,show_in_header]
    {\ResumeHeaderFieldRow}%
  \ResumeHeaderPhoneField
}

\NewDocumentCommand{\ResumeHeaderFieldsEN}{}{%
  \JSONParseArrayMapFunction[rescan]
    {\ResumeBasicInfoJSON}{extra_fields}
    [icon,value_en,url,after,show_in_header]
    {\ResumeHeaderFieldRow}%
  \ResumeHeaderPhoneField
}

\newcommand{\ResumeExtraFieldRow}{%
  \faIcon{\JSONParseArrayValueI}\enspace
  \JSONParseArrayValueII & \JSONParseArrayValueIII\\[0.32em]%
}

\NewDocumentCommand{\ResumeExtraFieldsCN}{O{2.12cm}}{%
  \JSONParseArrayMapFunction[
    rescan,
    code before={%
      \noindent
      \begin{tabular}{@{}>{\bfseries\raggedleft\arraybackslash}p{#1}@{\hspace{0.55em}}>{\arraybackslash}p{\dimexpr\linewidth-#1-0.55em\relax}@{}}%
    },
    code after={\end{tabular}}%
  ]{\ResumeBasicInfoJSON}{extra_fields}[icon,label_cn,value_cn]
    {\ResumeExtraFieldRow}%
}

\NewDocumentCommand{\ResumeExtraFieldsEN}{O{2.12cm}}{%
  \JSONParseArrayMapFunction[
    rescan,
    code before={%
      \noindent
      \begin{tabular}{@{}>{\bfseries\raggedleft\arraybackslash}p{#1}@{\hspace{0.55em}}>{\arraybackslash}p{\dimexpr\linewidth-#1-0.55em\relax}@{}}%
    },
    code after={\end{tabular}}%
  ]{\ResumeBasicInfoJSON}{extra_fields}[icon,label_en,value_en]
    {\ResumeExtraFieldRow}%
}

\AtEndDocument{\label{resume:lastpage}}
