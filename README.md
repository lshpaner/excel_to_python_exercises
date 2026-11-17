# From Excel to Python: companion materials

A ten-chapter introduction to data science for analysts and managers who have never written code.
Chapters 1-3 run in Excel, chapters 4-10 in Python, all on one real dataset: a quarter of LA Metro Bike Share trips.
The question we carry through every chapter: ridership is falling, what should Metro do?

**Read the book:** https://lshpaner.github.io/excel_to_python/

Copyright 2026 Leon Shpaner. All rights reserved. Shared for readers of the book; not for redistribution.

## Layout

```
notebooks/        one folder per chapter: the chapter notebook (chapters 4-10); workbooks for chapters 1-3 are on the Releases page
exercises/        one folder per chapter: a worked exercise and one to do on your own
core/             dataset registry and loaders
data_gen.py       fetch raw data from Metro (python data_gen.py fetch --all --csv)
preprocessing.py  cleaning and joins used from chapter 4 on
```

Open any notebook in Colab: File > Open notebook > GitHub, paste this repository's URL. Excel workbooks are attached to the Releases page, one release per chapter.

## Data

LA Metro Bike Share publishes anonymized trip data at https://bikeshare.metro.net/about/data/.
`data/` is empty in this repo. The notebooks download what they need from the `data` release automatically; to work offline, download the two CSVs from that release into `data/raw/`.

## Chapters

| Chapter | Read | Run |
|---:|---|---|
| 1 | [Meet the Data](https://lshpaner.github.io/excel_to_python/notebooks/chapter_01/chapter_01.html) | [Workbooks](https://github.com/lshpaner/excel_to_python_exercises/releases/tag/chapter-01) |
| 2 | [Summarize and Compare](https://lshpaner.github.io/excel_to_python/notebooks/chapter_02/chapter_02.html) | [Workbooks](https://github.com/lshpaner/excel_to_python_exercises/releases/tag/chapter-02) |
| 3 | [Clean and Join](https://lshpaner.github.io/excel_to_python/notebooks/chapter_03/chapter_03.html) | [Workbooks](https://github.com/lshpaner/excel_to_python_exercises/releases/tag/chapter-03) |
| 4 | [From Cells to Code](https://lshpaner.github.io/excel_to_python/notebooks/chapter_04/chapter_04.html) | [Open in Colab](https://colab.research.google.com/github/lshpaner/excel_to_python_exercises/blob/main/notebooks/chapter_04/chapter_04_lecture.ipynb) · [exercises](https://github.com/lshpaner/excel_to_python_exercises/tree/main/exercises/chapter_04) |
| 5 | [Filter, Group, Aggregate](https://lshpaner.github.io/excel_to_python/notebooks/chapter_05/chapter_05.html) | [Open in Colab](https://colab.research.google.com/github/lshpaner/excel_to_python_exercises/blob/main/notebooks/chapter_05/chapter_05_lecture.ipynb) · [exercises](https://github.com/lshpaner/excel_to_python_exercises/tree/main/exercises/chapter_05) |
| 6 | [Visualize](https://lshpaner.github.io/excel_to_python/notebooks/chapter_06/chapter_06.html) | [Open in Colab](https://colab.research.google.com/github/lshpaner/excel_to_python_exercises/blob/main/notebooks/chapter_06/chapter_06_lecture.ipynb) · [exercises](https://github.com/lshpaner/excel_to_python_exercises/tree/main/exercises/chapter_06) |
| 7 | [Statistics for Decisions](https://lshpaner.github.io/excel_to_python/notebooks/chapter_07/chapter_07.html) | [Open in Colab](https://colab.research.google.com/github/lshpaner/excel_to_python_exercises/blob/main/notebooks/chapter_07/chapter_07_lecture.ipynb) · [exercises](https://github.com/lshpaner/excel_to_python_exercises/tree/main/exercises/chapter_07) |
