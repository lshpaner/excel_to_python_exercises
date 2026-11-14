# From Excel to Python: companion materials

A ten-chapter introduction to data science for analysts and managers who have never written code.
Chapters 1-3 run in Excel, chapters 4-10 in Python, all on one real dataset: a quarter of LA Metro Bike Share trips.
The question we carry through every chapter: ridership is falling, what should Metro do?

**Read the book:** https://lshpaner.github.io/ds_fundamentals/

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
