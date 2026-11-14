"""
core/datasets.py

Registry of the raw course datasets and a single fetch function.
The whole course runs on one quarter of LA Metro Bike Share trips plus
the station table, both published at https://bikeshare.metro.net/about/data/.
Nothing is cleaned here; that is preprocessing.py's job.

The two URLs below are the only thing to update when switching quarters.
Metro uploads each file to WordPress, so the exact path comes from the
"Copy link" on the data page.
"""

import io
import zipfile
from pathlib import Path
from urllib.request import Request, urlopen

import pandas as pd

# 2026 Q1 (January - March) trips, zipped CSV. Paste the link from the data page.
TRIPS_URL = "https://bikeshare.metro.net/wp-content/uploads/2026/04/metro-trips-2026-q1.zip"
# Station table (updated 2026-04-01). Paste the link from the data page.
STATIONS_URL = "https://bikeshare.metro.net/wp-content/uploads/2026/04/metro-bike-share-stations-2026-10-15.csv"

QUARTER = "2026 Q1"

# Metro's site returns 403 to scripted downloads. Download the two files in a
# browser, drop them in data/downloads/, and they are picked up by filename.
DOWNLOADS = Path(__file__).resolve().parent.parent / "data" / "downloads"


def _download(url: str) -> bytes:
    local = DOWNLOADS / url.rsplit("/", 1)[-1]
    if local.exists():
        return local.read_bytes()
    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urlopen(req, timeout=120) as r:
            return r.read()
    except Exception as exc:
        raise RuntimeError(
            f"Could not fetch {url} ({exc}). Download it in a browser from "
            f"https://bikeshare.metro.net/about/data/ and save it as {local}"
        ) from exc


def _metro_trips() -> pd.DataFrame:
    """One quarter of anonymized trips. The zip holds a single CSV."""
    raw = _download(TRIPS_URL)
    if TRIPS_URL.endswith(".zip"):
        z = zipfile.ZipFile(io.BytesIO(raw))
        name = next(n for n in z.namelist() if n.lower().endswith(".csv"))
        return pd.read_csv(z.open(name), low_memory=False)
    return pd.read_csv(io.BytesIO(raw), low_memory=False)


def _metro_stations() -> pd.DataFrame:
    """Station id, name, go-live date, region, status."""
    return pd.read_csv(io.BytesIO(_download(STATIONS_URL)), encoding="cp1252")


REGISTRY: dict[str, dict] = {
    "metro_trips": {
        "loader": _metro_trips,
        "weeks": list(range(1, 11)),
        "description": f"LA Metro Bike Share trips, {QUARTER}; one row per trip.",
    },
    "metro_stations": {
        "loader": _metro_stations,
        "weeks": [3, 5, 6, 9],
        "description": "LA Metro Bike Share station table (id, name, region, go-live date).",
    },
}


def fetch_dataset(name: str) -> pd.DataFrame:
    """Return the raw DataFrame for a registered dataset."""
    return REGISTRY[name]["loader"]()


def load_raw(name: str, data_dir: str = "data/raw") -> pd.DataFrame:
    """Read a previously fetched raw Parquet file (used inside notebooks)."""
    return pd.read_parquet(f"{data_dir}/{name}.parquet")


def load_processed(name: str, data_dir: str = "data/processed") -> pd.DataFrame:
    """Read a cleaned table written by preprocessing.py."""
    return pd.read_parquet(f"{data_dir}/{name}.parquet")