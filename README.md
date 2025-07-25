# 🎧 Spotify Advanced SQL Project and Query Optimization (SSMS)

## 📁 Project Category

**Level**: Advanced
**Tool**: SQL Server Management Studio (SSMS)
**Dataset**: [Spotify Dataset on Kaggle](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

---

## 📌 Overview

This project is focused on advanced SQL querying and performance tuning using a Spotify dataset. The dataset contains detailed information on tracks, albums, artists, and user engagement metrics.

You will:

* Normalize and analyze a denormalized dataset.
* Write progressively complex SQL queries (Easy → Advanced).
* Optimize SQL performance using best practices like **indexes** and **execution plans** in SSMS.

---

## 📊 Dataset Structure

The dataset includes the following columns:

* **Artist**, **Track**, **Album**, **Album\_type**
* **Danceability**, **Energy**, **Loudness**, **Speechiness**, **Acousticness**
* **Instrumentalness**, **Liveness**, **Valence**, **Tempo**
* **Duration\_min**, **Title**, **Channel**, **Views**, **Likes**, **Comments**
* **Licensed**, **Official\_video**, **Stream**, **Energy\_liveness**
* **Most\_played\_on**

---

## 🛠 Table Creation in SSMS

```sql
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BIT,
    official_video BIT,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```

---

## 🔍 Project Workflow

### 1. Data Exploration

Understand the dataset columns and relationships before writing queries. Key insights can be drawn by observing trends in track popularity, artist performance, and streaming platform comparisons.

### 2. Querying the Data

#### ✅ Easy Level Queries

1. Retrieve tracks with more than 1 billion streams.
2. List all albums with their respective artists.
3. Count total comments for licensed tracks.
4. Find tracks under `album_type = 'single'`.
5. Count the number of tracks for each artist.

#### ⚙️ Medium Level Queries

1. Average danceability of tracks by album.
2. Top 5 tracks with highest energy.
3. Tracks with views and likes where `official_video = 1`.
4. Total views for each album.
5. Tracks with more streams on Spotify than views on YouTube.

#### 🔬 Advanced Level Queries

1. **Top 3 most-viewed tracks per artist** using window functions.
2. Tracks where liveness is above average.
3. CTE to calculate energy difference per album.
4. Tracks with energy-to-liveness ratio > 1.2.
5. **Cumulative sum of likes** ordered by views using window functions.

---

## 📈 Next Steps

* **Data Visualization**: Connect your query results to tools like Power BI or Tableau for building visual dashboards.
* **Dataset Expansion**: Add more records to simulate real-world Spotify data scale.
* **Further Optimization**: Explore SQL Server indexing strategies and partitioning for big data performance.

---

## 📌 Notes

* This project is built and executed using **SQL Server Management Studio (SSMS)**.
* Ensure data types align correctly when importing the dataset to avoid type mismatches (e.g., use `BIT` for boolean columns in SQL Server).

---

## 📂 Project Files

* `spotify.sql`: Table creation and sample query scripts.
* `README.md`: Project documentation (this file).
* `spotify_dataset.csv`: Raw dataset (download from Kaggle).

