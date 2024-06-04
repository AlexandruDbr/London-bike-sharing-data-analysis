--SQL Server data analysis project
--Data source: https://www.kaggle.com/datasets/kalacheva/london-bike-share-usage-dataset
--------------------------------------------------------------------------------------------------

--1. Provide the total ride time(minutes) per Bike model per week
SELECT
	*
FROM
(SELECT
	CASE 
		WHEN DATEPART(day,[End date]) < 8
		THEN '1' 
		WHEN DATEPART(day,[End date]) < 15 
		then '2' 
		WHEN  DATEPART(day,[End date]) < 22 
		then '3' 
		WHEN  DATEPART(day,[End date]) < 29 
		then '4'     
		ELSE '5'
    END AS weeknr,
	[Bike model],
	((sum([Total duration (ms)])/1000)/60) AS total_time_min
FROM Bikeuse2023
GROUP BY 
	CASE 
		WHEN DATEPART(day,[End date]) < 8
		THEN '1' 
		WHEN DATEPART(day,[End date]) < 15 
		then '2' 
		WHEN  DATEPART(day,[End date]) < 22 
		then '3' 
		WHEN  DATEPART(day,[End date]) < 29 
		then '4'     
		ELSE '5'
	END,
	[Bike model]
) AS tbl
PIVOT(
SUM(total_time_min) FOR [Bike model] IN([PBSC_EBIKE], [CLASSIC])
) AS piv
ORDER BY
weeknr



--2. Convert start date and end date from varchar to datetime
ALTER TABLE "Bikeuse2023"
ALTER COLUMN "Start date" datetime;

ALTER TABLE "Bikeuse2023"
ALTER COLUMN "End date" datetime;



--3. Count the number of bikes stationed per neighbourhood between 23:00 and 23:59 each day
SELECT
	neighbourhood,
	ISNULL([1], 0) AS [1],
	ISNULL([2], 0) AS [2],
	ISNULL([3], 0) AS [3],
	ISNULL([4], 0) AS [4],
	ISNULL([5], 0) AS [5],
	ISNULL([6], 0) AS [6],
	ISNULL([7], 0) AS [7],
	ISNULL([8], 0) AS [8],
	ISNULL([9], 0) AS [9],
	ISNULL([10], 0) AS [10],
	ISNULL([11], 0) AS [11],
	ISNULL([12], 0) AS [12],
	ISNULL([13], 0) AS [13],
	ISNULL([14], 0) AS [14],
	ISNULL([15], 0) AS [15],
	ISNULL([16], 0) AS [16],
	ISNULL([17], 0) AS [17],
	ISNULL([18], 0) AS [18],
	ISNULL([19], 0) AS [19],
	ISNULL([20], 0) AS [20],
	ISNULL([21], 0) AS [21],
	ISNULL([22], 0) AS [22],
	ISNULL([23], 0) AS [23],
	ISNULL([24], 0) AS [24],
	ISNULL([25], 0) AS [25],
	ISNULL([26], 0) AS [26],
	ISNULL([27], 0) AS [27],
	ISNULL([28], 0) AS [28],
	ISNULL([30], 0) AS [30],
	ISNULL([31], 0) AS [31]
FROM
(SELECT
	SUBSTRING(
	[Start station], 
	CHARINDEX(',', [Start station])+1, len([Start station])
							) AS neighbourhood,
	DAY([End date]) AS day,
	COUNT([Bike number]) AS nrofbikes
FROM Bikeuse2023
WHERE 
	DATEPART(hour, [End date]) = 23
AND
[Start station] <> [End station]
GROUP BY 
	SUBSTRING(
			[Start station], 
			CHARINDEX(',', [Start station])+1, len([Start station])
				),
	DAY([End date])
	) AS tabl
PIVOT
(SUM(nrofbikes)
FOR day in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31])
) AS piv
ORDER BY 
	neighbourhood ASC




--4. Select the 2nd, 4th and 6th most used start station based on the number of trips
WITH stations_ranked AS
(
SELECT 
	[Start station],
	count(Number) AS count_trips,
	DENSE_RANK() OVER (ORDER BY count(Number) DESC) AS station_rank
FROM Bikeuse2023
GROUP BY [Start station]
)
SELECT * 
FROM stations_ranked
WHERE station_rank = 2
OR
station_rank = 4
OR
station_rank = 6
ORDER BY station_rank ASC




--5. Find how many trips have started and finished at the same station, count then number of trips and sum total trip time(hours).
SELECT 
	[Start station],
	COUNT(Number) AS count_trips,
	SUM(DATEDIFF(hh, [End date], [Start date])) AS "trip_duration(h)"
FROM Bikeuse2023
WHERE [Start station] = [End station]
GROUP BY [Start station]
ORDER BY 
	count_trips DESC,
	"trip_duration(h)" DESC



--6. Find the 3rd busiest day of the month based on the nr.of trips
SELECT 
	CONVERT(date, [End date]) AS date,
	COUNT(Number) AS count_trips
FROM Bikeuse2023
GROUP BY 
	CONVERT(date, [End date])
ORDER BY count_trips DESC
OFFSET  2 ROWS 
FETCH NEXT 1 ROWS ONLY 



--7. For how many times was each bike used in August 2023? Provide the median bike usage.
SELECT 
	[Bike number],
	COUNT(Number) count_use,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY COUNT(Number)) OVER () AS _50thPerc
FROM Bikeuse2023
GROUP BY [Bike number]
ORDER BY count_use DESC



--8. What are top 5 the most used start and end station?
WITH Start_station_usage
AS
(SELECT
	TOP(5)
		[Start Station],
		COUNT(Number) AS start_station_drops
	FROM Bikeuse2023
	GROUP BY
		[Start station]
	ORDER BY start_station_drops DESC
),
End_station_usage
AS
(SELECT
	TOP(5)
		[End Station],
		COUNT(Number) AS end_station_drops
	FROM Bikeuse2023
	GROUP BY
		[End station]
	ORDER BY end_station_drops DESC
)
SELECT 
	a.[Start Station],
	a.start_station_drops,
	b.[End Station],
	b.end_station_drops
FROM Start_station_usage AS a
FULL JOIN End_station_usage AS b 
ON a.[Start station] = b.[End station]
ORDER BY
	start_station_drops DESC,
	end_station_drops DESC	


