select count(*) from spotify;
select * from spotify limit 5;

select distinct artist from spotify;

select * from spotify where duration_min = 0;
delete from spotify where duration_min = 0;


-- Easy Level
-- 1.Retrieve the names of all tracks that have more than 1 billion streams.*/
select track from spotify where stream > 1000000000;

-- 2.List all albums along with their respective artists.
select distinct artist,album from spotify;

-- 3.Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments from spotify where licensed = 'true';

-- 4.Find all tracks that belong to the album type single.
select album from spotify where album_type = 'single';

-- 5.Count the total number of tracks by each artist. 
select artist,count(track) as total_tracks from spotify 
group by artist
order by total_tracks;


-- Medium Level
-- 1.Calculate the average danceability of tracks in each album.
select album,avg(danceability) from spotify group by album;

-- 2.Find the top 5 tracks with the highest energy values.
select track,max(energy_liveness) from spotify group by track order by 2 DESC limit 5

-- 3.List all tracks along with their views and likes where official_video = TRUE.
select track,views,likes from spotify where official_video = 'true'

-- 4.For each album, calculate the total views of all associated tracks.
select album,sum(views) from spotify group by album

-- 5.Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from
(select track,
coalesce(sum(case when most_played_on ='Spotify' then stream end),0) as stream_on_spotify,
coalesce(sum(case when most_played_on ='Youtube' then stream end),0) as stream_on_youtube
from spotify
group by track
) as tab
where stream_on_spotify > stream_on_youtube and stream_on_youtube > 0


-- Advanced Level
-- 1.Find the top 3 most-viewed tracks for each artist using window functions.

select * from
(select artist,track,sum(views) as total_view,
dense_rank() over (Partition by artist order by sum(views) desc) as rank
from spotify
group by artist,track
order by 1,3 desc) as ranking 
where rank <= 3


-- 2.Write a query to find tracks where the liveness score is above the average.
select * from spotify
select track,liveness from spotify
where liveness > (select avg(liveness) from spotify)
order by 2


-- 3.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with difference_check 
as
(select 
album,
max(energy) as maximum,
min(energy) as minimum
from spotify 
group by 1)

select album,ROUND(ABS(cast(maximum as numeric) - cast(minimum as numeric)),2) as differnce from difference_check










