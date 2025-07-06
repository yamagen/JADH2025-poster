#!/usr/bin/perl
#$latex = 'uplatex -interaction=nonstopmode -kanji=utf-8 %O %S';
#$pdflatex = 'lualatex %O %S';
$pdflatex = "xelatex %O %S";
#$bibtex = 'upbibtex %O %B';
#$bibtex = 'biber %O %B';
$bibtex='biber --bibencoding=utf8 %B';
$pdf_mode = 1;
$bibtex_use = 2;
$clean_ext .= '%R.bbl %R.ltjruby %R.nav %R.snm %R.vrb';
#$dvipdf = 'dvipdfmx %O -o %D %S';
#$bibtex = 'pbibtex %O %B';
#$pdf_mode = 3; # use dvipdf
#$max_repeat = 5;
#$pdf_update_method = 2;
#
$postscript_mode = 0;
$pdf_previewer = "zathura";
#$pdf_previewer = "mupdf";
# Prevent latexmk from removing PDF after typeset.
# $pvc_view_file_via_temporary = 0;



