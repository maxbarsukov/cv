# Targets:
#    default : compiles the document to a PDF file using the defined
#              latex generating engine. (pdflatex, xelatex, etc)
#    display : displays the compiled document in a common PDF viewer.
#              (currently linux = evince, OSX = open)
#    clean   : removes the out/ directory holding temporary files


# Sources for your .tex an .bib files
SRC = src

# Specify the name of the main .tex file. It must be in SRC
PROJECT = cv

# The OUT directory is not to be used
# The auxiliary files generated by latex, bibtex, and other tools will be redirected to this folder
# Generated DVI, PS, and PDF files will also be placed in this directory
OUT = out


default: $(OUT)/$(PROJECT).pdf

display: default
	(${PDFVIEWER} $(OUT)/$(PROJECT).pdf &)


### Compilation Flags
PDFLATEX_FLAGS  = -cd -f -halt-on-error -lualatex -interaction=nonstopmode -synctex=1 -output-directory=../$(OUT)/


### File Types (for dependancies)
TEX_FILES = $(shell find $(SRC) -name '*.tex' -or -name '*.sty' -or -name '*.cls')
BIB_FILES = $(shell find $(SRC) -name '*.bib')
BST_FILES = $(shell find $(SRC) -name '*.bst')
IMG_FILES = $(shell find . -path '*.jpg' -or -path '*.png' -or \( \! -path './$(OUT)/*.pdf' -path '*.pdf' \) )


### Standard PDF Viewers
# Defines a set of standard PDF viewer tools to use when displaying the result
# with the display target. Currently chosen are defaults which should work on
# most linux systems with GNOME installed and on all OSX systems.

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
PDFVIEWER = evince
endif

ifeq ($(UNAME), Darwin)
PDFVIEWER = open
endif


### Clean
# This target cleans the temporary files generated by the tex programs in
# use. All temporary files generated by this makefile will be placed in OUT/
# so cleanup is easy.

clean::
	find $(OUT)/ ! -name '.keep' -type f -exec rm -f {} +

### Core Latex Generation
# Performs the typical build process for latex generations so that all
# references are resolved correctly. If adding components to this run-time
# always take caution and implement the worst case set of commands.
# Example: latex, bibtex, latex, latex

$(OUT)/:
	mkdir -p $(OUT)/

$(OUT)/$(PROJECT).pdf: $(TEX_FILES) $(IMG_FILES) | $(OUT)/
	latexmk $(PDFLATEX_FLAGS) $(SRC)/$(PROJECT)
