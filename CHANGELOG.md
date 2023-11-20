# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project tries to adhere to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2023-11-20 [v1.3.0]
### Added
- Made skips before and after exercise heading customizable.
- Exercise titles can now be run-in or hanging.
### Changed
- Changed a bit the control points of bezier curves in medium difficulty symbol.

## 2023-11-13 [v1.2.2]
### Fixed
- The new implementation of `\radiobutton` had a bug (I forgot a
  `\if@solution`, the correct choice was always shown).
- Changed a bit the definition of `\deadlysymbol` (it wasn't
  smooth at the top).

## 2023-11-07 [v1.2.1]
### Changed
The difficulty symbols, radio buttons, and calculator symbols are now
drawn with `pict2e` instead of `tikz`, independent of whether `tikz`
is loaded or not. This guarantees same-looking symbols no matter what
class option is loaded. (BTW, benchmark tests show that the `pict2e`
variants are roughly 10 times faster.)

## 2023-11-05 [v1.2.0]
### Added
- Exercises can now be also `\harder` or `\deadly` `:-)`
- In fact, there is a generic macro `\exercisesymbol` which puts whatever
  one wants in front of the exercise heading, not only one of the
  difficulty symbols.
- Added *mild* support for two columns. Basically, `worksheet` and
  `worksheet*` (as well as their `hyper...` variants) set the title
  always in one column even if two columns are used.
- Checks for nested or multiple solutions.
- Added possibility of not loading `tikz` and `pgfplots`.
- Added keys for customization of the `{tabular}` behind the
  `{questions*}` environment.
- Added `\lonelyquestion`.
### Changed
- Changed internal coding of boolean keys, now based on the kernel
  macro `\in@` intead of KoMa's `\Ifstr`.
- Reimplemented `{matching}` using the kernel's `\int_random:nn`
  instead of `\pgfmathrandominteger` (faster).
- I was redefining math figures by hand but it turns out `newtxsf`
  has a (not really well-documented) option `noSTIXops` for that.
- Removed `nosymbolsc` option from `newtxsf`. Since the default
  setup is a complete font setup and both AMS sybols are summarized
  in a single math family there is no need to spare a (otherwise
  precious) math alphaet.
- Renamed a couple of internal macros.
### Fixed (?)
- Fixed a small bug in the handling of lists `{questions}` and `{hint}`.
- Horizontal-style questions were partly missing the check for nested questions.
- Fixed spurious space in `\qst@pts`.
- Missing `%` in `\crosstable`. (After `\ialign{` so not *really*
  necessary but better safe than sorry.)
- The simplified code for fake page numbering introduced in [v1.1.0] was
  actually buggy and led to `hyperref` warnings which I clearly missed.
- The difficulty symbols for hard/harder used `\filldraw` *without* the
  option `thick`, leading to slightly smaller symbols.

## 2023-10-15 [v1.1.0]
(From now on *actually* sticking to semantic versioning: additions should increase
the minor version number, which I hadn't done in v1.0.3)
### Added
Added a key `solution` for worksheets. Irrelevant for `{worksheet}` but maybe useful for `{worksheet*}`.
### Fixed
- Simplified code for fake page numbering.
- Correspondingly changed a bit the handling of headers/footers.
- Missing `%` in `{questions}` (actually irrelevant *there* but I prefer it anyway).

## 2023-10-13 [v1.0.6]
- Made `\drc@header` self-contained.
- Added check for nested questions to all question-like environments, not only `{questions}`.

## 2023-10-10 [v1.0.5]
I had a strange, useless assignment in `{cluecards}`.
Possibly a relic of something I ended not using.

## 2023-10-08 v1.0.4
Removed history (can be now found in changelog).

## 2023-10-06 v1.0.3
- The macro `\the@fakepage` was redefined each time the fake page number was being reset, which was quite pointless.
- Added `{hint}` environment (copied from `unituemnf`).
- Further cosmetic changes.

## 2023-09-23 v1.0.2
- I had a small bug in `\grid` and `\lines` because of the missing `inner sep=\z@`.
- Fixed also a mismanagement of `\starredquestionmark`.

## 2023-09-22 v1.0.1
- Added `\lines`, similar to `\grid`.
- Added horizontal versions of `{multchoice}` and `{multresponse}`.

## 2023-08-30 v1.0.0
Wow, after sixteen months and two weeks of school and two more weeks of
heavy TeXing I think I've finally got something acceptable which I can denote
as a version v1.0... From now on, version numbers will use the more customary
numbering v[major].[minor].[patch] instead of the strange number/letter
combinations I've been using.

There has been some major code rewriting and a lot of new features have been
introduced. Let us see how many bugs have crept in... :-)

Here a short list of changes, in no particular order:
- Biggie: Added fillable pdf worksheets and in general `hyperref` support.
- I actually screwed up `\label`s, as `amsmath` redefines `\label` at the
  start of every environment. Right now I've fixed this, but every
  package redefining `\label` will break something. In the long run I
  guess I'll have to put the version with solution first and the
  version without after.
- `\drcschool@fix@time` was badly coded: first the test if more than
  119 minutes, then the test for more than 59 minutes. Larger time
  spans were not checked (admittedly, they would never occur...).
  Anyway, re-coded: the test is now performed recursively.
- Fixed indentation at start of worksheets of all sorts by placing
  the appropriate `\@afterindentfalse\@afterheading`.
- There was still a warning about a font size substitution, though
  I never really understood where it came from. I am pretty sure it
  was due to `drcmath` doing something with fonts (someday I'll have to
  rewrite that...) but I couldn't pinpoint the issue. Rearranging
  packages seems to have silenced the warning, but I still would like
  to understand what the freaking problem was...
- Completely recoded the `{schedule}`. Now one can define different
  "styles" with different columns and related macros. We'll see
  how many bugs I introduced...
- Added a `{schedule*}` which does not start a new page.
  (Mainly for the documentation...)
- The parentheses around the exercises' titles can be changed.
- No `{experiment}` environment any more, but an `\experiment` macro
  with an independent counter which can be used together with `\exercise`
  within a `{worksheet}`.
- Removed the `\sectionformat`-related things. I was using a `\section` for
  exercises, but this would have collided with "normal" sections. Not
  that I ever used them, but better safe than sorry. Now the counters
  `\c@exercise` and `\c@experiment` are defined separately, and
  `\exercise`/`\experiment` use a modified copy of `\@startsection.`
- The strange `\vskip-\baselineskip` I had in the `\content` of `{schedule}`
  was indeed due to a bug in `longtable` (well... David wouldn't
  agree...). I kind of fixed that, though that required some change
  in some other places. Results with older documents will result in
  slightly different vertical spacing, there is no way to avoid that.

## 2023-07-31 v0.4d / v0.4e
These versions never really existed. They lasted a couple of days
before I moved to the following version.

## 2023-06-28 v0.4c
- Completely recoded `\crosstable`.
- Added global scratch length registers.

## 2023-06-23 v0.4b
- In version v0.3b I defined the `{questions}` environment from scratch
  as a list, instead of it being a wrapper around `{compactenum}`. In
  doing so I accidentally moved the saving of the current question
  number to the start code instead of the end code. This didn't
  interact with consecutive `{questions}` (since I use now global
  counters) but screwed the check that the number of answers was the
  same as the number of questions in the solution. In fact, the old
  global macro `\drcschool@last@qst` (the last remnant of the `unituemnf`
  class) isn't needed any more, so I simply deleted it.
- Added the name `\starredexercisename`.
- Changed the tikz pic rightangle: it does /not/ draw a 90 degree
  angle but only prints the dot in the middle.

## 2023-06-15 v0.4a
Added starred version of `\shortsolution`.

## 2023-05-23 v0.4
- Completely changed the individual configurations. Now the class
  always checks whether a configuration file `drcschool.cfg` exists,
  and loads it. The .sco files can still be manually loaded but
  not as class option any more but rather with `\LoadSchoolOptionFile`.
- Added optional parameter to `\drcput`.

## 2023-05-19 v0.3e
Upps, small bug: When passing KoMa options to `\documentclass` (which
I haven't done in ages) there was the problem that `\@xp` wasn't
defined yet, since I still had to load `amsgen` at that moment. Fixed.

## 2023-05-17 v0.3d
- When using a font change command in the worksheets, the first
  paragraph was actually badly spaced. I need a further
  `\normalsize` at the start of the environments.
  Not sure why, though.
- I actually had a bug: the check on the first char of `\grid(,){}`
  was `\if#2*`, so if `#2` was e.g. `11`, the test would have been true.
  Using `\if*#2` would've been better, but then some nonsense like
  `*xxx` would have also given a false positive. The test has been
  now re-implemented by using `\ifx`. Should be somewhat safer.

## 2023-05-13 v0.3c
- Cosmetic changes.
- Added `{TA*}`

## 2023-05-12 v0.3b
- Cosmetic changes in `\wrap`.
- Changed `{questions}`, not based on `{compactenum}` any more but set
  up as independent list. Added the "horizontal" version
  `{questions*}`. Both share the same counter, so they can be used
  in the same exercise. The counter is now used globally and is
  NOT set to zero at the environment's start but only by `\exercise`.
  In this way one can resume the counters without problems.
- Changed internal coding of `\grid` (heavily simplified). Changed
  the meaning of the optional parameter; this shouldn't be an issue,
  since I never used it and it wasn't documented in the template.

## 2023-04-01 v0.3a
- Added environment `{matching`} and related macro `\match{...}{...}`.
- Added `\let\par\relax` as end code of `\newblock` and at the start
  of the `{schedule}` environment. In this way empty lines are
  ignored between `\time`, `\method`, `\content` & Co. Since we are in
  the first cell of `{longtable}`, this redefinition is only local
  and the original meaning of `\par` doesn't need to be restored
  within the arguments of `\time`, `\contents` & Co.
- Changed a bit `{print2-}`: this has been always meant to be for
  myself, so there is no reason to write the first part in half
  a page.
- Added `\exercises` and `\homework`.

## 2023-03-21 v0.3
- Some major changes (in internal coding, not in usage).
- I had actually screwed up quite a lot with the page
  numbering, and `\cleardoublepage` led sometimes to strange
  empty pages and out-of-sync even/odd pages. Now there is
  a new counter `\c@savep@ge`, and all environments which
  reset the page number (`{worksheet}` and `{test}`) now
  save the current page number and restore the "correct"
  number after they have ended.
- I had also some `\restoregeometry` which weren't really
  necessary.
- The headers/footers of the `{worksheet}` have been changed too:
  now they have no page number on the first page, but the teacher's
  version still has the footer saying "Lösung".
- The horizontal lines in `{print3}` weren't coded quite correctly,
  as I forgot a `\nointerlineskip`. Fixed.
- Added option NwT for the test.

## 2023-03-17 v0.2f
- Changed a bit the bounding box of `\fillbox` in math mode.
- The environment `{experiment}` was basically a copy of the
  `{worksheet}` code, so I just did that: `\begin{experiment}` simply
  calls `\worksheet` after setting up the section format to use
  `\experimentname` instead of `\exercisename`.
- Other cosmetic changes to code (e.g. replaced all `\expandafter`
  by the AMS `\@xp`). Removed a lot of `\aftergroup\restoregeometry`.
  Adapted `{cluecards}`, now also with a key/value syntax possible,
  such that the fonts can be changed.

## 2023-03-10 v0.2e
- General rearranging of code. Do I really need the `\AtEndOfClass` hooks?
  I don't quite think so but I leave it there for the time being...
- The code for the background grid has been extremely simplified
  and made more efficient and user-friendly. Now the macros
  `\addbackgroundgrid` and `\removebackgroundgrid` can be used with much
  more flexibility, and they take TikZ options as optional argument.
- The macros setting up the difficulty symbols and the calculator
  icons are now user-level macros. They are initialized at
  `\begin{document}` but can be called again at any point in the
  document.
- The names "Aufgabe" and "Lösung" are not hard-coded any
  more but rather saved in the macros `\exercisename` and `\solutionname`.

## 2023-03-07 v0.2d
Changed the internal coding of `\fillbox`. Changed a bit also how it behaves:
in text mode now similar to `\fillhere`, the default length is twice the
natural length of the argument.

## 2023-03-05 v0.2c
Added `\shortsolution` and `\IfSolutionFT`.

## 2023-02-28 v0.2b
- Changed a bit the loading of a configuration file.
- Some simplifications in code here and there.

## 2023-02-23 v0.2a
- Changed definition of `\fillhere`. This might lead to different
  results with old files. I'll survive.
- The old handling of blocks has been changed. Now it is possible
  to give blocks in arbitrary orders, i.e. `\begin{schedule}[132]`
  prints the schedule for the first, third, and second block.
- Of course, `\begin{schedule}[111]` now prints the first block three
  times. All block times from 0 to 9 have been defined, though 0
  starts at midnight :-) and everything from the fifth starts at 2pm.
  The idea is now that anyone can personalize starting times
  by declaring single hours e.g. as
    `\SetDuration{45}`
    `\SetBlockStart{1}{8:00}`
    `\SetBlockStart{2}{8:45}`
  and so on...
- A personal configuration files `<filename>.sco` can be used to
  customize block starting times.

## 2023-02-15 v0.2
Major changes:
- The environments `{multchoice}` and `{multresponse}` now check
  that there is a correct `\choice` per question, and `{multchoice}`
  checks that there is only one.
  The old behaviour (no control at all) has been migrated
  to the starred variants `{multchoice*}` and `{multresponse*}`.
- The start times of the single blocks can be given by `\SetBlockStart`.
- The school's logo can be given as key/val.

## 2023-02-14 v0.1f
- Added `\wraptikz`.
- I had forgotten to replace the period by a comma in the output of `\vecsum`.

## 2023-02-10 v0.1e
- Rearranged some code.
- Added `\drcput` and `\vecsum`.

## 2023-02-09 v0.1d
- Changed definition of `\rightangle` in order to work with declared
  coordinates. (No idea why the original version didn't work.)
- Added possibility to pass tikz options too.

## 2023-01-31 v0.1c
Added `fontsize` key for all `{print...}` environments.

## 2023-01-27 v0.1c
Heavily changed the internal coding of the `{schedule}` environment.
Now a key/value syntax can be also used instead of only number or
start time. The optional printing of the headline is also a possibility.

## 2023-01-23 v0.1b
- Added radio buttons, recoded some stuff, added `{multresponse}`,
  changed `{multchoice}`, added `\setduration`, corrected a bunch of
  bugs which I inadvertently introduced...
- Thinking of introducing a key/value syntax for the `{schedule}`
  environment, but I'm too tired right now.

## 2022-12-20 v0.1a
- Changed the handling of number of points, based now on a length
  instead of a counter. In this way also decimals (mainly
  half-points) can be used.
- Heavily changed the internal coding of some stuff but otherwise
  no end-user changes.

## 2022-11-25 v0.1
### Added
- Added the macros `\IfSolutionT`, `\IfSolutionF`, `\IfSolutionTF`.
- Added the option ptspre for test to add something before the
  number of points.
- Added the `{cluecards}` environment (and related `\cluecard` macro).
### Changed
- Changed heavily internal coding of test. More than one test
  per file now possible. Added also a "version label" for
  different versions of the test.
- Changed a bit the definition of the `{TF}` environment, now
  based on `{tabularx}`.
- Discontinued the Stoffsverteilungsplan.

## 2022-10-20 v0.0f
- Added `\fillbox`.
- Changed order of solution/no solution for
worksheets & Co. (to save paper...)

## 2022-10-03 v0.0e
Added key/value syntax for `{worksheet}`.

## 2022-09-30 v0.0d
- Added tabular column types `L`, `C`, `R`, `s`, `S`, `f`, `F`.
- Added default font correction to `\sqrt`.

## 2022-09-20 v0.0c
Added `{worksheet*}`.

## 2022-09-15 v0.0b
Made `\grid` `\long`.

## 2022-08-15 v0.0a
Added optional number of points to `\question`.

## 2022-08-10 v0.0
First more or less stable version.

[v1.3.0]: https://github.com/dcampagnari/drcschool/compare/v1.2.2...v1.3.0
[v1.2.2]: https://github.com/dcampagnari/drcschool/compare/v1.2.1...v1.2.2
[v1.2.1]: https://github.com/dcampagnari/drcschool/compare/v1.2.0...v1.2.1
[v1.2.0]: https://github.com/dcampagnari/drcschool/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/dcampagnari/drcschool/compare/v1.0.6...v1.1.0
[v1.0.6]: https://github.com/dcampagnari/drcschool/compare/v1.0.5...v1.0.6
[v1.0.5]: https://github.com/dcampagnari/drcschool/releases/tag/v1.0.5