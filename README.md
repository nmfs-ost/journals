`journals` provides a suite of quality-checked .bib files that includes entries
for over thirty journals if the field of fisheries. For each journal we cover,
a complete index all published articles is quality checked and formatted on a
routine basis. Entries are given unique keys based on the journal name, the
first author, the year, and the first three words of the title. The entries,
sometimes combined across journals, can be found in `inst/bib`. Users can
reference unique keys from these files and never have to worry about keys
changing or overlapping across files.

First and foremost, the authors of `journals` would like to thank Nelson H. F.
Beebe for his tireless dedication to archiving robust bibliographic information
and for being willing to extend his tools for use on journals outside of his domain. We encourage readers to peruse Nelson's full archive of
[mathematical journals and bibliography tools](http://ftp.math.utah.edu/pub/tex/bib/#download) kindly
hosted by the [University of Utah's Department of
Mathematics](https://www.math.utah.edu/).

## Installation

To install the R package, we recommend using {pak}, though any method that installs a package from a GitHub repository will work.
```
pak::pak("nmfs-ost/journals")
```

You can also clone the GitHub repository using
```
git clone https://github.com/nmfs-ost/journals.git
```
and use your favorite text editor to view the [bib files](inst/bib).

## Use

`journals` lets you take the easy :motorway: without having to manage your own
bibliography archive. Instead, you will just need to learn the syntax
surrounding bibliography keys.

You can download all of the .bib files using `download_bibs()`, this function also downloads the necessary .sty file (see #Macros). If you just want to see the files that are available to download you can use `find_bibs()`. Both of these functions require active internet connections because they source the latest files from the GitHub repository rather than the saved files within the package.

### Bibliography keys

:key:s or :label:s are created using strict rules using the
[biblabel software](https://www.math.utah.edu/~beebe/software/biblabel)
such that all keys are unique. Even across files.
For details see the
[documentation for biblabel](https://www.math.utah.edu/~beebe/software/biblabel/biblabel.html).

In short,
keys are created by pasting the following strings together with colons.
1. The lowercase journal abbreviation, e.g., canjfishaquatsci.
1. The first authors last name without apostrophes, etc.
1. The four-digit year the reference was published.
1. Captial letters representing the first letter of the first three important
   words in the title.

For example, the bib :key: for Scheffel *et al.* (2020) with a title of
"Coupling acoustic tracking with conventional tag returns to estimate mortality
for a coastal flatfish with high rates of emigration"
is `canjfishaquatsci:Scheffel:2020:CAT`.

### Macros

Many entries use special formatting for scientific names that requires adding the journals-bibnames.sty package to your .Rmd, .md., or .tex file. You add it as you would any other package from CTAN, except you also need to put `inst\bib\journals-bibnames.sty` in the same folder where you are rendering your .Rmd, .md, or .tex file.

### {RefManageR}

{RefManageR} is a great package within R that can help search .bib files and
generate citations and bibliographies.
For example, a given .bib file can be read in and searched using
```
cjfas <- RefManageR::ReadBib(
  file = file.path("inst", "bib", "canjfishaquatsci.bib")
)
scheffel2020 <- RefManageR::SearchBib(
  x = cjfas,
  doi = "cjfas-2018-0174"
)

# print the bib key
names(scheffel2020)
# [1] "canjfishaquatsci:Scheffel:2020:CAT"

# print a citation
RefManageR::AutoCite(scheffel2020, .opts = list(max.names = 3))
# [1] "(Scheffel, Hightower, Buckel, et al., 2020)"

# print a bibliography
RefManageR::PrintBibliography(scheffel2020)
```

More work needs to be done to make the formatting of the printed bibliography
more in line with user needs but it is a start.

## <img src="https://media.giphy.com/media/VgCDAzcKvsR6OM0uWg/giphy.gif" width="50"> Future

This repository is under active development with the following goals:

* Create an R package with tools for helping manage/search .bib files.
* Create vignettes that clearly outline how to use these .bib files.
* Document a pathway for using bib keys with roxygen2.
