%% drcschool.cls --- DRC's LaTeX school class
%%
%% Copyright (C) 2022--2023 Davide Campagnari
%%
%% This work may be distributed and/or modified under the conditions
%% of the LaTeX Project Public License, either version 1.3c of this
%% license or (at your option) any later version. The latest version
%% of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2008 or later.
%%
%% This work has the LPPL maintenance status "author-maintained".
%%
%% The Current Maintainer of this work is Davide Campagnari
%% email: <davide.campa (at) gmail.com>
%%        <d.campagnari (at) uni-tuebingen.de>
%%
%% This work consists of the file drcschool.cls only.
%%
\NeedsTeXFormat{LaTeX2e}[2018-04-01]
\ProvidesClass{drcschool}[2023-11-13 v1.2.2]

\PassOptionsToClass{fontsize=11pt,twoside}{scrartcl}

\newcommand*{\drcschool@fontsetup}{\@firstofone}
\newcommand*{\NoFonts}{\def\drcschool@fontsetup{\@gobble}}
\DeclareOption{nofonts}{\NoFonts}

\newcommand*{\drcschool@hyperworksheet}{\endinput}
\newcommand*{\Hyperworksheet}{\let\drcschool@hyperworksheet\relax}
\DeclareOption{hyperworksheet}{\Hyperworksheet}

\newif\if@drctikz \@drctikztrue
\DeclareOption{notikz}{\@drctikzfalse\def\drcschool@pgfplots{\@gobble}}

\newcommand*{\drcschool@pgfplots}{\@firstofone}
\DeclareOption{nopgfplots}{\def\drcschool@pgfplots{\@gobble}}

\DeclareOption*{\expandafter\PassOptionsToClass\expandafter{\CurrentOption}{scrartcl}}
\ProcessOptions\relax

\LoadClass{scrartcl}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% FONT SETUP
\def\drcschool@standardfonts{%
   \RequirePackage[scale=.92]{tgheros}%
   \renewcommand*{\familydefault}{\sfdefault}%
   \renewcommand*{\rmdefault}{\sfdefault}%
   \RequirePackage[noSTIXops]{newtxsf}%
   \renewcommand*{\ttdefault}{ntxtt}%
   \RequirePackage[T1]{fontenc}%
   \RequirePackage{microtype}%
   \def\@sqrt[##1]{\root\uproot{2}\leftroot{1}##1\of}% font correction for roots
}
% This must be here because the packages which I load later might
% use the same hook
\AtBeginDocument{\drcschool@fontsetup\drcschool@standardfonts}
% However, this font setup isn't meaningful for XeTeX/LuaTeX, so I check that
\ifdefined\Umathchardef\NoFonts\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% LANGUAGE AND PAGE SETUP
\columnsep24\p@
\RequirePackage[a4paper,margin=1in]{geometry}
\RequirePackage[main=ngerman]{babel}
\RequirePackage{scrlayer-scrpage}
   \setkomafont{pageheadfoot}{\normalfont}
   \pagestyle{scrheadings}
   \ofoot[]{\drc@page}
   \newcommand*{\drc@page}{\thepage}
\raggedbottom % twoside uses \flushbottom by default but I don't want/need it here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% REQUIRED PACKAGES
\RequirePackage{pict2e}
\RequirePackage{amsgen}
\RequirePackage{environ}
\RequirePackage{paralist}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage[table]{xcolor}
\RequirePackage{longtable}
\RequirePackage{icomma}
\if@drctikz\@xp\@firstofone\else\@xp\@gobble\fi{\RequirePackage{tikz}}
\drcschool@pgfplots{\RequirePackage{pgfplots}}
\IfFileExists{drcmath.sty}{\RequirePackage[arrowvec,noamssymb]{drcmath}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% \drc@heading{skip before}{skip after}{heading} is a simplified copy of
% \@startsection; if <skip after> is negative, then no new line after heading
\newcommand*\drc@heading[3]{% #1=skip before; #2=skip after; #3=heading
   \if@noskipsec\leavevmode\fi
   \par
   \@afterindentfalse
   \if@nobreak
      \everypar{}%
   \else
      \addpenalty\@secpenalty\addvspace{#1}%
   \fi
   \@tempskipa#2\relax
   \ifdim\@tempskipa>\z@
      \noindent
      \begingroup\normalsize\normalfont\bfseries\interlinepenalty\@M#3\@@par\endgroup
      \par\nobreak
      \vskip\@tempskipa
      \@afterheading
   \else
      \@nobreakfalse
      \global\@noskipsectrue
      \everypar{%
         \if@noskipsec
            \global\@noskipsecfalse
            {\setbox\z@\lastbox}%
            \clubpenalty\@M
            \begingroup\normalsize\normalfont\bfseries#3\endgroup
            \unskip
            \hskip-\@tempskipa
         \else
            \clubpenalty \@clubpenalty
            \everypar{}%
         \fi
      }% end of \everypar
   \fi
   \ignorespaces
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% PROGRAMMING UTILITIES
% \usage: \drc@ifkv{arg}{code if arg is a key/value list}{code otherwise}
\newcommand*{\drc@ifkv}[1]{\drc@if@kv#1=\@nil}
\newcommand*{\drc@if@kv}{}
\def\drc@if@kv#1=#2\@nil{\if\relax\detokenize{#2}\relax\@xp\@secondoftwo\else\@xp\@firstoftwo\fi}
% usage: \drc@kv@num@else{arg}{code for key/val}{code for number}{code otherwise}
\newcommand*{\drc@kv@num@else}[4]{\drc@if@kv#1=\@nil{#2}{\Ifnumber{#1}{#3}{#4}}}
% to cope with older KOMA versions
\providecommand*{\Ifnumber}{\ifnumber}
\providecommand*{\Ifdimen}{\ifdimen}
\providecommand*{\Ifstr}{\ifstr}
% helper macros/scratch lengths
\ifdefined\drc@dima\else
   \newdimen\drc@dima
   \newdimen\drc@dimb
   \newdimen\drc@gdima
   \newdimen\drc@gdimb
   \newdimen\drc@gdimc
   \newbox\drc@box
\fi
% similar to kernel \strip@pt but replaces period by comma
\def\drc@strip@pt{\@xp\drc@rem@pt\the}
\begingroup
\catcode`P=12
\catcode`T=12
\lowercase{\def\x{\def\drc@rem@pt##1.##2PT{##1\ifnum##2>\z@,##2\fi}}}
\@xp\endgroup\x
% replaces period by comma in decimals
\def\drc@decimal#1{\@xp\drc@decimal@\romannumeral-`0#1\relax\relax}
\def\drc@decimal@#1.#2\relax{#1,#2}
% copies of etoolbox
\def\drc@expandonce#1{\unexpanded\expandafter{#1}}
\def\drc@csexpandonce#1{\expandafter\drc@expandonce\csname#1\endcsname}
% shortcuts
\newcommand*{\@namegdef}[1]{\expandafter\gdef\csname#1\endcsname}
%\newcommand*{\@namexdef}[1]{\expandafter\xdef\csname#1\endcsname} % --> already in xcolor.sty !!
\newcommand{\g@addto@name}[1]{\expandafter\g@addto@macro\csname#1\endcsname}
\newcommand*{\If@val@in@list}[2]{%
   \in@{,#1,}{,#2,}%
   \ifin@\expandafter\@firstoftwo\else\expandafter\@secondoftwo\fi
}
% usage: \drc@key@to@bool{<key>}{<bool>}{<simple switch>}
\newcommand*{\drc@key@to@bool}[3]{%
   \If@val@in@list{#3}{true,yes,on,show}{\csname#2true\endcsname}{%
      \If@val@in@list{#3}{false,no,off,hide}{\csname#2false\endcsname}{%
         \ClassError{drcschool}{Unknown value `#3' for boolean key `#1'.\MessageBreak I assume you wanted `#1=true'}%
                               {A boolean key admits true/yes/on/show and false/no/off/hide.}%
         \csname#2true\endcsname
      }%
   }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% LECTURE INFOS
\newcommand*{\lesson@title}{{\normalfont\ttfamily\string\lesson\{Titel\}[Untertitel]}}
\let\lesson@subtitle\@empty
\def\set@lesson@subtitle[#1]{\gdef\lesson@subtitle{#1}}
\newcommand*{\lesson}[1]{\gdef\lesson@title{#1}\@ifnextchar[{\set@lesson@subtitle}{}}

\newcommand*{\classname}{Klasse}
\newcommand*{\@class}{0x}
\newcommand*{\@cl@ss}{0}
\newcommand*{\class}[1]{%
   \gdef\@class{#1}%
   \afterassignment\remove@to@nnil
   \count@=0#1\@nnil
   \edef\@cl@ss{\the\count@}%
}
\newcommand*{\printclass}{\@ifstar\@cl@ss\@class}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% SCHEDULE STYLES
\newcommand*{\NewScheduleStyle}[1]{%
   \@ifundefined{drc@style@#1}%
      {\drc@new@style{#1}}%
      {\ClassError{drcschool}{Schedule style `#1' already defined}%
                             {You should use \string\RenewScheduleStyle\space instead of \string\NewScheduleStyle.}}%
}
\newcommand*{\RenewScheduleStyle}[1]{%
   \@ifundefined{drc@style@#1}%
      {\ClassError{drcschool}{Schedule style `#1' not yet defined}%
                             {You should use \string\NewScheduleStyle\space instead of \string\RenewScheduleStyle.}}%
      {\drc@new@style{#1}}%
}
\newcommand*{\drc@new@style}[1]{\@ifnextchar[{\drc@new@style@#1}{\drc@new@style@#1[1]}}
\newcommand*{\drc@new@style@}{}
\newcommand*{\drc@new@style@@}{}
\def\drc@new@style@#1[#2]#3{% #1=style name; #2=time column width; #3=code containing \DeclareColumn instructions
   \begingroup
   \@tempcnta\@ne% number of columns
   \@tempcntb#2\relax% total width
   \@namegdef{drc@style@#1@colspec}{@{}|>{\raggedleft\arraybackslash}p{#2\dimen@}}% initialize col specs
   \@namegdef{drc@style@#1@header}{\bfseries Zeit\hfill\strut}% initialize header
   \@namegdef{drc@style@#1@newblock}{\leavevmode\drcschool@print@time}% initialize \newblock macro
   \@namegdef{drc@style@#1@reset}{}%
   \@namegdef{drc@style@#1}{}%
   \newcommand*{\DeclareColumn}[1][]{\Declare@Column{#1}{##1}}%
   #3%
   \g@addto@name{drc@style@#1@colspec}{|@{}}% finalize col specs
   \expandafter\xdef\csname drc@style@#1@width\endcsname{%
      (\noexpand\linewidth-\the\numexpr(\the\@tempcnta+1)\relax\noexpand\arrayrulewidth-\the\numexpr2*\the\@tempcnta\relax\noexpand\tabcolsep)/\the\@tempcntb\relax
   }%
   \@ifnextchar[{\drc@new@style@@#1}{\endgroup}%
}
\def\drc@new@style@@#1[#2]{\g@addto@name{drc@style@#1}{#2}\endgroup}
% The intended usage is \DeclareColumn[extra code]{\foo}{Foo}{width}.
% After expansion \DeclareColumn[extra code] becomes \Declare@Column{style name}{extra code}.
% The following trick generates the internal macro \drc@... such that
% \Declare@Column{style name}{extra code}{\foo} expands to
% \Declare@Column@{style name}{extra code}{\foo}{\drc@foo} and spares me to
% have to build the \drc@... macro every time I need it
\newcommand*{\Declare@Column}[3]{% #1=style name; #2=extra code in #3; #3=column macro
   \toks@\@xp{\csname drc@\@xp\@gobble\string#3\endcsname}%
   \edef\drc@next{\unexpanded{\Declare@Column@{#1}{#2}{#3}}{\unexpanded\@xp{\the\toks@}}}%
   \drc@next
}
\newcommand*{\Declare@Column@}[6]{% #1=style name; #2=extra code; #3=column macro; #4=internal column macro; #5=column name; #6=width
   \advance\@tempcnta\@ne% one column more in the table
   \advance\@tempcntb#6  % add total (relative) width
   \g@addto@name{drc@style@#1}{\def#4{}\long\def#3##1{\gdef#4{##1}\ignorespaces}}% add definition
   \g@addto@name{drc@style@#1@colspec}{|>{\raggedright\arraybackslash}p{#6\dimen@}}% add col specs
   \g@addto@name{drc@style@#1@header}{&\bfseries#5}% add header
   \g@addto@name{drc@style@#1@newblock}{&#2#4}% add line
   \g@addto@name{drc@style@#1@reset}{\gdef#4{}}% add reset
}
\NewScheduleStyle{default}[5]{%
   \DeclareColumn{\goal}{Ziele}{6}%
   \DeclareColumn[\def\\{\newline}\let\time\TeXtime]{\content}{Inhalt}{35}%
   \DeclareColumn{\method}{Methode}{6}%
   \DeclareColumn{\material}{Material}{8}%
}
\newcommand*{\drc@style}{default}
\newcommand*{\UseScheduleStyle}[1]{%
   \@ifundefined{drc@style@#1}%
      {\ClassError{drcschool}{Undefined schedule style}%
                             {I don't know the schedule style `#1'\MessageBreak so I'll keep using the default one.}}%
      {\def\drc@style{#1}}%
}
\newcommand*{\SetScheduleStyle}{%
   \ClassWarning{drcschool}{Deprecated command \string\SetScheduleStyle.\MessageBreak
                            Use \string\UseScheduleStyle\space instead}%
   \UseScheduleStyle
}
\newcommand*{\CopyScheduleStyle}[1]{%
   \@ifundefined{drc@style@#1}%
   {\drc@copy@style{#1}}%
   {\ClassError{drcschool}{Schedule style `#1' already defined}{An existing styles won't be overwritten.}\@gobble}%
}
\newcommand*{\drc@copy@style}[2]{%
   \@ifundefined{drc@style@#2}%
   {\ClassError{drcschool}{Schedule style `#2' undefined}{I can't make a copy of something not yet existing.}}%
   {\drc@copy@style@{#1}{#2}}%
}
\newcommand*{\drc@copy@style@}[2]{%
   \expandafter\let\csname drc@style@#1\expandafter\endcsname\csname drc@style@#2\endcsname
   \expandafter\let\csname drc@style@#1@newblock\expandafter\endcsname\csname drc@style@#2@newblock\endcsname
   \expandafter\let\csname drc@style@#1@reset\expandafter\endcsname\csname drc@style@#2@reset\endcsname
   \expandafter\let\csname drc@style@#1@colspec\expandafter\endcsname\csname drc@style@#2@colspec\endcsname
   \expandafter\let\csname drc@style@#1@header\expandafter\endcsname\csname drc@style@#2@header\endcsname
   \expandafter\let\csname drc@style@#1@width\expandafter\endcsname\csname drc@style@#2@width\endcsname
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% TYPESETTING THE SCHEDULE
\newcount\c@dur@tion
\newcommand*{\drc@duration}{90}% standard is 90 minutes
\newcommand*{\SetDuration}[1]{\def\drc@duration{#1}}

\newcommand*{\TeXtime}{}
\let\TeXtime\time% copy of primitive

\newcommand*{\SetBlockStart}[2]{%
   \def\@tempa##1:##2:##3\relax{{0##1}{0##2}}%
   \@xp\edef\csname block#1start\endcsname{\@tempa#2::\relax}%
}

\SetBlockStart{0}{00:00}
\SetBlockStart{1}{07:50}
\SetBlockStart{2}{09:40}
\SetBlockStart{3}{11:25}
\SetBlockStart{4}{14:00}
\SetBlockStart{5}{15:40}
\SetBlockStart{6}{16:00}
\SetBlockStart{7}{17:00}
\SetBlockStart{8}{18:00}
\SetBlockStart{9}{19:00}

\newcount\c@@hour
\newcount\c@@minute
\newcommand*{\drcschool@fix@time}{%
   \ifnum\c@@minute>59
      \global\advance\c@@hour\@ne
      \global\advance\c@@minute-60
      \@xp\drcschool@fix@time
   \fi
}

\newcommand*{\drcschool@time}[1]{%
   \xdef\drcschool@print@time{\vtop{\ialign{\hfil####&####\cr\two@digits\c@@hour:\two@digits\c@@minute\cr\strut+#1&$'$\cr}}}%
   \global\advance\c@dur@tion-#1
   \global\advance\c@@minute#1
   \drcschool@fix@time
   \ignorespaces
}

\newif\if@schedule@title \@schedule@titletrue
\define@key{drc@schedule}{title}[true]{\drc@key@to@bool{title}{@schedule@title}{#1}}
\define@key{drc@schedule}{block}{\@tempswafalse\def\drc@block{{#1}}}
\define@key{drc@schedule}{duration}{\def\drc@duration{#1}}
\define@key{drc@schedule}{start}{\@tempswatrue\def\drc@start{{#1}}}
\define@key{drc@schedule}{style}{\def\drc@style{#1}}

\newcommand*{\print@schedule@title}{%
   \begin{center}%
   \Large\scshape\classname~\@cl@ss\space---\space\ignorespaces\lesson@title\ifx\lesson@subtitle\@empty\else\space---\space\lesson@subtitle\fi
   \end{center}%
}

\NewEnviron{schedule}[1][1234]{%
   \cleardoublepage
   \pagestyle{empty}
   \newgeometry{hmargin=1.5cm,vmargin=2cm}%
   \drc@kv@num@else{#1}{\schedule@start@kv{#1}}{\schedule@start@block{#1}}{\schedule@start@time{#1}}%
   \clearpage\aftergroup\restoregeometry % do I really need this?!
}
% same as before but does not start a new page or change margins
\NewEnviron{schedule*}[1][1234]{%
   \drc@kv@num@else{#1}{\schedule@start@kv{#1}}{\schedule@start@block{#1}}{\schedule@start@time{#1}}%
}
\newcommand*{\schedule@start@kv}[1]{%
   \@tempswafalse
   \def\drc@block{{1234}}%
   \setkeys{drc@schedule}{#1}%
   \if@tempswa\@xp\@firstoftwo\else\@xp\@secondoftwo\fi
      {\@xp\schedule@start@time\drc@start}%
      {\@xp\schedule@start@block\drc@block}%
}
\newcommand*{\schedule@start@block}[1]{%
   \def\drc@next{\clearpage}%
   \def\@tempa##1{%
      \ifx##1\relax\else
         \edef\drc@next{\unexpanded\@xp{\drc@next}\noexpand\print@schedule\csname block##1start\endcsname\noexpand\clearpage}%
         \@xp\@tempa
      \fi
   }%
   \@tempa#1\relax
   \drc@next
}
\newcommand*{\schedule@start@time}[1]{%
   \def\@tempa##1:##2:##3\relax{\def\@tempa{{0##1}{0##2}}}%
   \@tempa#1::\relax
   \expandafter\print@schedule\@tempa
}
% Schedules are based on longtable, which has a little
% bug: https://tex.stackexchange.com/q/413473/82917
% I use here the fix proposed there, though only locally
\newcommand*{\drc@fix@LT@startpbox}{%
   \def\LT@startpbox##1{%
     \bgroup
       \color@begingroup
       \let\@footnotetext\LT@p@ftntext
       \setlength\hsize{##1}\@arrayparboxrestore
%       \everypar{\vrule\@height\ht\@arstrutbox\@width\z@\everypar{}}%
   }%
}
\newcommand*{\print@schedule}[2]{%
   \global\c@dur@tion\drc@duration\relax
   \global\c@@hour#1
   \global\c@@minute#2
   \if@schedule@title\print@schedule@title\fi
   \let\time\drcschool@time
   \ifcsname drc@style@\drc@style\endcsname
      \csname drc@style@\drc@style\endcsname
   \else
      \ClassError{drcschool}{Unknown schedule style `\drc@style'}{I'll go on with the default style. Keep your fingers crossed.}%
      \def\drc@style{default}%
      \drc@style@default
   \fi
   \edef\newblock{%
      \drc@csexpandonce{drc@style@\drc@style @newblock}%
      \drc@csexpandonce{drc@style@\drc@style @reset}%
      \unexpanded{\\\hline\let\par\relax}% added to cope with empty lines; restricted to current cell, so actually no harm possible. I hope.
   }%
   \drc@fix@LT@startpbox
   \dimen@\dimexpr\csname drc@style@\drc@style @width\endcsname\relax
   \edef\@tempa{{\drc@csexpandonce{drc@style@\drc@style @colspec}}}%
   \expandafter\longtable\@tempa
      \hline
      \csname drc@style@\drc@style @header\endcsname\\
      \multispan\LT@cols\unskip\leaders\hrule\@height\arrayrulewidth\hfill\cr
      \noalign{\vskip\doublerulesep}%
      \multispan\LT@cols\unskip\leaders\hrule\@height\arrayrulewidth\hfill\cr
      \endhead
      \let\par\relax % added to cope with empty lines; restricted to current cell, so actually no harm possible. I hope.
      \BODY
      \newblock
      \drcschool@fix@time
      \two@digits\c@@hour:\two@digits\c@@minute
      \check@duration
      \\
      \cline{1-1}%
   \endlongtable
}
\newcommand*{\check@duration}{%
   \ifnum\c@dur@tion=\z@\else
      \ifnum\c@dur@tion>\z@
         \rlap{\bfseries\quad!! \the\c@dur@tion\ Minute\ifnum\c@dur@tion>\@ne n\fi\ zu wenig !!}%
      \else
         \rlap{\bfseries\quad!! \@xp\@gobble\the\c@dur@tion\ Minute\ifnum\c@dur@tion<\m@ne n\fi\ zu viel !!}%
      \fi
   \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% DIFFICULTY SYMBOLS
\newcommand*{\difficulty@symbol}[1]{%
   \leavevmode
   \begingroup
   \unitlength\fontcharht\font`\A
   \@picture(1,1)(0,0)
   \linethickness{.8\p@}%
   #1%
   \endpicture
   \endgroup
}
\newcommand*{\easysymbol}{\difficulty@symbol{\put(.5,.55){\color{gray}\circle{1}}}}
\newcommand*{\mediumsymbol}{\difficulty@symbol{\color{gray}\put(.5,.55){\circle{1}}\moveto(0,.55)\curveto(.2,-.1)(.8,-.1)(1,.55)\closepath\fillpath}}
\newcommand*{\hardsymbol}{\difficulty@symbol{\put(.5,.55){\color{gray}\circle{1}\circle*{1}}}}
\newcommand*{\hardersymbol}{\difficulty@symbol{\put(.5,.55){\circle{1}\circle*{1}}}}
\newcommand*{\deadlysymbol}{%
   \leavevmode
   \begingroup
   \unitlength1ex
   \@picture(3.6,1.8)(-1.8,-1)
   \color{darkgray}
   \put(1.46,.13){\circle*{.64}}
   \put(-1.46,.13){\circle*{.64}}
   \put(1.3,-.79){\circle*{.64}}
   \put(-1.3,-.79){\circle*{.64}}
   \linethickness{.5\unitlength}
   \Line(1.46,.13)(-1.3,-.79)
   \Line(-1.46,.13)(1.3,-.79)
   \linethickness{.1\unitlength}
   \roundjoin
   \moveto(-.5,-.75)\curveto(-1.2,0)(-1,.9)(0,.9)\curveto(1,.9)(1.2,0)(.5,-.75)\lineto(.4,-1.2)\lineto(-.4,-1.2)\closepath\fillpath
   \color{white}
   \moveto(-.5,-.75)\curveto(-1.2,0)(-1,.9)(0,.9)\curveto(1,.9)(1.2,0)(.5,-.75)\lineto(.4,-1.2)\lineto(-.4,-1.2)\closepath\strokepath
   \put(.36,0){\circle*{.56}}
   \put(-.36,0){\circle*{.56}}
   \endpicture
   \endgroup
}

% for backward compatibility
\newcommand*{\difficulty}[1]{\ifcase#1\relax\easysymbol\or\mediumsymbol\or\hardsymbol\or\hardersymbol\else\deadlysymbol\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% GENERIC MACROS FOR EXERCISES
\newcounter{exercise}
\newcommand*{\exercisename}{Aufgabe}
\newcommand*{\starredexercisename}{Aufgabe}
\newcommand*{\starredexercisemark}{*}
\newcommand*{\drc@title@sep}{\enskip}
\newcommand*{\drc@title@L}{(}
\newcommand*{\drc@title@R}{)}
\newcommand*{\SetTitleSeparators}[3][\enskip]{\def\drc@title@sep{#1}\def\drc@title@L{#2}\def\drc@title@R{#3}}
\let\drcschool@difficulty\@empty
\let\drcschool@extra\@empty
\def\drc@ex@name{\exercisename}
\newcommand*{\reset@exercise@format}{\let\drcschool@difficulty\@empty\let\drcschool@extra\@empty\def\drc@ex@name{\exercisename}}

\newcommand*{\exercise}{%
   \ClassError{drcschool}{Lonely \string\exercise}%
              {An \string\exercise\space should appear only within a {test},\MessageBreak a {worksheet} or similar.}%
}
% difficulty versions
\newcommand*{\easy}{}   \def\easy\exercise{\def\drcschool@difficulty{\leavevmode\llap{\easysymbol\kern.5em}}\exercise}
\newcommand*{\medium}{} \def\medium\exercise{\def\drcschool@difficulty{\leavevmode\llap{\mediumsymbol\kern.5em}}\exercise}
\newcommand*{\hard}{}   \def\hard\exercise{\def\drcschool@difficulty{\leavevmode\llap{\hardsymbol\kern.5em}}\exercise}
\newcommand*{\harder}{} \def\harder\exercise{\def\drcschool@difficulty{\leavevmode\llap{\hardersymbol\kern.5em}}\exercise}
\newcommand*{\deadly}{} \def\deadly\exercise{\def\drcschool@difficulty{\leavevmode\vbox to\z@{\vss\llap{\deadlysymbol\kern.5em}}}\exercise}
% customizable
\newcommand*{\exercisesymbol}[1]{\def\drcschool@difficulty{\leavevmode\llap{#1\kern.5em}}}

% exercise in worksheet
\newcommand*{\exercise@ws}{%
   \@ifstar{\def\drc@ex@name{\starredexercisename}\def\drcschool@extra{\starredexercisemark}\exercise@ws@}%
           {\exercise@ws@}%
}
\newcommand*{\exercise@ws@}[1][]{%
   \refstepcounter{exercise}%
   \gdef\s@luti@n{0}% no solution yet
   \if\relax\detokenize{#1}\relax\def\drc@next{}\else\def\drc@next{\drc@title@sep\drc@title@L#1\drc@title@R}\fi
   \drc@heading{2ex\@plus.5ex\@minus.2ex}{.2ex\@plus.2ex\@minus.2ex}{\drcschool@difficulty\drc@ex@name~\theexercise\drcschool@extra\autodot\drc@next}%
   \reset@exercise@format
}
% exercise in test (similar to exercise in worksheet but increases number of points)
\newcommand*{\exercise@test}{%
   \@ifstar{\@tempswafalse\def\drc@ex@name{\starredexercisename}\def\drcschool@extra{\starredexercisemark}\exercise@test@}%
           {\@tempswatrue\exercise@test@}%
}
\newcommand*{\exercise@test@}[1][0]{%
   \if@tempswa
      \if@solution\advance\drcschool@pts#1\p@\fi
   \fi
   \refstepcounter{exercise}%
   \gdef\s@luti@n{0}% no solution yet
   \dimen@#1\p@
   \drc@heading{2ex\@plus.5ex\@minus.2ex}{.2ex\@plus.2ex\@minus.2ex}{%
      \drcschool@difficulty
      \drc@ex@name~\theexercise\drcschool@extra\autodot\drc@title@sep
      \drc@title@L\drcschool@pts@pre\drc@strip@pt\dimen@\drcschool@pts@post\ Punkt\ifdim\dimen@=\p@\else e\fi\drc@title@R
   }%
   \reset@exercise@format
}
% similar to the above but with independent counter
\newcounter{experiment}
\newcommand*{\experimentname}{Versuch}
\newcommand*{\experiment}{%
   \ClassError{drcschool}{Stray \string\experiment}%
              {An \string\experiment\space should appear only within a worksheet (or similar).}%
}
\newcommand*{\experiment@ws}[1][]{%
   \refstepcounter{experiment}%
   \setcounter{question}{0}% the counter \c@question is reset by \exercise, so I have to do this manually...
   \if\relax\detokenize{#1}\relax\def\drc@next{}\else\def\drc@next{\drc@title@L#1\drc@title@R}\fi
   \drc@heading{2ex\@plus.5ex\@minus.2ex}{.2ex\@plus.2ex\@minus.2ex}{\experimentname~\theexperiment\autodot\drc@title@sep\drc@next}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% GENERIC MACROS FOR SOLUTIONS
\newif\if@solution

\newcommand{\IfSolutionT}{\if@solution\@xp\@firstofone\else\@xp\@gobble\fi}
\newcommand{\IfSolutionF}{\if@solution\@xp\@gobble\else\@xp\@firstofone\fi}
\newcommand{\IfSolutionTF}{\if@solution\@xp\@firstoftwo\else\@xp\@secondoftwo\fi}
\newcommand{\IfSolutionFT}{\if@solution\@xp\@secondoftwo\else\@xp\@firstoftwo\fi}

\newcommand*{\answer}{\ClassError{drcschool}{Stray \string\answer}{An \string\answer\space should appear only within a {solution} environment.}}
\newcounter{answer}[exercise]
\renewcommand*{\theanswer}{\@alph\c@answer}
\newcommand*{\the@answer}{\leavevmode\llap{\csname qst\the\c@worksheet.\the\c@exercise.\the\c@answer mark\endcsname}\@alph\c@answer}
\newcommand*{\@answer}[1][]{%
   \if\relax\detokenize{#1}\relax
      \advance\c@answer\@ne
   \else
      \c@answer`#1\relax
      \advance\c@answer-96
   \fi
   \drc@heading{.2ex\@plus.2ex\@minus.2ex}{-.5em}{\the@answer.}%
}
\newcommand*{\solutionname}{Lösung}
\NewEnviron{solution}{%
   \ifdefined\s@lution
      \ClassError{drcschool}{Nested solutions}{A solution's solution isn't meaningful.}%
   \else
      \def\s@lution{\relax}%
   \fi
   \ifnum1=\s@luti@n\relax
      \ClassError{drcschool}{Multiple solutions}%
                 {Exercise \the\c@exercise\space already has a solution.}%
   \fi
   \if@solution\@xp\drcschool@solution\fi
}
\newcommand*{\drcschool@solution}{%
   \def\NoCheck{\let\drc@check@answers\relax}%
   \def\answer{\@answer}%
   \drc@heading{.5ex\@plus.4ex\@minus.2ex}{.2ex\@plus.2ex\@minus.2ex}{\solutionname}%
   \BODY
   \drc@check@answers
   \global\def\s@luti@n{1}%
   \par
}
\newcommand*{\drc@check@answers}{%
   \ifnum\c@answer=\c@question\else
   \ClassWarningNoLine{drcschool}{Exercise \the\c@exercise\space has
                                  \ifnum\c@question=0no\else\the\c@question\fi\space question\ifnum\c@question>1s\fi\space
                                  but \ifnum\c@answer=0no\else\the\c@answer\fi\space answer\ifnum\c@answer>1s\fi}%
   \fi
}

% "mini" inline solution based on \signed from the TeXbook
\newcommand*{\minisolution}[2][\solutionname\hintsep]{%
   \begingroup
   \unskip\nobreak\hfil
   \penalty50
   \hskip1em\hbox{}\nobreak\hfil\hbox{[\,{\itshape#1~#2}\,]}%
   \parfillskip\z@
   \finalhyphendemerits\z@
   \par
   \endgroup
}

%\newcommand*{\shortsolution}{\@ifstar\shortsolution@nopar\shortsolution@par}
%\newcommand*{\shortsolution@par}{\if@solution\par\noindent{\bfseries\solutionname}\space\ignorespaces\@xp\@firstofone\else\@xp\@gobble\fi}
%\newcommand*{\shortsolution@nopar}{\if@solution\textbf{\solutionname}\space\ignorespaces\@xp\@firstofone\else\@xp\@gobble\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% QUESTION ENVIRONMENTS
% All question-like environments share the same counter;
% this is reset at every \exercise.
\newcounter{question}[exercise]
% \question is by default an error; it gets reset by {questions} & Co.
\newcommand*{\question}{%
   \ClassError{drcschool}{Stray \string\question}%
              {A \string\question\space should appear only within a {questions}\MessageBreak
               {multchoice} or {multresponse} environment.\MessageBreak
              Maybe you want to use \string\lonelyquestion.}%
}
\newcommand*{\starredquestionmark}{*}
\newcommand*{\drc@qst@extra}{}
\renewcommand*{\thequestion}{\@alph\c@question}
\newcommand*{\the@question}{\leavevmode\llap{\bfseries\drc@qst@extra}\thequestion}
% if someone *really* needs it anywhere
\newcommand*{\lonelyquestion}{%
   \ClassError{drcschool}{Stray \string\lonelyquestion}%
              {A \string\lonelyquestion\space can appear only within a {test} or {worksheet}.}%
}
\newcommand*{\lonelyquestion@}{%
   \ifdefined\s@lution
      \ClassError{drcschool}{Question in solution}%
                            {A \string\lonelyquestion\space environment cannot appear\MessageBreak within a {solution} environment.}%
   \fi
   \leavevmode
   \refstepcounter{question}%
   \@ifstar{%
      \def\drc@qst@extra{\starredquestionmark}%
      \@namexdef{qst\the\c@worksheet.\the\c@exercise.\the\c@question mark}{\unexpanded\expandafter{\starredquestionmark}}%
      \hb@xt@1.5em{\bfseries\the@question.\hfil}%
      \qst@pts
     }{%
      \def\drc@qst@extra{}%
      \@namegdef{qst\the\c@worksheet.\the\c@exercise.\the\c@question mark}{}%
      \hb@xt@1.5em{\bfseries\the@question.\hfil}%
      \qst@pts
   }%
}

% all question-like environments must do some checks, so let us define them here
\newcommand*{\drc@questions@check}{%
   \ifdefined\questi@ns
      \ClassError{drcschool}{Nested questions}%
                            {{question}-like environments must be nested.}
   \else
      \def\questi@ns{\relax}%
   \fi
   \ifdefined\s@lution
      \ClassError{drcschool}{Questions in solution}%
                            {The {\@currenvir} environment should not appear\MessageBreak within a {solution} environment.}%
   \fi
}
% "normal" questions, based on list
\newenvironment{questions}{%
   \drc@questions@check
   \list{\thequestion}{%
      \@nmbrlisttrue
      \def\@listctr{question}%
      \def\makelabel##1{{\bfseries\llap{\drc@qst@extra}##1.}\hss}%
      \def\drc@qst@extra{}%
      \topsep\z@
      \partopsep\z@
      \itemsep\z@
      \parsep\z@
      \settowidth{\labelwidth}{\bfseries m.}%
      \leftmargin\labelwidth
      \advance\leftmargin\labelsep
   }%
   \def\question{\l@question}%
  }{%
   \endlist
}
% list question
\newcommand*{\l@question}{%
   \@ifstar{%
      \def\drc@qst@extra{\starredquestionmark}%
      \item\relax
      \@namexdef{qst\the\c@worksheet.\the\c@exercise.\the\c@question mark}{\unexpanded\expandafter{\starredquestionmark}}%
      \qst@pts
     }{%
      \def\drc@qst@extra{}%
      \item\relax
      \@namegdef{qst\the\c@worksheet.\the\c@exercise.\the\c@question mark}{}%
      \qst@pts
   }%
}
\newcommand*{\qst@pts}[1][]{%
   \if\relax\detokenize{#1}\relax\else
      \dimen@#1\p@
      \textbf{(\drc@strip@pt\dimen@~Punkt\ifdim\dimen@=\p@\else e\fi)}\space\ignorespaces
   \fi
}
% horizontal questions, based on a tabular
\newcount\c@qst@col
\newdimen\drc@hqst@lastdepth
\newdimen\drc@hqst@xvspace
\define@key{drc@hqst}{arraystretch}{\def\arraystretch{#1}}
\define@key{drc@hqst}{extrarowheight}{\extrarowheight#1\relax\drc@hqst@lastdepth#1\relax}
\define@key{drc@hqst}{tabcolsep}{\tabcolsep#1\relax}
\define@key{drc@hqst}{lastdepth}{\drc@hqst@lastdepth#1\relax}
\define@key{drc@hqst}{extrarowdepth}{\drc@hqst@xvspace#1\relax}
\newcommand*{\start@horizontal@questions}[2]{% #1=nr of columns #2=key/val
   \drc@questions@check
   \global\c@qst@col\z@
   \drc@hqst@lastdepth\z@
   \drc@hqst@xvspace\z@
   \setkeys{drc@hqst}{#2}%
   \dimen@\dimexpr\linewidth/#1+2\tabcolsep/#1-1.5em\relax
   \advance\dimen@-2\tabcolsep
   \setbox\drc@box=\vbox\bgroup\hsize\linewidth\noindent
   \tabular[t]{@{}*{#1}{p{1.5em}@{}p{\dimen@}}@{}}%
}
\newcommand*{\stop@horizontal@questions}{%
   \\[\drc@hqst@lastdepth]
   \endtabular
   \par
   \xdef\drc@next{\noexpand\prevdepth\the\prevdepth}%
   \egroup
   \par\noindent
   \box\drc@box
   \par\drc@next
}
\newenvironment{questions*}[2][]{%
   \def\question{\leavevmode\refstepcounter{question}\h@question{#2}}%
   \start@horizontal@questions{#2}{#1}%
  }{%
   \stop@horizontal@questions
   \@endparenv
}
\newcommand*{\h@question}[1]{%
   \@ifstar{%
      \gdef\drc@qst@extra{\starredquestionmark}%
      \@namexdef{qst\the\c@worksheet.\the\c@exercise.\the\c@question mark}{\unexpanded\expandafter{\starredquestionmark}}%
      \h@questi@n{#1}%
     }{%
      \gdef\drc@qst@extra{}%
      \@namegdef{qst\the\c@worksheet.\the\c@exercise.\the\c@question mark}{}%
      \h@questi@n{#1}%
   }%
}
\newcommand*{\h@questi@n}[1]{%
   \ifnum\c@qst@col=\z@
      \def\drc@next{\textbf{\the@question.}&}%
      \global\advance\c@qst@col\@ne
   \else
      \ifnum\c@qst@col<#1\relax
         \def\drc@next{&\textbf{\the@question.}&}%
         \global\advance\c@qst@col\@ne
      \else
         \def\drc@next{\\[\drc@hqst@xvspace]\textbf{\the@question.}&}%
         \global\c@qst@col\@ne
      \fi
   \fi
   \drc@next
   \qst@pts
}

% hint
\newcommand*{\hintname}{Hinweis}
\newcommand*{\hintsep}{: }
\newenvironment{hint}[1][\hintname\hintsep]{%
   \vspace\p@\par\nobreak\@afterheading\small
   \list{\itshape#1}{%
      \topsep\z@
      \def\makelabel##1{##1\hfil}%
      \settowidth{\labelwidth}{\itshape#1}%
      \leftmargin\labelwidth
      \advance\leftmargin\labelsep
   }%
   \item\relax
  }{\endlist}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% RADIO BUTTONS & CHECKBOXES
% check boxes
\newcommand*{\checkbox}{\checkbox@}
\newcommand*{\checkbox@}{%
   \leavevmode
   \bgroup
   \setbox\z@=\hbox{\fontencoding{U}\fontfamily{fontawesometwo}\selectfont\char27}% empty check box
   \setbox\tw@=\hb@xt@\wd\z@{\fontencoding{U}\fontfamily{fontawesometwo}\selectfont\char26\hss}% filled check box
   \@ifstar{\lower.2ex\if@solution\box\tw@\else\box\z@\fi\egroup}{\lower.2ex\box\z@\egroup}%
}

% radio buttons
\newcommand*{\radiobutton}{\radiobutton@}
\newcommand*{\radiobutton@}{\leavevmode\@ifstar{\radiobutton@@{\if@solution\circle*{.6}\fi}}{\radiobutton@@{}}}
\newcommand*{\radiobutton@@}[1]{%
   \begingroup
   \unitlength1.5ex
   \@picture(1,1)(0,0)%
   \linethickness{.75pt}%
   \put(.5,.4){\circle{1}#1}%
   \endpicture
   \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% MULTIPLE CHOICE/RESPONSE, TRUE/FALSE TABLE
\newif\if@choice
\newcommand*{\check@choice}{%
   \if@choice\else
      \ClassWarningNoLine{drcschool}{Question \thequestion. without a correct choice}%
   \fi
}
\newcommand*{\check@choices}{%
   \if@choice
      \ClassWarningNoLine{drcschool}{Too many correct choices for question \thequestion.\MessageBreak
                                     The environment {multchoice} should have only one correct choice per \string\question}%
   \else
      \@choicetrue
   \fi
}
% The following four environments are quite similar to each other
% but I have no time to come up with a more efficient way to write them
\newcommand*{\m@question}{%
   \questions
   \def\question{%
      \check@choice
      \@choicefalse
      \l@question
   }%
   \@choicefalse
   \l@question
}

\newcommand*{\choice}{%
   \ClassError{drcschool}{Stray \string\choice}%
              {A \string\choice\space should appear only within a {multchoice} or {multresponse} environment.}%
}
\newcommand*{\@choice}[2]{%
   \par\noindent
   #2% this will basically be either \@choicetrue or \relax
   \setbox\z@=\hbox to2em{\kern.5em#1\hfil}%
   \hangindent\wd\z@
   \box\z@
   \ignorespaces
}

% multiple response (deutsch: multiple choice)
\newenvironment{multresponse}{%
   \def\question{\m@question}%
   \def\choice{\@ifstar{\@choice{\checkbox*}{\@choicetrue}}{\@choice{\checkbox}{\relax}}}%
  }{%
   \check@choice
   \endquestions
   \@endparenv
}
% horizontal version thereof
\newenvironment{multresponse*}[1]{%
   \def\question{%
      \leavevmode
      \check@choice
      \global\@choicefalse
      \refstepcounter{question}%
      \h@question{#1}%
   }%
   \def\choice{\@ifstar{\@choice{\checkbox*}{\@choicetrue}}{\@choice{\checkbox}{}}}%
   \global\@choicetrue% for the first question
   \start@horizontal@questions{#1}{}%
  }{%
   \check@choice
   \stop@horizontal@questions
   \@endparenv
}
% multiple choice (deutsch: single choice)
\newenvironment{multchoice}{%
   \def\question{\m@question}%
   \def\choice{\@ifstar{\@choice{\radiobutton*}{\check@choices}}{\@choice{\radiobutton}{\relax}}}%
  }{%
   \check@choice
   \endquestions
   \@endparenv
}
% horizontal version thereof
\newenvironment{multchoice*}[1]{%
   \def\question{%
      \leavevmode
      \check@choice
      \global\@choicefalse
      \refstepcounter{question}%
      \h@question{#1}%
   }%
   \def\choice{\@ifstar{\@choice{\radiobutton*}{\check@choices}}{\@choice{\radiobutton}{}}}%
   \global\@choicetrue% for the first question
   \start@horizontal@questions{#1}{}%
  }{%
   \check@choice
   \stop@horizontal@questions
   \@endparenv
}
% true/false table
\newenvironment{TF}[1][\linewidth]{%
   \def\true{&\radiobutton*&\radiobutton\\}%
   \def\false{&\radiobutton&\radiobutton*\\}%
   \par\medskip\noindent
   \renewcommand*{\tabularxcolumn}[1]{b{##1}}% local redefinition
   \tabularx{#1}{X*{2}{>{\centering\arraybackslash}b{3em}}}%
   \toprule
    & wahr & falsch \\
   \midrule[\heavyrulewidth]
 }{\bottomrule\endtabularx\par\medskip\@endparenv}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% CLOZE TEST AND RELATED MACROS
\newenvironment{cloze}[1][1.4]{%
   \dimen@#1\p@
   \advance\dimen@-\p@
   \edef\@tempa{\strip@pt\dimen@}%
   \flushleft
   \vskip-\@tempa\baselineskip
   \def\baselinestretch{#1}\normalsize
 }{\endflushleft}

\newcommand*{\print@drc@box}{\if@solution\box\drc@box\else\vrule\@height\ht\drc@box\@depth\dp\drc@box\@width\z@\kern\wd\drc@box\fi}

\newcommand*{\fillhere}{\@ifstar\fill@here@fl\fill@here}
% starred form: fill here full line
\newcommand*{\fill@here@fl}[1]{%
   \leavevmode
   \hb@xt@\z@{\if@solution#1\fi\hss}%
   \leaders\hrule\@depth\dimexpr.9\dp\strutbox+.4\p@\relax\@height-.9\dp\strutbox\hfill\kern\z@
}
% normal version
\newcommand*{\fill@here}[2][2]{%
   \relax
   \ifmmode
      \setbox\z@=\hbox{$\m@th\displaystyle#2$}%
   \else
      \setbox\z@=\hbox{\vrule\@depth.5ex\@width\z@#2}%
   \fi
   \Ifdimen{#1}{\setbox\drc@box=\hb@xt@#1}{\setbox\drc@box=\hb@xt@#1\wd\z@}{\hfil\unhbox\z@\hfil}%
   \fill@here@
}
\newcommand*{\fill@here@}{\underline{\print@drc@box}}

% light gray boxes
\newcommand*{\fillbox}{%
   \relax
   \begingroup
   \fboxrule\z@
   \ifmmode
      \@xp\fillbox@m
   \else
      \@xp\fillbox@t
   \fi
}
\newcommand*{\fillbox@t}[2][2]{%
   \setbox\z@=\hbox{#2}%
   \Ifdimen{#1}{\setbox\drc@box=\hb@xt@#1}{\setbox\drc@box=\hb@xt@#1\wd\z@}{\hfil\unhbox\z@\hfil}%
   \fcolorbox{lightgray}{lightgray}{\print@drc@box}%
   \endgroup
}
\newcommand*{\fillbox@m}[2][1]{%
   \binrel@{#2}%
   \fboxsep1.5\p@
   \binrel@@{\mathpalette{\fillbox@m@{#1}}{#2}}%
   \endgroup
}
\newcommand*{\fillbox@m@}[3]{% #1=width  #2=\...style  #3=arg
   \setbox\z@\hbox{$\m@th#2#3$}%
   \Ifdimen{#1}{\setbox\drc@box=\hb@xt@#1}{\setbox\drc@box=\hb@xt@#1\wd\z@}{\hfil\unhbox\z@\hfil}%
   \fcolorbox{lightgray}{lightgray}{\print@drc@box}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% USEFUL (?) TABULAR COLUMNS
\newcolumntype{L}{>{$\displaystyle{}}l<{$}}
\newcolumntype{C}{>{$\displaystyle}c<{$}}
\newcolumntype{R}{>{$\displaystyle}r<{$}}
\newcolumntype{f}[1]{>{\setbox\drc@box=\hb@xt@#1\bgroup\hfil\ignorespaces}c<{\unskip\hfil\egroup\fill@here@}}
\newcolumntype{F}[1]{>{\setbox\drc@box=\hb@xt@#1\bgroup\hfil$\displaystyle}c<{$\hfil\egroup\fill@here@}}
\newcolumntype{s}{>{\setbox\z@=\hbox\bgroup}c<{\egroup\scolumn@header\if@solution\copy\z@\else\kern\wd\z@\fi\gdef\scolumn@header{\relax}}}
\newcolumntype{S}{>{\setbox\z@=\hbox\bgroup$\displaystyle}c<{$\egroup\scolumn@header\if@solution\copy\z@\else\kern\wd\z@\fi\gdef\scolumn@header{\relax}}}
\newcommand*{\scolumn@header}{\relax}
\newcommand*{\scolumnheader}{\gdef\scolumn@header{\@solutiontrue}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% MATCHING QUIZ
\define@key{drc@match}{xsep}{\drc@dima#1\relax}
\define@key{drc@match}{ysep}{\drc@dimb#1\relax}
\define@key{drc@match}{shuffle}[both]{%
   \Ifstr{#1}{both}{\def\drc@shuffle{\drc@shuffle@both}}{%
      \Ifstr{#1}{left}{\def\drc@shuffle{\drc@shuffle@left}}{%
         \Ifstr{#1}{right}{\def\drc@shuffle{\drc@shuffle@right}}{%
            \ClassError{drcschool}{Unknown value `#1' for key `shuffle'}%
                       {The key `shuffle' accepts only the values left/right/both.\MessageBreak I assume you want to shuffle only the right column.}%
            \def\drc@shuffle{\drc@shuffle@right}%
         }%
      }%
   }%
}
\define@key{drc@match}{seed}{\edef\drc@match@seed{\the\numexpr#1\relax}}
\define@key{drc@match}{bent}[]{\def\drc@match@lines{to[out=0,in=180]}}

\newcommand*{\drc@shuffle@left}{\drc@shuffle@{\drc@match@seed}{L}}
\newcommand*{\drc@shuffle@right}{\drc@shuffle@{\drc@match@seed}{R}}
\newcommand*{\drc@shuffle@both}{\drc@shuffle@{\drc@match@seed}{L}\drc@shuffle@{\numexpr\drc@match@seed+2011\relax}{R}}
%\newcommand*{\drc@shuffle@}[2]{% Fisher--Yates algorithm
%   \pgfmathsetseed{#1}%
%   \foreach \x in {1,...,\the\numexpr\count@-1\relax} {%
%      \pgfmathrandominteger{\y}{\x}{\the\count@}%
%      \edef\temp{\csname drc@match@#2\x\endcsname}%
%      \global\@xp\edef\csname drc@match@#2\x\endcsname{\csname drc@match@#2\y\endcsname}%
%      \global\@xp\edef\csname drc@match@#2\y\endcsname{\temp}%
%   }%
%}
\ExplSyntaxOn% use kernel random number generator
\newcommand*{\drc@shuffle@}[2]{% Fisher--Yates algorithm
   \sys_gset_rand_seed:n{#1}
   \foreach \x in {1,...,\the\numexpr\count@-1\relax} {
      \edef\y{\int_rand:nn{\x}{\count@}}
      \edef\temp{\csname drc@match@#2\x\endcsname}
      \global\@xp\edef\csname drc@match@#2\x\endcsname{\csname drc@match@#2\y\endcsname}
      \global\@xp\edef\csname drc@match@#2\y\endcsname{\temp}
   }%
}
\ExplSyntaxOff

\newcommand*{\match}[2]{%
   \ClassError{drcschool}{Stray \string\match}{The macro \string\match\space makes sense only within a {matching} environment.}%
}
\newcommand*{\match@}[2]{%
   \advance\count@\@ne
   \@xp\edef\csname drc@match@L\the\count@\endcsname{{\the\count@}{#1}}%
   \@xp\edef\csname drc@match@R\the\count@\endcsname{{\the\count@}{#2}}%
   \ignorespaces
}
\newenvironment{matching}[1][]{%
   \drc@dima3cm\relax
   \drc@dimb1.3\baselineskip\relax
   \edef\drc@match@seed{\the\numexpr\time*\year\relax}
   \def\drc@shuffle{\drc@shuffle@right}%
   \def\drc@match@lines{--}%
   \setkeys{drc@match}{#1}%
   \count@\z@
   \let\par\relax
   \def\match{\match@}%
   \ignorespaces
  }{%
   \drc@shuffle
   \begin{tikzpicture}
   \foreach \x in {1,...,\the\count@} {%
      \node[draw,left]  (L\@xp\@xp\@xp\@firstoftwo\csname drc@match@L\x\endcsname) at (0,-\x*\drc@dimb) {\@xp\@xp\@xp\@secondoftwo\csname drc@match@L\x\endcsname} ;
      \node[draw,right] (R\@xp\@xp\@xp\@firstoftwo\csname drc@match@R\x\endcsname) at (\drc@dima,-\x*\drc@dimb) {\@xp\@xp\@xp\@secondoftwo\csname drc@match@R\x\endcsname} ;
   }%
   \IfSolutionT{\foreach \x in {1,...,\the\count@} { \draw[<->] (L\x.east) \drc@match@lines (R\x.west) ;}}
   \end{tikzpicture}%
}

\if@drctikz\else
   \renewenvironment{matching}{%
      \ClassError{drcschool}{No environment {matching} without tikz}{Remove the `notikz' option.}%
      \def\match{\@gobbletwo}%
  }{}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% WORKSHEETS
\newcounter{worksheet}
\newcommand*{\worksheetname}{Arbeitsblatt}
\newcommand*{\drc@reset@counters}{%
   \setcounter{exercise}{0}%
   \setcounter{experiment}{0}%
   \setcounter{figure}{0}%
   \setcounter{table}{0}%
   \setcounter{equation}{0}%
   \setcounter{footnote}{0}%
}

% bookmarks: by default they actually do nothing, unless hyperref is loaded
\newcommand*{\drc@add@bookmark}{%
   \IfSolutionTF{\drc@add@bookmark@{ -- \solutionname}{L}}{\drc@add@bookmark@{}{T}}%
}
\newcommand*{\drc@add@bookmark@}[2]{%
   \drc@pdfbookmark[1]{\worksheetname\ifx\ws@title\@empty\space\the\c@worksheet\else\space\glqq\ws@title\grqq\fi#1}{AB.\the\c@worksheet.#2}%
}
\newcommand*{\drc@pdfbookmark}[3][]{}
\AtBeginDocument{\@ifpackageloaded{hyperref}{\def\drc@pdfbookmark{\pdfbookmark}}{}}

\newcommand*{\drc@print@wstitle}{\ifx\ws@title\@empty\else\begin{center}\large\scshape\ws@title\end{center}\expandafter\par\fi\@afterindentfalse\@afterheading}

\define@key{drc@ws}{title}{\def\ws@title{#1}}
\newif\if@drc@ws@name
\define@key{drc@ws}{name}[true]{\drc@key@to@bool{name}{@drc@ws@name}{#1}}
\newif\if@drc@ws@date
\define@key{drc@ws}{date}[true]{\drc@key@to@bool{name}{@drc@ws@date}{#1}}
\define@key{drc@ws}{solution}[true]{\drc@key@to@bool{name}{@solution}{#1}}
\define@key{drc@ws}{fontsize}{\KOMAoption{fontsize}{#1}}
\define@key{drc@ws}{geometry}{\@tempswatrue\def\drc@geometry@options{{#1}}}
%\newcommand*{\drc@ws@startmulticol}{\relax}\newcommand*{\drc@ws@stopmulticol}{\relax}
%\define@key{drc@ws}{multicol}[2]{%
%   \def\drc@ws@startmulticol{\def\@currenvir{multicols}\columnsep2em\multicols{#1}}
%   \def\drc@ws@stopmulticol{\endmulticols\def\@currenvir{worksheet*}}%
%}

\newcommand*{\drc@default@ws@options}{name=false,date=true}
\newcommand*{\SetWorksheetOptions}[1]{\gdef\drc@default@ws@options{#1}}
\newcommand*{\AddWorksheetOptions}[1]{\g@addto@macro\drc@default@ws@options{,#1}}

\newcommand*{\drc@worksheet@setup}[1]{%
   \ifdefined\w@rksh@@t
      \ClassError{drcschool}{Nested worksheets}{Worksheets must not be nested...\MessageBreak I have no idea what will happen now.}%
   \else
      \def\w@rksh@@t{\relax}%
   \fi
   \stepcounter{worksheet}%
   \let\ws@title\@empty
   \@expandtwoargs\setkeys{drc@ws}{\drc@default@ws@options}%
   \@tempswafalse
   \drc@ifkv{#1}{\setkeys{drc@ws}{#1}}{\def\ws@title{#1}}%
   \if@tempswa
      \expandafter\newgeometry\drc@geometry@options
      \def\drc@ws@end{\aftergroup\restoregeometry}%
   \else
      \let\drc@ws@end\relax
   \fi
   \let\exercise\exercise@ws
   \let\experiment\experiment@ws
   \let\lonelyquestion\lonelyquestion@
%   \pagestyle{scrheadings}%
      \ihead[\if@solution\else\if@drc@ws@name Name:\fi\fi]{}%
      \ohead[\if@solution\else\if@drc@ws@date Datum:\kern4cm\fi\fi]{}%
      \ifoot[\if@solution\solutionname\fi]{\ifx\ws@title\@empty\else\ws@title\if@solution\space--- \fi\fi\if@solution\solutionname\fi}%
%      \ofoot[]{\thepage}%
}

% fake page number in worksheets
\newcommand*{\drc@set@fakepage}{%
   \count@\c@page
   \advance\count@\m@ne
   \edef\the@fakepage{\noexpand\the\noexpand\numexpr\noexpand\c@page-\the\count@\relax}%
   \def\drc@page{\the@fakepage}%
}

\NewEnviron{worksheet}[1][]{%
   % generic setup
   \cleardoublepage
   \drc@worksheet@setup{#1}%
   % first the version for pupils
   \@solutionfalse
   \drc@set@fakepage
   \thispagestyle{plain}%
   \drc@reset@counters
   \begingroup
   \let\label\@gobble
   \let\label@in@display\@gobble
   \drc@add@bookmark
   \if@twocolumn
      \@topnewpage[\drc@print@wstitle]\@afterindentfalse\@afterheading
   \else
      \drc@print@wstitle
   \fi
   \BODY
   \clearpage
   \removebackgroundgrid
   \ifnum\the@fakepage>\tw@\cleardoublepage\fi
   \endgroup
   % then the version with solutions
   \@solutiontrue
   \drc@set@fakepage
   \thispagestyle{plain}%
   \drc@reset@counters
   \drc@add@bookmark
   \if@twocolumn
      \@topnewpage[\drc@print@wstitle]\@afterindentfalse\@afterheading
   \else
      \drc@print@wstitle
   \fi
   \BODY
   \clearpage
   \drc@ws@end
   \removebackgroundgrid
}

% sometimes one doesn't really need a version with solution
\newenvironment{worksheet*}[1][]{%
   \cleardoublepage
   \@solutionfalse
   \drc@worksheet@setup{#1}%
   \drc@set@fakepage
   \thispagestyle{plain}%
   \drc@reset@counters
   \drc@add@bookmark
   \if@twocolumn
      \@topnewpage[\drc@print@wstitle]\@afterindentfalse\@afterheading
   \else
      \drc@print@wstitle
   \fi
  }{%
   \clearpage
   \drc@ws@end
   \removebackgroundgrid
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% FOR STUFF TO BE PRINTED MORE THAN ONCE ON THE SAME PAGE
\define@key{drc@print}{title}{\def\ws@title{#1}}
\define@key{drc@print}{hmargin}{\drc@dima#1\relax}
\define@key{drc@print}{vmargin}{\drc@dimb#1\relax}
\define@key{drc@print}{margin}{\drc@dima#1\relax\drc@dimb\drc@dima}
\define@key{drc@print}{fontsize}{\KOMAoption{fontsize}{#1}}

\newcommand*{\drcschool@print@setup}[2]{% #1 = keys, #2 = number of copies on same page
   \let\ws@title\@empty
   \cleardoublepage
   \stepcounter{worksheet}%
   \drc@reset@counters
   \let\exercise\exercise@ws
   \let\experiment\experiment@ws
   \thispagestyle{empty}%
   \drc@dima2cm
   \drc@dimb1.5cm
   \drc@ifkv{#1}{\setkeys{drc@print}{#1}}{\def\ws@title{#1}}%
   \newgeometry{hmargin=\drc@dima,vmargin=\drc@dimb}%
   \drc@dima=\dimexpr\paperwidth-2\drc@dima\relax
   \drc@dimb=\dimexpr\paperheight/#2-2\drc@dimb\relax
}

\newcommand*{\drcschool@print@startcollect}{%
   \setbox\z@\vbox to\drc@dimb\bgroup
   \hsize\drc@dima
   \textwidth\drc@dima
   \linewidth\drc@dima
   \normalsize
}

\newcommand*{\drcschool@print@stopcollect}{\par\vfil\egroup}

% STUFF TO BE PRINTED TWICE
\newenvironment{print2}[1][]{%
   \drcschool@print@setup{#1}{2}%
   \drc@add@bookmark
   \drcschool@print@startcollect
   \drc@print@wstitle
  }{%
   \drcschool@print@stopcollect
   \copy\z@\vfill\box\z@
   \clearpage
   \aftergroup\restoregeometry
}

% prints the content twice on a page for kids, and then once with solution
\NewEnviron{print2+}[1][]{%
   \drcschool@print@setup{#1}{2}%
   \drc@add@bookmark
   \@solutionfalse
   \drcschool@print@startcollect\drc@print@wstitle\BODY\drcschool@print@stopcollect
   \copy\z@\vfill\copy\z@
   \restoregeometry% does also \clearpage internally
   \drc@reset@counters
   \@solutiontrue
   \drc@add@bookmark
   \drc@print@wstitle
   \BODY
   \clearpage
}

% prints on the same page the content once with and once without solution
\NewEnviron{print2-}{%
   \cleardoublepage
   \thispagestyle{empty}%
   \drc@reset@counters
   \let\exercise\exercise@ws
   \let\experiment\experiment@ws
   \@solutionfalse\drc@reset@counters\BODY\vskip2ex
   \@solutiontrue \drc@reset@counters\BODY
   \par
}

%% SIMILAR, FOR STUFF TO BE PRINTED THREE TIMES
\newenvironment{print3}[1][]{%
   \drcschool@print@setup{#1}{3}%
   \drc@add@bookmark
   \drcschool@print@startcollect
   \drc@print@wstitle
  }{%
   \drcschool@print@stopcollect
   \def\@tempa{\vfill\nointerlineskip\hbox to\linewidth{\hss\vrule\@width\paperwidth\@height.4\p@\hss}\nointerlineskip\vfill}%
   \copy\z@\@tempa\copy\z@\@tempa\copy\z@
   \clearpage
   \aftergroup\restoregeometry
}

\NewEnviron{print3+}[1][]{%
   \drcschool@print@setup{#1}{3}%
   \drc@add@bookmark
   \@solutionfalse
   \drcschool@print@startcollect\drc@print@wstitle\BODY\drcschool@print@stopcollect
   \def\@tempa{\vfill\nointerlineskip\hbox to\linewidth{\hss\vrule\@width\paperwidth\@height.4\p@\hss}\nointerlineskip\vfill}%
   \copy\z@\@tempa
   \copy\z@\@tempa\copy\z@
   \restoregeometry% does also \clearpage internally
   \drc@reset@counters
   \@solutiontrue
   \drc@add@bookmark
   \drc@print@wstitle\BODY\clearpage
}

%% SIMILAR, FOR STUFF TO BE PRINTED FOUR TIMES; NO \exercise available (probably I'll use it for small pictures)
\newenvironment{print4}{%
   \cleardoublepage
   \stepcounter{worksheet}%
   \thispagestyle{empty}%
   \newgeometry{margin=1cm}%
   \dimen@=\dimexpr.5\textwidth-1cm\relax
   \setbox\z@=\hbox to\dimen@\bgroup\vbox to\dimexpr.5\textheight-1cm\relax\bgroup\hsize=\dimen@\linewidth\dimen@\@afterindentfalse\@afterheading
  }{%
   \par\vfill\egroup\hss\egroup
   \noindent\copy\z@\hfill\copy\z@
   \par\vfill
   \noindent\copy\z@\hfill\box\z@
   \clearpage
   \aftergroup\restoregeometry
}

\NewEnviron{print4+}{%
   \cleardoublepage
   \stepcounter{worksheet}%
   \thispagestyle{empty}%
   \newgeometry{margin=1cm}%
   \drc@add@bookmark
   \@solutionfalse
   \dimen@=\dimexpr.5\textwidth-1cm\relax
   \setbox\z@=\hbox to\dimen@{\vbox to\dimexpr.5\textheight-1cm\relax{\hsize=\dimen@\linewidth\dimen@\@afterindentfalse\@afterheading\BODY\par\vfill}\hss}%
   \noindent\copy\z@\hfill\copy\z@
   \par\vfill
   \noindent\copy\z@\hfill\box\z@
   \restoregeometry
   \@solutiontrue
   \drc@add@bookmark
   \BODY\clearpage
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% CLUE CARDS
\newcommand{\cluecard}[2]{}

\newcommand{\@cluecard}[2]{%
   \advance\@tempcnta\@ne
   \ifnum\@tempcnta>\drc@nx\relax
      \advance\@tempcnta-\drc@nx\relax
      \advance\@tempcntb\@ne
   \fi
   \@xp\long\@xp\def\csname cluecard@\the\@tempcnta\the\@tempcntb @front\endcsname{\ignorespaces#1}%
   \@xp\long\@xp\def\csname cluecard@\the\@tempcnta\the\@tempcntb @back\endcsname{\ignorespaces#2}%
}

\define@key{drc@cluecards}{layout}{\drc@layout#1\relax}
\define@key{drc@cluecards}{frontfont}{\def\drc@cc@ffont{#1}}
\define@key{drc@cluecards}{backfont}{\def\drc@cc@bfont{#1}}
\define@key{drc@cluecards}{front}{\def\drc@cc@ffont{#1}}
\define@key{drc@cluecards}{back}{\def\drc@cc@bfont{#1}}
\def\drc@layout#1x#2\relax{\def\drc@nx{#1}\def\drc@ny{#2}}%
\newcommand*{\drc@cc@ffont}{\Large\bfseries\centering}
\newcommand*{\drc@cc@bfont}{\raggedright}

\newenvironment{cluecards}[1][2x3]{%
   \def\drc@nx{2}%
   \def\drc@ny{3}%
   \drc@ifkv{#1}{\setkeys{drc@cluecards}{#1}}{\drc@layout#1\relax}%
   \cleardoublepage
   \stepcounter{worksheet}%
   \def\worksheetname{Cluecards}%
   \let\ws@title\@empty
   \drc@add@bookmark
   \newgeometry{margin=1cm}%
   \pagestyle{empty}%
   \@tempcnta\z@
   \@tempcntb\@ne
   \let\cluecard\@cluecard
   \ignorespaces
  }{%
   \drc@dima=\dimexpr(\paperwidth-1cm)/\drc@nx-1cm-2\fboxsep-2\fboxrule\relax
   \drc@dimb=\dimexpr(\paperheight-1cm)/\drc@ny-1cm-2\fboxsep-2\fboxrule\relax
   \parindent\z@
   \def\@tempb{\gdef\@tempb{\vfill}}%
   \foreach \y in {1,...,\drc@ny}{%
      \def\@tempa{\gdef\@tempa{\hfill}}%
      \@tempb
      \foreach \x in {1,...,\drc@nx}{%
         \@tempa
         \fbox{\parbox[c][\drc@dimb][c]{\drc@dima}{\drc@cc@ffont\strut\csname cluecard@\x\y @front\endcsname}}%
      }%
   }%
   \clearpage
   \fboxrule\z@
   \fboxsep3\fboxsep
   \drc@dima=\dimexpr\paperwidth/\drc@nx-2cm-2\fboxsep-2\fboxrule\relax
   \drc@dimb=\dimexpr\paperheight/\drc@ny-2cm-2\fboxsep-2\fboxrule\relax
   \def\@tempb{\gdef\@tempb{\vfill}}%
   \foreach \y in {1,...,\drc@ny}{%
      \def\@tempa{\gdef\@tempa{\hfill}}%
      \@tempb
      \foreach \x in {\drc@nx,...,1}{%
         \@tempa
         \fbox{\parbox[c][\drc@dimb][t]{\drc@dima}{\drc@cc@bfont\strut\csname cluecard@\x\y @back\endcsname}}%
      }%
   }%
   \clearpage\aftergroup\restoregeometry
}

\if@drctikz\else
   \renewenvironment{cluecards}[1][]{%
      \ClassError{drcschool}{No environment {cluecards} without tikz}{Remove the `notikz. option.}%
     }{}%
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% MISCELLANEOUS HELPER MACROS
\newcommand*{\point}[1][]{%
   \par
   \if\relax\detokenize{#1}\relax
      \@hangfrom{\space\textbullet\space}%
   \else
      \hangindent2em
      \noindent\textbf{#1}\space\ignorespaces
   \fi
   \ignorespaces
}
\newcommand*{\V}{{\fboxsep\p@\fbox{V}} }
\newcommand*{\B}{{\fboxsep\p@\fbox{B}} }
\newcommand*{\exercises}[1]{\leavevmode\vtop{\def\\{\cr\ignorespaces}\ialign{\strut##\hfil\cr#1\crcr}}}
\newcommand*{\homework}{HA:~\exercises}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% TAFELANSCHRIEB
% THIS IS EVIL! The same name for a macro and an environment is definitely bad style...
\newcommand*{\TA}{%
   \def\@tempa{TA}%
   \ifx\@tempa\@currenvir
      \@xp\TA@envir
   \else
      \@xp\TA@macro
   \fi
}
\newcommand{\TA@macro}[2][]{\TA@envir[#1]#2\endTA}
\newcommand*{\TAtitlefont}{\scshape\itshape}
\newcommand*{\TA@envir}[1][]{%
   \TA@start
   \noindent
   \llap{\fcolorbox{white}{white}{\textbf{TA}}}%
   \if\relax\detokenize{#1}\relax\else{\TAtitlefont#1}\par\fi
   \noindent\ignorespaces
}
\def\endTA{\vskip2\p@\egroup\egroup\par\addvspace{3\p@}}
\newcommand*{\TA@start}{%
   \setbox\z@=\hbox{\textbf{TA}}%
   \setbox\tw@=\hbox{\textbf{TA} }%
   \dimen@\linewidth
   \advance\dimen@-\wd\tw@
   \@tempdima=\dimexpr(\wd\z@-3\p@)/2\relax
   \@tempdimb=\dimexpr\wd\tw@-(\wd\z@+3\p@)/2\relax
   \par
   \leavevmode
   \hbox\bgroup
   \kern\@tempdima
   \textcolor{gray}{\vrule\@width3\p@}%
   \kern\@tempdimb
   \vtop\bgroup
   \hsize\dimen@
   \linewidth\dimen@
   \textwidth\dimen@
}
\newenvironment{TA*}{\TA@start\noindent\vrule width\z@ height2ex\ignorespaces}{\endTA}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% TESTS/EXAMS
\def\drcschool@subject{FACH}
\def\test@nr{X}
\def\@test@type{KA}
\edef\drcschool@year{%
   \ifcase\month<9
      \number\numexpr\year-1\relax/\number\year
   \else
      \number\year\relax/\number\numexpr\year+1\relax
   \fi
}

\define@key{drc@test}{subject}{\gdef\drcschool@subject{#1}}
\define@key{drc@test}{M}[]{\gdef\drcschool@subject{Mathematik}}
\define@key{drc@test}{Ph}[]{\gdef\drcschool@subject{Physik}}
\define@key{drc@test}{NwT}[]{\gdef\drcschool@subject{NwT}}
\define@key{drc@test}{1}[]{\gdef\test@nr{1}}
\define@key{drc@test}{2}[]{\gdef\test@nr{2}}
\define@key{drc@test}{3}[]{\gdef\test@nr{3}}
\define@key{drc@test}{4}[]{\gdef\test@nr{4}}
\define@key{drc@test}{nr}{\gdef\test@nr{#1}}
\define@key{drc@test}{number}{\gdef\test@nr{#1}}
\define@key{drc@test}{class}{\gdef\@class{#1}}
\define@key{drc@test}{class*}{\def\class@exam{#1}}
\define@key{drc@test}{type}{\gdef\@test@type{#1}}
\define@key{drc@test}{date}{\gdef\@date{#1}}
\define@key{drc@test}{schoolyear}{\gdef\drcschool@year{#1}}
\define@key{drc@test}{background}[gray]{\addbackgroundgrid[#1]}
\define@key{drc@test}{bg}[gray]{\addbackgroundgrid[#1]}
\define@key{drc@test}{v}{\gdef\drcschool@text@v{#1}}
\define@key{drc@test}{version}{\gdef\drcschool@text@v{#1}}
\define@key{drc@test}{variant}{\gdef\drcschool@text@v{#1}}
\define@key{drc@test}{ptspre}{\def\drcschool@pts@pre{#1}}
\define@key{drc@test}{prepts}{\def\drcschool@pts@pre{#1}}
\define@key{drc@test}{ptspost}{\def\drcschool@pts@post{#1}}
\define@key{drc@test}{postpts}{\def\drcschool@pts@post{#1}}
\define@key{drc@test}{logo}{\SetLogo{#1}}

\IfFileExists{logo-wildermuth.png}{\def\drc@logo{\includegraphics[height=1.7\ht\drc@box]{logo-wildermuth}\hfill}}{\def\drc@logo{}}%
\newcommand*{\SetLogo}[1]{%
   \if\relax\detokenize{#1}\relax
      \def\drc@logo{}%
   \else
      \def\drc@logo{\includegraphics[height=1.7\ht\drc@box]{#1}\hfill}%
   \fi
}

\newcommand*{\drc@print@test@headline}{%
   \begin{center}
   \setbox\drc@box=\hbox{\vbox{\hbox{Schuljahr \drcschool@year}\hbox{\@date}}}%
   \leavevmode\drc@logo
   \vbox{%
      \hbox{\class@exam}%
      \hbox{\test@nr. \@test@type\ \drcschool@subject\ifdefined\drcschool@text@v\space---\space\drcschool@text@v\fi}%
   }\hfill\box\drc@box\\[1ex]
   \renewcommand*{\arraystretch}{2}%
   \begin{tabularx}{\linewidth}{|X|X|l|}
   \hline
   \multicolumn{3}{|l|}{Name:}\\
   \hline
   Punkte: \kern5em $\big/$\csname drcschool@test\the\c@worksheet @pts\endcsname&Note:&mündlicher Eindruck:\kern3cm\\
   \hline
   \end{tabularx}%
   \end{center}%
}

\newdimen\drcschool@pts% counts the points in a given test; \dimen instead of \count for decimal points
\newcommand*{\drcschool@pts@pre}{}
\newcommand*{\drcschool@pts@post}{}

\NewEnviron{test}[1][]{%
   % generic setup
   \cleardoublepage
   \stepcounter{worksheet}%
   \drcschool@pts\z@
   \def\class@exam{\classname\space\@class}%
   \setkeys{drc@test}{#1}%
   \let\exercise\exercise@test
   \let\lonelyquestion\lonelyquestion@
   % version for pupils
   \@solutionfalse
   \drc@set@fakepage
   \pagestyle{empty}%
   \drc@reset@counters
   \begingroup
   \let\label\@gobble
   \let\label@in@display\@gobble
   \drc@pdfbookmark[1]{\test@nr. \@test@type\ \drcschool@subject\ifdefined\drcschool@text@v\ -- \drcschool@text@v\fi}{KA.\the\c@worksheet.T}%
   \drc@print@test@headline
   \BODY
   \cleardoublepage
   \endgroup
   % then the solution
   \@solutiontrue
   \drc@set@fakepage
%   \pagestyle{scrheadings}%
   \ifoot{Schuljahr \drcschool@year\ --- \test@nr. \@test@type\ \drcschool@subject\ --- \ifdefined\drcschool@text@v\drcschool@text@v\ ---\ \fi \classname\space\@class}%
%   \ofoot[]{\thepage}%
   \thispagestyle{empty}%
   \drc@reset@counters
   \drc@pdfbookmark[1]{\test@nr. \@test@type\ \drcschool@subject\ifdefined\drcschool@text@v\ -- \drcschool@text@v\fi\ -- \solutionname}{KA.\the\c@worksheet.S}%
   \drc@print@test@headline
   \BODY
   \immediate\write\@auxout{\global\string\@namedef{drcschool@test\the\c@worksheet @pts}{\drc@strip@pt\drcschool@pts}}%
   \clearpage
   \removebackgroundgrid
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% BACKGROUND GRID
\newcommand*{\drcschool@bg}{\relax}
\@ifundefined{AddToHook}{%
   \RequirePackage{everypage}%
   \AddEverypageHook{\drcschool@bg}%
  }{% if newer LaTeX
   \AddToHook{shipout/background}{\drcschool@bg}%
}
\newcommand*{\removebackgroundgrid}{\let\drcschool@bg\relax}
\newcommand*{\addbackgroundgrid}[1][]{\def\drcschool@bg{\drcschool@bg@grid{#1}}}
\if@drctikz
   \newcommand*{\drcschool@bg@grid}[1]{%
      \tikz[remember picture,overlay]{\draw[gray,step=5mm,#1](current page.south west)grid(current page.north east);}%
   }
\else
   \newcommand*{\drcschool@bg@grid}[1]{%
      \ClassWarningNoLine{drcschool}{Sorry, no background grid available without the tikz package.\MessageBreak
                                     Consider removing the class option `notikz'.}%
   }
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% TIKZ & PGFPLOTS
\newenvironment{plot}[1][]{%
   \ClassError{drcschool}{No environment {plot} without package pgfplots}
                         {Either load the class with option `pgfplots'\MessageBreak
                          or load pgfplots manually.}%
  }{}

\drcschool@pgfplots{% \@gobble or \@firstofone
    \pgfplotsset{%
       compat=1.16,% not the newest but decent
       grid style=gray,%
       axis line style=thick,%
       no markers,%
       x=1cm,%
       y=1cm,%
       xlabel style={right},%
       ylabel style={right},%
       xlabel={$x$},%
       ylabel={$y$},
       grid=both,%
       samples=50,%
       axis lines=middle,%
       xtick={-10,-9,...,10},%
       minor x tick num={1},%
       ytick={-10,-9,...,10},%
       minor y tick num={1},%
       major tick style={very thick,black},%
       minor tick style={draw=none}
    }
}

\AtBeginDocument{\@ifpackageloaded{pgfplots}{\renewenvironment{plot}[1][]{\tikzpicture\axis[#1]}{\endaxis\endtikzpicture}}{}}

\if@drctikz\else
   \def\tikzset{\@gobble}
   \def\usetikzlibrary{\@gobble}
\fi

\tikzset{>=latex}
\usetikzlibrary{arrows.meta,patterns,calc,angles}

\newcommand*{\right@ngle}{}
\newcommand*{\right@ngl@}{}
\newcommand*{\rightangle}[1][]{\right@ngle{#1}}% usage: \rightangle[options](coord){start angle}[radius]
\def\right@ngle#1(#2)#3{\@ifnextchar[{\right@ngl@{#1}{#2}{#3}}{\right@ngl@{#1}{#2}{#3}[.4]}}
\def\right@ngl@#1#2#3[#4]{% #1= tikz options, #2 = point, #3 = start angle, #4 = radius
   \draw[shift only,#1] (#2)++(#3:#4) arc[start angle=#3, delta angle=90, radius = #4];
   \fill[shift only,#1] (#2)++(#3+45:#4/2) circle(.04);
}

\tikzset{
  pics/rightangle/.style = {
    setup code  = \tikz@lib@angle@parse#1\pgf@stop,
    code = {},
    background code = \tikz@lib@angle@background#1\pgf@stop,
    foreground code = \tikz@lib@right@angle@foreground#1\pgf@stop,
  }
}%

\def\tikz@lib@right@angle@foreground#1--#2--#3\pgf@stop{%
  \path [name prefix ..] [pic actions, fill=none, shade=none]
  ([shift={(\tikz@start@angle@temp:\tikz@lib@angle@rad pt)}]#2.center)
    arc [start angle=\tikz@start@angle@temp, end
        angle=\tikz@end@angle@temp, radius=\tikz@lib@angle@rad pt];
  \fill[name prefix ..] ([shift={({.5*\tikz@end@angle@temp+.5*\tikz@start@angle@temp}:.55*\tikz@lib@angle@rad pt)}]#2.center)circle(1pt);
  \ifx\tikzpictext\relax\else%
    \def\pgf@temp{\node()[name prefix ..,at={([shift={({.5*\tikz@start@angle@temp+.5*\tikz@end@angle@temp}:\pgfkeysvalueof{/tikz/angle eccentricity}*\tikz@lib@angle@rad pt)}]#2.center)}]}
    \@xp\pgf@temp\@xp[\tikzpictextoptions]{\tikzpictext};%
  \fi
}

\newcommand*{\vecsum}{\@ifstar{\def\drc@next{\IfSolutionT}\vec@sum}{\def\drc@next{\@firstofone}\vec@sum}}
\newcommand*{\vec@sum}[1][]{\vec@sum@{#1}}
\def\vec@sum@#1(#2)(#3){\@ifnextchar[{\vec@sum@@{#1}{#2}{#3}}{\vec@sum@@{#1}{#2}{#3}[\@empty]}}
\def\vec@sum@@#1#2#3[#4];{%
   \fill[#1](0,0)circle(.05);
   \path[#1](#2)++(#3)coordinate(S) ;
   \drc@next{\draw[dashed,#1] (#2)--(S)--(#3) ;}
   \draw[<-,#1] let \p1 = (#2) in (#2) -- (0,0) node[sloped,above,midway]{\footnotesize\vsl@{#4}};
   \draw[<-,#1] let \p1 = (#3) in (#3) -- (0,0) node[sloped,below,midway]{\footnotesize\vsl@{#4}};
   \drc@next{\draw[<-,#1] let \p1 = (S) in (S) -- (0,0) node[sloped,below,midway]{\footnotesize\vsl@{#4}}};
}
\newcommand*{\vsl@}[1]{%
   \ifx\@empty#1\relax\else
   \pgfmathparse{veclen(\x1,\y1)/1cm}%
   \pgfmathroundtozerofill{\pgfmathresult}%
   \drc@decimal\pgfmathresult\,#1
   \fi
}

\newcommand*{\grid}{\drc@grid} % this is redefined in fillable worksheets
\newcommand*{\drc@grid}[1][]{\noindent\@ifnextchar({\drc@grid@{#1}}{\drc@grid@{#1}(*,3.5)}}
\long\def\drc@grid@#1(#2,#3)#4{% #1=pre-content (always there); #2,#3=width/height; #4=content
   \def\@tempa{#2}%
   \def\@tempb{*}%
   \def\@tempc{+}%
   \ifx\@tempa\@tempb
      \@tempdima\linewidth
      \@tempdimb.5cm
      \divide\@tempdima\@tempdimb
      \@tempdima\number\@tempdima cm
      \divide\@tempdima\tw@
   \else
      \ifx\@tempa\@tempc
         \@tempdima\linewidth
         \advance\@tempdima-.4\p@
      \else
         \@defaultunits\@tempdima#2cm\relax\@nnil
      \fi
   \fi
   \@defaultunits\@tempdimb#3cm\relax\@nnil
   \leavevmode\vrule\@depth\@tempdimb\@width\z@
   \tikz[baseline=(text.base)]{%
      \draw[gray,step=.5](0,0)grid(\@tempdima,-\@tempdimb);
      \node[align=flush left,text width=\dimexpr\@tempdima-2mm\relax,inner sep=\z@,anchor=north west] (text) at (0.1,0) {\strut{#1}\if@solution#4\fi} ;
   }%
}
% basically the same thing but only with horizontal lines
\newcommand*{\lines}{\drc@lines} % this is redefined in fillable worksheets (TODO)
\newcommand*{\drc@lines}[1][]{\noindent\@ifnextchar({\drc@lines@{#1}}{\drc@lines@{#1}(*,3.5)}}
\long\def\drc@lines@#1(#2,#3)#4{% #1=pre-content (always there); #2,#3=width/height; #4=content
   \def\@tempa{#2}%
   \def\@tempb{*}%
   \def\@tempc{+}%
   \ifx\@tempa\@tempb
      \@tempdima\linewidth
      \advance\@tempdima-.4\p@
   \else
      \ifx\@tempa\@tempc
         \@tempdima\linewidth
         \advance\@tempdima-.4\p@
      \else
         \@defaultunits\@tempdima#2cm\relax\@nnil
      \fi
   \fi
   \@defaultunits\@tempdimb#3cm\relax\@nnil
   \leavevmode\vrule\@depth\@tempdimb\@width\z@
   \tikz[baseline=(text.base)]{%
      \draw[gray,ystep=.5,xstep=0](0,0)grid(\@tempdima,-\@tempdimb);
      \node[align=flush left,text width=\dimexpr\@tempdima-2mm\relax,anchor=north west,inner sep=\z@,execute at begin node=\baselineskip5mm\relax] (text) at (0.1,0.4) {\strut{#1}\if@solution#4\fi} ;
   }%
}

\if@drctikz\else
   \long\def\drc@grid@#1(#2,#3)#4{\ClassError{drcschool}{\string\grid\space unavailable without tikz}{Remove the `notikz' option.}}
   \long\def\drc@lines@#1(#2,#3)#4{\ClassError{drcschool}{\string\lines\space unavailable without tikz}{Remove the `notikz' option.}}
\fi
% CALCULATOR ICONS
\newcommand*{\calculator}{\leavevmode\calc@icons{}}%
\newcommand*{\nocalculator}{\leavevmode\calc@icons{\textcolor{black}{\linethickness\p@\Line(0,-.1)(.7,.9)\Line(.7,-.1)(0,.9)}}}%
\newcommand*{\calc@icons}[1]{%
   \begingroup
   \unitlength2ex\relax
   \@picture(.7,1)(0,0)%
   \color{gray}%
   \put(.35,.4){{\let\pIIe@strokeGraph\pIIe@fillGraph\oval[.1](.7,1)}}%
   \color{white}%
   \polygon*(.1,.0)(.2,.0)(.2,.1)(.1,.1)%
   \polygon*(.1,.2)(.2,.2)(.2,.3)(.1,.3)%
   \polygon*(.1,.4)(.2,.4)(.2,.5)(.1,.5)%
   \polygon*(.3,.0)(.4,.0)(.4,.1)(.3,.1)%
   \polygon*(.3,.2)(.4,.2)(.4,.3)(.3,.3)%
   \polygon*(.3,.4)(.4,.4)(.4,.5)(.3,.5)%
   \polygon*(.5,.0)(.6,.0)(.6,.1)(.5,.1)%
   \polygon*(.5,.2)(.6,.2)(.6,.3)(.5,.3)%
   \polygon*(.5,.4)(.6,.4)(.6,.5)(.5,.5)%
   \polygon*(.1,.6)(.6,.6)(.6,.8)(.1,.8)%
   #1%
   \endpicture
   \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% VIERFELDERTAFEL (actually defined in drcmath but I need to make it solution aware)
\providecommand*{\drc@CT@cr}{}

\providecommand*{\drc@CT@scan}[1]{%
   \setbox\tw@=\hbox{\m@th$#1$\copy\strutbox}%
   \ifdim\wd\tw@>\drc@gdima\global\drc@gdima\wd\tw@\fi
   \ifdim\ht\tw@>\drc@gdimb\global\drc@gdimb\ht\tw@\fi
   \ifdim\dp\tw@>\drc@gdimc\global\drc@gdimc\dp\tw@\fi
}

\providecommand*{\crosstable}{}
\renewcommand*{\crosstable}[2][A,B]{%
   \bgroup
   \gdef\drc@CT@cr{\cr\noalign{\hrule}\gdef\drc@CT@cr{\cr\noalign{\hrule\@height.6\p@}}}%
   \m@th
   \def\@tempc##1,##2,##3\relax{\def\@tempa{##1}\def\@tempb{##2}}%
   \@tempc#1,,\relax
   \global\drc@gdima\z@
   \global\drc@gdimb\z@
   \global\drc@gdimc\z@
   \drc@CT@scan\@tempa
   \drc@CT@scan\@tempb
   \setbox\z@=\vbox{\@solutiontrue\let\\=\cr\ialign{&\drc@CT@scan{##}\cr#2\crcr}}%
   \global\advance\drc@gdima2\arraycolsep
   \setbox\@arstrutbox\hbox{\vrule\@height1.2\drc@gdimb\@depth1.2\drc@gdimc\@width\z@}%
   \vcenter{\hbox{%
     \vbox{\ialign{\@arstrut\hbox to\drc@gdima{\hfil$##$\hfil}\cr
           \cr\noalign{\hrule\@height.7\p@}\@tempa\cr\noalign{\hrule}\bar\@tempa\cr\noalign{\hrule\@height.7\p@}\strut\crcr}}%
     \vbox{%
        \def\\{\drc@CT@cr}%
        \ialign{%
           \vrule\@width.7\p@\@arstrut\hb@xt@\drc@gdima{\hfil$##$\hfil}&
           \vrule            \@arstrut\hb@xt@\drc@gdima{\hfil$##$\hfil}&
           \vrule\@width.7\p@\@arstrut\hb@xt@\drc@gdima{\hfil$##$\hfil}\cr
           \@tempb&\bar\@tempb&\strut\cr\noalign{\hrule\@height.7\p@}%
           #2\crcr
        }}%
     }}%
   \egroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% TYPESETTING UTILITIES, i.e. stuff which turned out to be useful
\newcommand*{\wrap}[2][l]{%
   \par
   \setbox\z@=\vtop{\kern-\fontcharht\font`\A\hbox{\ignorespaces#2\unskip}}%
   \hangafter-\numexpr\dp\z@/\baselineskip+1\relax
   \hangindent\if#1r-\fi\dimexpr\wd\z@+1em\relax
   \noindent
   \dp\z@\z@
   \hbox to\z@{\if#1r\hbox to\linewidth{\hfill\box\z@}\hss\else\hss\box\z@\kern1em\fi}%
   \@ifstar{\kern\parindent\ignorespaces}{\ignorespaces}%
}

\newcommand*{\wraptikz}{\@ifnextchar[{\wrap@tikz}{\wrap@tikz[]}}
\def\wrap@tikz[#1]{\@ifnextchar[{\wrap@tikz@{#1}}{\wrap@tikz@{#1}[l]}}
\def\wrap@tikz@#1[#2]#3{% #1 = tikz options, #2=r/l, #3=tikz code
   \setbox\z@=\vtop{\kern-\fontcharht\font`\A\hbox{\begin{tikzpicture}[#1]#3\end{tikzpicture}}}%
   \par
   \hangafter-\numexpr\dp\z@/\baselineskip+2\relax
   \hangindent\if#2r-\fi\dimexpr\wd\z@+1em\relax
   \noindent
   \dp\z@\z@
   \hbox to\z@{\if#2r\hbox to\linewidth{\hfill\box\z@}\hss\else\hss\box\z@\kern1em\fi}%
   \@ifstar{\kern\parindent\ignorespaces}{\ignorespaces}%
}
\if@drctikz\else
   \def\wrap@tikz@#1[#2]#3{\ClassWarningNoLine{drcschool}{Macro \string\wraptikz\space unavailable without tikz}}
\fi
\newcommand*{\drcput}[1][r]{%
   \@killglue
   \@expandtwoargs\drc@put{\if#1r\relax\else\hss\fi}{\if#1l\relax\else\hss\fi}%
}
\def\drc@put#1#2(#3,#4)#5{%
   \hb@xt@\z@{\@defaultunitsset\dimen@{#3}\unitlength\kern\dimen@\vbox to\z@{\vss\hb@xt@\z@{#1#5#2}\@defaultunitsset\dimen@{#4}\unitlength\kern\dimen@}\hss}%
   \ignorespaces
}

\def\drc@minipage{\@ifnextchar[\drc@iminipage{\drc@iiiminipage c\relax[s]}}
\def\drc@iminipage[#1]{\@ifnextchar[{\drc@iiminipage{#1}}{\drc@iiiminipage{#1}\relax[s]}}
\def\drc@iiminipage#1[#2]{\@ifnextchar[{\drc@iiiminipage{#1}{#2}}{\drc@iiiminipage{#1}{#2}[#1]}}
\def\drc@iiiminipage#1#2[#3]#4{\@iiiminipage{#1}{#2}[#3]{\dimexpr#4-2\fboxsep\relax}}
\newenvironment{colorminipage}[1]{%
   \def\drc@colorbox{\colorbox{#1}}%
   \setbox\tw@=\hbox\bgroup\drc@minipage
  }{%
   \endminipage\egroup
   \drc@colorbox{\box\tw@}%
}
\newenvironment{graybox}{%
   \def\drc@colorbox{\colorbox{lightgray}}%
   \setbox\tw@=\hbox\bgroup\drc@minipage
  }{%
   \endminipage\egroup
   \drc@colorbox{\box\tw@}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% CONFIGURATION FILE(S)
\let\drc@loaded@sco\@empty
\newcommand*{\LoadSchoolOptionFile}[1]{%
   \ifx\drc@loaded@sco\@empty
      \IfFileExists{#1.sco}{\input{#1.sco}\def\drc@loaded@sco{#1}}{\ClassWarning{drcschool}{Sorry, I can't find #1.sco}}%
   \else
      \ClassWarning{drcschool}{I won't load #1.sco because you've already loaded the school option file \drc@loaded@sco.sco}%
   \fi
}
% Load a personal configuration file if available
\IfFileExists{drcschool.cfg}{\input{drcschool.cfg}\ClassInfo{drcschool}{Loading configuration file drcschool.cfg}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% HYPERREF

% first some safety definitions; these must be always defined, in case that one
% loads hyperref in the preamble
\newcommand*{\theHworksheet}{\number\c@worksheet.\if@solution S\else T\fi}
\newcommand*{\theHexercise}  {\theHworksheet.\number\c@exercise}
\newcommand*{\theHexperiment}{\theHworksheet.\number\c@experiment}
\newcommand*{\theHquestion}  {\theHexercise.\number\c@question}
\newcommand*{\theHequation}  {\theHworksheet.\number\c@equation}
\newcommand*{\theHfigure}    {\theHworksheet.\number\c@figure}
\newcommand*{\theHtable}     {\theHworksheet.\number\c@table}
\newcommand*{\theHfootnote}  {\theHworksheet.\number\c@footnote}

\drcschool@hyperworksheet % this is either \endinput or \relax

\RequirePackage{hyperref}

% Labels for the different forms are automatically generated
% by increasing the counter drc@HN (=Hyperref Name). I need the
% LaTeX version such that e.g. tabularx does not uselessly
% increase it.
\newcounter{drc@HN}

% I don't want the `names', so I just absorb them into these helper macros.
% usage: \drc@TextField{pdf options}
\newcommand*{\drc@TextField}[1]{%
   \stepcounter{drc@HN}%
   \edef\drc@next{[borderwidth=0,backgroundcolor=lightgray,#1]{drc@HN\the\c@drc@HN}}%
   \expandafter\TextField\drc@next
}
% usage: \drc@ChoiceMenu{pdf options}{ list of possible choices }
\newcommand*{\drc@ChoiceMenu}[1]{%
   \stepcounter{drc@HN}%
   \edef\drc@next{[radio,radiosymbol=\noexpand\ding{108},height=.8em,width=.8em,#1]{drc@HN\the\c@drc@HN}}%
   \expandafter\ChoiceMenu\drc@next
}
% usage: \drc@CheckBox{pdf options}
\newcommand*{\drc@CheckBox}[1]{%
   \stepcounter{drc@HN}%
   \edef\drc@next{[height=.8em,width=.8em,#1]{drc@HN\the\c@drc@HN}}%
   \expandafter\CheckBox\drc@next
}

% user version
%\newcommand*{\RadioButtonList}[2][]{%
%   \stepcounter{drc@HN}%
%   \edef\drc@next{[radio,radiosymbol=\noexpand\ding{108},height=.8em,width=.8em,#1]{drc@HN\the\c@drc@HN}}%
%   \expandafter\ChoiceMenu\drc@next{#2}%
%}

% hyper version of fillboxes
\newcommand*{\fillbox@hy}{%
   \relax
   \begingroup
   \fboxrule\z@
   \ifmmode
      \@xp\fillbox@m@hy
   \else
      \@xp\fillbox@t@hy
   \fi
}

\newcommand*{\fillbox@t@hy}[2][2]{%
   \leavevmode
   \setbox\z@=\hbox{\vrule\@depth.5ex\@width\z@#2}%
   \Ifdimen{#1}{\setbox\drc@box=\hb@xt@#1}{\setbox\drc@box=\hb@xt@#1\wd\z@}{\hfil\unhbox\z@\hfil}%
   \IfSolutionTF{%
       \fcolorbox{lightgray}{lightgray}{\copy\drc@box}}%
      {\raise-2\p@\hbox{\drc@TextField{align=1,width=\the\wd\drc@box,height=\the\dimexpr\ht\drc@box+\dp\drc@box\relax}}}%
   \endgroup
}
\newcommand*{\fillbox@m@hy}[2][1]{%
   \binrel@{#2}%
   \fboxsep1.5\p@
   \binrel@@{\mathpalette{\fillbox@m@hy@{#1}}{#2}}%
   \endgroup
}
\newcommand*{\fillbox@m@hy@}[3]{% #1=width  #2=\...style  #3=arg
   \setbox\z@\hbox{$\m@th#2#3$}%
   \Ifdimen{#1}{\setbox\drc@box=\hb@xt@#1}{\setbox\drc@box=\hb@xt@#1\wd\z@}{\hfil\unhbox\z@\hfil}%
   \IfSolutionTF{\fcolorbox{lightgray}{lightgray}{\copy\drc@box}}{%
   \hbox{\kern\p@
   \drc@TextField{align=1,%
                  width=\the\dimexpr\wd\drc@box+2pt\relax,%
                  height=\the\dimexpr\wd\drc@box+2pt\relax,%
                  charsize=\ifx#2\scriptscriptstyle\ssf@size\else\ifx#2\scriptstyle\sf@size\else\tf@size\fi\fi pt%
                  }%
   \kern\p@}%
   }%
}

% hyper version of \fillhere; no difference starred/unstarred
\newcommand*{\fillhere@hy}{\@ifstar\fillhere@hy@\fillhere@hy@}
\newcommand*{\fillhere@hy@}[2][2]{%
   \leavevmode
   \setbox\z@=\hbox{\vrule\@depth.5ex\@width\z@#2}%
   \Ifdimen{#1}{\setbox\drc@box=\hb@xt@#1}{\setbox\drc@box=\hb@xt@#1\wd\z@}{\hfil\unhbox\z@\hfil}%
   \IfSolutionTF{\underline{\box\drc@box}}{\raise-2\p@\hbox{\drc@TextField{align=1,width=\the\wd\drc@box,height=\the\dimexpr\ht\drc@box+\dp\drc@box\relax}}}%
}

% hyper version of true/false table
\newenvironment{TF@hy}[1][\linewidth]{%
   \dimen@2\tabcolsep
   \advance\dimen@\arrayrulewidth
   \setbox\z@=\hbox{wahr\kern\dimen@ falsch}%
   \def\true{&\IfSolutionTF{\radiobutton@*&\radiobutton@}{\multicolumn{2}{c}{\hbox{\drc@ChoiceMenu{}{\mbox{}=t,\mbox{\qquad}=f}}}}\\}%
   \def\false{&\IfSolutionTF{\radiobutton@&\radiobutton@*}{\multicolumn{2}{c}{\hbox{\drc@ChoiceMenu{}{\mbox{}=t,\mbox{\qquad}=f}}}}\\}%
   \par\medskip\noindent
   \renewcommand*{\tabularxcolumn}[1]{b{##1}}% local redefinition
   \tabularx{#1}{X*{2}{>{\centering\arraybackslash}b{3em}}}%
   \toprule
    & wahr & falsch \\
   \midrule[\heavyrulewidth]
 }{\bottomrule\endtabularx\par\medskip\@endparenv}

% hyper version of checkboxes and radio buttons
\newcommand*{\checkbox@hy}{\@ifstar{\mbox{\drc@CheckBox{}}}{\mbox{\drc@CheckBox{}}}}
% radiobuttons are trickier, since they need a unique identifier to work together
\newcommand*{\drc@RB}{%
   \edef\drc@next{[radio,radiosymbol=\noexpand\ding{108},height=.8em,width=.8em]{\@currenvir\the\c@worksheet.\the\c@exercise.\the\c@question}}%
   \expandafter\ChoiceMenu\drc@next
}
\newcommand*{\radiobutton@hy}{\@ifstar{\mbox{\drc@RB{=t}}}{\mbox{\drc@RB{=f}}}}

% hyper version of grid
\newcommand*{\drc@grid@hy}[1][]{\noindent\@ifnextchar({\drc@grid@hy@{#1}}{\drc@grid@hy@{#1}(*,3.5)}}
\long\def\drc@grid@hy@#1(#2,#3)#4{% #1=pre-content (IGNORED IN HYPER VERSION); #2,#3=width/height; #4=content
   \def\@tempa{#2}%
   \def\@tempb{*}%
   \def\@tempc{+}%
   \ifx\@tempa\@tempb
      \@tempdima\linewidth
   \else
      \ifx\@tempa\@tempc
         \@tempdima\linewidth
      \else
         \@defaultunits\@tempdima#2cm\relax\@nnil
      \fi
   \fi
   \@defaultunits\@tempdimb#3cm\relax\@nnil
   \leavevmode\vrule\@depth\@tempdimb\@width\z@
   \lower\dimexpr\@tempdimb-3.5mm\relax\hbox{\drc@TextField{align=0,width=\@tempdima,height=\@tempdimb,multiline}}%
}

% replace standard worksheet macros/envs by their hyperref version
\newcommand*{\drc@hyperworksheet@setup}{%
   \def\fillhere{\fillhere@hy}%
   \def\fillbox{\fillbox@hy}%
   \let\TF\TF@hy
   \let\endTF\endTF@hy
   \def\grid{\IfSolutionTF\drc@grid\drc@grid@hy}%
   \def\lines{\IfSolutionTF\drc@grid\drc@grid@hy}%
   \def\checkbox{\IfSolutionTF\checkbox@\checkbox@hy}%
   \def\radiobutton{\IfSolutionTF\radiobutton@\radiobutton@hy}%
   \let\LayoutTextField\@secondoftwo
   \let\LayoutChoiceField\@secondoftwo
   \let\LayoutCheckField\@secondoftwo
}

\NewEnviron{hyperworksheet}[1][]{%
   %generic setup
   \cleardoublepage
   \drc@worksheet@setup{#1}%
   \drc@hyperworksheet@setup
   % first the version for pupils
   \@solutionfalse
   \drc@set@fakepage
   \thispagestyle{plain}%
   \drc@reset@counters
   \begingroup
   \let\label\@gobble
   \let\label@in@display\@gobble
   \drc@add@bookmark
   \if@twocolumn
      \@topnewpage[\drc@print@wstitle]%
   \else
      \drc@print@wstitle
   \fi
   \BODY
   \clearpage
   \removebackgroundgrid
   \ifnum\the@fakepage>\tw@\cleardoublepage\fi
   \endgroup
   % then the version with solutions
   \@solutiontrue
   \drc@set@fakepage
   \thispagestyle{plain}%
   \drc@reset@counters
   \drc@add@bookmark
   \if@twocolumn
      \@topnewpage[\drc@print@wstitle]%
   \else
      \drc@print@wstitle
   \fi
   \BODY
   \clearpage
   \drc@ws@end
   \removebackgroundgrid
}

\newenvironment{hyperworksheet*}[1][]{%
   \cleardoublepage
   \drc@worksheet@setup{#1}%
   \drc@hyperworksheet@setup
   \@solutionfalse
   \drc@set@fakepage
   \thispagestyle{plain}%
   \drc@reset@counters
   \drc@add@bookmark
   \if@twocolumn
      \@topnewpage[\drc@print@wstitle]%
   \else
      \drc@print@wstitle
   \fi
  }{%
   \clearpage
   \drc@ws@end
   \removebackgroundgrid
}

\endinput

% DUMP

% Check boxes might also be drawn with pict2e but importing glyphs from fontawesome is much more efficient.
%\newcommand*{\pIIe@checkbox}{\leavevmode\@ifstar{\pIIe@checkbox@{\pIIe@checkbox@@}}{\pIIe@checkbox@{}}}
%\newcommand*{\pIIe@checkbox@}[1]{%
%   \begingroup
%   \unitlength1.48ex
%   \begin{picture}(1,1)%
%   \linethickness{.75pt}%
%   \put(.5,.42){\oval[.15](1,1)}%
%   #1%
%   \end{picture}%
%   \endgroup
%}
%\newcommand*{\pIIe@checkbox@@}{%
%   \roundjoin
%   \roundcap
%   {\color{white}\linethickness{2.8pt}\polyline(.25,.45)(.5,.2)(1.1,.8)}%
%   \linethickness{1.8pt}\polyline(.25,.45)(.5,.2)(1.1,.8)%
%}