"""
preprocessing.py

Cleaning and feature engineering for the course dataset. Reads raw Parquet
from data/raw/ and writes cleaned Parquet to data/processed/. Students see
exactly what was done to the data here; weeks 4-10 load the output.

Weeks 1-3 (Excel) work from the raw CSVs on purpose, so students meet the
mess before they meet the fix.

Usage:
    python preprocessing.py
"""

from pathlib import Path

import pandas as pd

from core.datasets import load_raw

PROCESSED_DIR = Path(__file__).resolve().parent / "data" / "processed"


def build_trips() -> pd.DataFrame:
    """Weeks 4-10: parse timestamps, add calendar features, attach station
    names and regions, flag trips a reader would question."""
    trips = load_raw("metro_trips")
    stations = load_raw("metro_stations")

    # Column names have drifted across quarters; normalise the ones we use.
    trips.columns = [c.strip().lower() for c in trips.columns]
    stations.columns = [c.strip().lower() for c in stations.columns]
    trips = trips.rename(columns={"start_station_id": "start_station", "end_station_id": "end_station"})

    for col in ("start_time", "end_time"):
        trips[col] = pd.to_datetime(trips[col], errors="coerce")

    trips["date"] = trips["start_time"].dt.date
    trips["hour"] = trips["start_time"].dt.hour
    trips["day_of_week"] = trips["start_time"].dt.day_name()
    trips["is_weekend"] = trips["start_time"].dt.day_of_week >= 5
    trips["is_round_trip"] = trips["start_station"] == trips["end_station"]

    # Metro caps trips at 24 hours; anything near the cap is a bike that was not docked.
    trips["long_trip"] = trips["duration"] >= 24 * 60

    name_col = next(c for c in stations.columns if "name" in c)
    id_col = next(c for c in stations.columns if c.endswith("id"))
    region_col = next((c for c in stations.columns if "region" in c), None)
    keep = [id_col, name_col] + ([region_col] if region_col else [])
    lookup = stations[keep].drop_duplicates(id_col)

    for side in ("start", "end"):
        cols = {id_col: f"{side}_station", name_col: f"{side}_station_name"}
        if region_col:
            cols[region_col] = f"{side}_region"
        trips = trips.merge(lookup.rename(columns=cols), on=f"{side}_station", how="left")

    return trips


BUILDERS = {
    "trips": build_trips,
}


def main() -> None:
    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
    for name, fn in BUILDERS.items():
        df = fn()
        path = PROCESSED_DIR / f"{name}.parquet"
        df.to_parquet(path, index=False)
        print(f"wrote {path} ({len(df):,} rows)")


if __name__ == "__main__":
    main()
