#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = ds_fundamentals
PYTHON_VERSION = 3.12
PYTHON_INTERPRETER = python
VENV_DIR = ds_fundamentals_venv
CONDA_ENV = $(PROJECT_NAME)
DATA_DIR = data
NOTEBOOK_DIR = notebooks
EXERCISE_DIR = exercises

#################################################################################
# ENVIRONMENT                                                                   #
#################################################################################

## Create a local virtual environment and install requirements
create_venv:
	$(PYTHON_INTERPRETER) -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install --upgrade pip
	$(VENV_DIR)/bin/pip install -r requirements.txt
	@echo ">>> venv ready. Activate with: source $(VENV_DIR)/bin/activate"

## Create a conda environment and install requirements
create_conda:
	conda create -y --name $(CONDA_ENV) python=$(PYTHON_VERSION)
	conda run -n $(CONDA_ENV) pip install -r requirements.txt
	@echo ">>> conda env ready. Activate with: conda activate $(CONDA_ENV)"

## Install requirements into the active environment
requirements:
	$(PYTHON_INTERPRETER) -m pip install --upgrade pip
	$(PYTHON_INTERPRETER) -m pip install -r requirements.txt

#################################################################################
# DATA                                                                          #
#################################################################################

## Fetch the course datasets into data/raw/ as Parquet plus CSV (students open the CSVs in Excel)
data_gen:
	$(PYTHON_INTERPRETER) data_gen.py fetch --all --csv

## Fetch a single dataset, e.g. make data_gen_one NAME=metro_stations
data_gen_one:
	$(PYTHON_INTERPRETER) data_gen.py fetch --name $(NAME) --csv

## List datasets registered in core/datasets.py
data_list:
	$(PYTHON_INTERPRETER) data_gen.py list

## Run preprocessing (cleaned tables written to data/processed/)
preprocess:
	$(PYTHON_INTERPRETER) preprocessing.py

#################################################################################
# WORKBOOKS (Excel chapters 1-3; built from data/raw/, never committed)            #
#################################################################################

TRIPS = $(DATA_DIR)/raw/metro_trips.csv
STATIONS = $(DATA_DIR)/raw/metro_stations.csv

## Build every lecture and exercise workbook from data/raw/
workbooks: workbooks_chapter_01 workbooks_chapter_02 workbooks_chapter_03

## Build the chapter 1 workbooks (lecture, guided, solo, solutions)
workbooks_chapter_01:
	$(PYTHON_INTERPRETER) tools/build_chapter_01.py $(TRIPS) $(STATIONS) $(NOTEBOOK_DIR)/chapter_01/chapter_01_lecture.xlsx
	$(PYTHON_INTERPRETER) tools/build_chapter_01_exercises.py $(TRIPS) $(EXERCISE_DIR)/chapter_01 solutions/chapter_01

## Build the chapter 2 workbooks
workbooks_chapter_02:
	$(PYTHON_INTERPRETER) tools/build_chapter_02.py $(TRIPS) $(NOTEBOOK_DIR)/chapter_02/chapter_02_lecture.xlsx
	$(PYTHON_INTERPRETER) tools/build_chapter_02_exercises.py $(TRIPS) $(EXERCISE_DIR)/chapter_02 solutions/chapter_02

## Build the chapter 3 workbooks (needs the station table)
workbooks_chapter_03:
	$(PYTHON_INTERPRETER) tools/build_chapter_03.py $(TRIPS) $(STATIONS) $(NOTEBOOK_DIR)/chapter_03/chapter_03_lecture.xlsx
	$(PYTHON_INTERPRETER) tools/build_chapter_03_exercises.py $(TRIPS) $(STATIONS) $(EXERCISE_DIR)/chapter_03 solutions/chapter_03

## Draw the book cover (cover.svg and cover.png) from the trip data
cover:
	$(PYTHON_INTERPRETER) tools/make_cover.py $(TRIPS) cover.svg cover.png

## Print every number quoted in the chapter 3 chapter, computed from data/raw/
numbers_chapter_03:
	$(PYTHON_INTERPRETER) tools/chapter_03_numbers.py $(TRIPS) $(STATIONS)

## Publish one chapter's student workbooks as a GitHub release on the student repo, e.g. make release_chapter CHAPTER=01
release_chapter:
	gh release create chapter-$(CHAPTER) --repo lshpaner/ds_fundamentals_students --title "Chapter $(CHAPTER) workbooks" \
		--notes "Lecture and exercise workbooks for chapter $(CHAPTER). Open in Excel." \
		$$(ls $(NOTEBOOK_DIR)/chapter_$(CHAPTER)/*.xlsx $(NOTEBOOK_DIR)/chapter_$(CHAPTER)/*.ipynb $(EXERCISE_DIR)/chapter_$(CHAPTER)/*.xlsx $(EXERCISE_DIR)/chapter_$(CHAPTER)/*.ipynb 2>/dev/null)

#################################################################################
# NOTEBOOKS (Python chapters 4-10; generated from the .qmd chapters, never committed)
#################################################################################

## Build every chapter's student notebooks (lecture .ipynb from the chapter, plus exercises)
notebooks: notebooks_chapter_04

## Build the chapter 4 notebooks: lecture from the .qmd via quarto convert, exercises from the builder
notebooks_chapter_04:
	quarto convert $(NOTEBOOK_DIR)/chapter_04/chapter_04.qmd --output $(NOTEBOOK_DIR)/chapter_04/chapter_04_lecture.ipynb
	$(PYTHON_INTERPRETER) tools/build_chapter_04_exercises.py $(EXERCISE_DIR)/chapter_04 solutions/chapter_04

## Execute the solution notebooks for one chapter as a smoke test, e.g. make check_solutions CHAPTER=04
check_solutions:
	for nb in solutions/chapter_$(CHAPTER)/*.ipynb; do \
		jupyter nbconvert --to notebook --execute --output /tmp/$$(basename $$nb) $$nb; \
	done

## Publish the two data files as a GitHub release on the student repo (notebooks download from it in Colab)
release_data:
	gh release create data --repo lshpaner/ds_fundamentals_students --title "Course data" \
		--notes "LA Metro Bike Share 2026 Q1 trips and the station table, from https://bikeshare.metro.net/about/data/. Notebooks read these when data/raw/ is missing." \
		$(DATA_DIR)/raw/metro_trips.csv $(DATA_DIR)/raw/metro_stations.csv

## Launch JupyterLab from the repo root
lab:
	jupyter lab

## Execute every generated lecture notebook in place (smoke test; chapters 4-10)
run_notebooks:
	for nb in $(NOTEBOOK_DIR)/chapter_*/*.ipynb; do \
		jupyter nbconvert --to notebook --execute --inplace $$nb; \
	done

## Strip outputs from every notebook in the repo (nbstripout)
nbstripout:
	find . -name "*.ipynb" -not -path "./.ipynb_checkpoints/*" -not -path "*/.ipynb_checkpoints/*" \
		-not -path "./$(VENV_DIR)/*" -print0 | xargs -0 -r nbstripout

## Install nbstripout as a git filter so outputs are stripped on every commit
nbstripout_install:
	nbstripout --install --attributes .gitattributes

#################################################################################
# SITE                                                                          #
#################################################################################

## Render the Quarto book into _site/ (executes notebooks once; later renders use _freeze/)
render_site:
	quarto render

## Serve the site locally with live reload
preview_site:
	quarto preview

#################################################################################
# RELEASE                                                                       #
#################################################################################

STUDENT_DIR = ../ds_fundamentals_students

## Build the student-facing copy (no solutions) into ../ds_fundamentals_students
export_students:
	$(PYTHON_INTERPRETER) tools/export_students.py . $(STUDENT_DIR)
	@echo ">>> review $(STUDENT_DIR), then commit and push from there."

#################################################################################
# HOUSEKEEPING                                                                  #
#################################################################################

## Remove Python caches and checkpoints
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".ipynb_checkpoints" -exec rm -rf {} +

## Lint with ruff
lint:
	ruff check .

## Format with black
format:
	black .

#################################################################################
# SELF-DOCUMENTING HELP                                                         #
#################################################################################

.DEFAULT_GOAL := help

## Show this help
help:
	@echo ""
	@echo "$(PROJECT_NAME) - available targets:"
	@echo ""
	@awk '/^## / { desc = substr($$0, 4); next } \
	      /^[a-zA-Z_]+:/ && desc { printf "  \033[36m%-18s\033[0m %s\n", $$1, desc; desc = "" }' $(MAKEFILE_LIST) | sed 's/://'
	@echo ""

.PHONY: create_venv create_conda requirements data_gen data_gen_one data_list \
        preprocess workbooks workbooks_chapter_01 workbooks_chapter_02 workbooks_chapter_03 numbers_chapter_03 cover release_chapter notebooks notebooks_chapter_04 check_solutions release_data lab run_notebooks nbstripout nbstripout_install render_site preview_site export_students clean lint format help
