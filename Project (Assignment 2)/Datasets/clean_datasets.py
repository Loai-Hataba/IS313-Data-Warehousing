"""
clean_datasets.py
Fixes two CSV data quality issues that break the Load_STG SSIS package:
  1. olist_order_reviews_dataset.csv  — removes embedded newlines and double-quotes
                                        from review_comment_title and review_comment_message
  2. product_category_name_translation.csv — strips UTF-8 BOM so SSIS can read the header
Run: python3 clean_datasets.py   (from the Datasets directory, or adjust BASE_DIR below)
"""

import csv
import os
import shutil

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


def clean_reviews():
    src = os.path.join(BASE_DIR, "olist_order_reviews_dataset.csv")
    tmp = src + ".tmp"

    text_cols = {"review_comment_title", "review_comment_message"}

    rows_in = 0
    rows_out = 0

    with open(src, encoding="utf-8", newline="") as fin, \
         open(tmp, "w", encoding="utf-8", newline="\r\n") as fout:

        reader = csv.DictReader(fin)
        writer = csv.DictWriter(
            fout,
            fieldnames=reader.fieldnames,
            quoting=csv.QUOTE_ALL,
            lineterminator="\r\n",
        )
        writer.writeheader()

        for row in reader:
            rows_in += 1
            for col in text_cols:
                if col in row and row[col]:
                    val = row[col]
                    val = val.replace("\r\n", " ").replace("\r", " ").replace("\n", " ")
                    val = val.replace('"', "")
                    row[col] = val.strip()
            writer.writerow(row)
            rows_out += 1

    os.replace(tmp, src)
    print(f"[reviews]      rows read={rows_in}  rows written={rows_out}  -> {src}")


def fix_translation_bom():
    src = os.path.join(BASE_DIR, "product_category_name_translation.csv")
    tmp = src + ".tmp"

    rows_in = 0
    rows_out = 0

    with open(src, encoding="utf-8-sig", newline="") as fin, \
         open(tmp, "w", encoding="utf-8", newline="\r\n") as fout:

        reader = csv.DictReader(fin)
        writer = csv.DictWriter(
            fout,
            fieldnames=reader.fieldnames,
            lineterminator="\r\n",
        )
        writer.writeheader()

        for row in reader:
            rows_in += 1
            writer.writerow(row)
            rows_out += 1

    os.replace(tmp, src)
    print(f"[translation]  rows read={rows_in}  rows written={rows_out}  -> {src}")


if __name__ == "__main__":
    clean_reviews()
    fix_translation_bom()
    print("Done. Re-run Load_STG.dtsx.")
