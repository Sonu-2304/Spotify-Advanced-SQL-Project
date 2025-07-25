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
    licensed BIT,              -- replaced BOOLEAN with BIT
    official_video BIT,        -- replaced BOOLEAN with BIT
    stream BIGINT,
    energy_liveness FLOAT,
    most_playedon VARCHAR(50)
);

--- EDA 

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

DELETE 
FROM spotify 
WHERE duration_min = 0;

SELECT duration_min 
FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_playedon FROM spotify;
/*
---------------------------------------------------------------------------------------------------------------
--- DATA ANALYSIS - Data retrieval, filtering, and basic aggregations
---------------------------------------------------------------------------------------------------------------
- 1.Retrieve the names of all tracks that have more than 1 billion streams.
- 2.List all albums along with their respective artists.
- 3.Get the total number of comments for tracks where licensed = TRUE.
- 4.Find all tracks that belong to the album type single.
- 5.Count the total number of tracks by each artist.
*/

-- 1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT Track FROM spotify
WHERE stream > 1000000000 ;

-- 2.List all albums along with their respective artists.

SELECT DISTINCT album, artist
FROM spotify
ORDER BY 2;

-- 3.Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) AS TOTAL_COMMENTS
FROM spotify
WHERE licensed = 'TRUE';

-- 4.Find all tracks that belong to the album type single.

SELECT TRACK
FROM spotify
WHERE album_type = 'SINGLE';

-- 5.Count the total number of tracks by each artist.

SELECT artist, COUNT(track) AS TOTAL_TRACKS
FROM spotify
GROUP BY artist
ORDER BY TOTAL_TRACKS;


/*
---------------------------------------------------------------------------------------------------------------
--- DATA ANALYSIS - Complex queries involving grouping, aggregation functions, and joins.
---------------------------------------------------------------------------------------------------------------
-- 1.Calculate the average danceability of tracks in each album.
-- 2.Find the top 5 tracks with the highest energy values.
-- 3.List all tracks along with their views and likes where official_video = TRUE.
-- 4.For each album, calculate the total views of all associated tracks.
-- 5.Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

-- 1.Calculate the average danceability of tracks in each album.

SELECT album, AVG(danceability) AS AVG_DANCEABILITY
FROM spotify
GROUP BY album
ORDER BY AVG_DANCEABILITY DESC;


-- 2.Find the top 5 tracks with the highest energy values.

SELECT TOP 5 TRACK
FROM spotify
ORDER BY energy DESC;

-- 3.List all tracks along with their total views (spotify+youtube) and likes where official_video = TRUE.

SELECT track, SUM(views) TOTAL_VIEWS, SUM(likes) TOTAL_LIKES
FROM spotify
where official_video = 'TRUE'
GROUP BY track
ORDER BY 2 DESC;

-- 4.For each album, calculate the total views of all associated tracks.

SELECT album, track, SUM(views) AS TOTAL_VIEWS
FROM spotify
GROUP BY album,track
ORDER BY 3 DESC;


-- 5.Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT s1.track
FROM spotify s1
JOIN spotify s2
    ON s1.track = s2.track
WHERE s1.most_playedon = 'SPOTIFY'
  AND s2.most_playedon = 'YOUTUBE'
  AND s1.stream > s2.stream;

---- OR 

SELECT track
FROM(
SELECT track, 
       SUM(CASE WHEN most_playedon = 'SPOTIFY' THEN STREAM ELSE 0 END) AS STREAM_ON_SPOTIFY , 
       SUM(CASE WHEN most_playedon = 'YOUTUBE' THEN STREAM ELSE 0 END) AS STREAM_ON_YOUTUBE
FROM spotify
GROUP BY TRACK
) S
WHERE STREAM_ON_SPOTIFY > STREAM_ON_YOUTUBE;




/*
---------------------------------------------------------------------------------------------------------------
--- DATA ANALYSIS - Nested subqueries, window functions, CTEs, and performance optimization
---------------------------------------------------------------------------------------------------------------
-- 1.Find the top 3 most-viewed tracks for each artist using window functions.
-- 2.Write a query to find tracks where the liveness score is above the average.
-- 3.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
-- 4.Find tracks where the energy-to-liveness ratio is greater than 1.2.
-- 5.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/


-- 1.Find the top 3 most-viewed tracks for each artist using window functions.


WITH CTE AS (
SELECT artist, track , SUM(views) TOTAL_VIEW , DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS RANK
FROM spotify
GROUP BY artist, track) 

SELECT artist, track ,TOTAL_VIEW, RANK
FROM CTE
WHERE RANK<=3


-- 2.Write a query to find tracks where the liveness score is above the average.


SELECT track, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY 2 DESC



-- 3.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH CTE AS (
SELECT album , MAX(energy) HIGHEST_ENERGY,  MIN(energy) LOWEST_ENERGY
FROM spotify
GROUP BY album
)
SELECT album, HIGHEST_ENERGY - LOWEST_ENERGY AS ENERGY_DIFF
FROM CTE
ORDER BY 2 DESC;



-- 4.Find tracks where the energy-to-liveness ratio is greater than 1.2.

WITH CTE AS (
SELECT track, energy/NULLIF(liveness,0) AS RATIO
FROM spotify
)
SELECT track, RATIO
FROM CTE
WHERE RATIO > 1.2;


-- 5.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT 
    track, 
    views, 
    likes, 
    SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM spotify;

