# London bike sharing SQL data analysis

## Overview:

In this project I analysed the records of public bycicle usage in London, UK, in August 2023 using SQL Data Manipulation Language and Data Query Langauge
(Joins, Window functions, Case, Date functions, Aggregates, Alter Table).

## Data set

The data set is a single CSV file, obtained from Kaggle containing records of 776,527 bicycle journeys from the Transport for London (TfL) Cycle Hire system spanning from August 1 to August 31, 2023. The TfL Cycle Hire initiative provides publicly accessible bicycles for rent across London, promoting sustainable transportation and physical fitness. This dataset captures individual trip data, and is used to analyze station performance (i.e Which stations are most used), and cycling preferences(i.e ride time per bike model) among London's population. This dataset provides a snapshot of cycling activity during the month, including start and end details for each journey, the bicycle used, and the duration of hire. <br>


**Data dictionary:**

- **Number:** A unique identifier for each trip (Trip ID).
- **Start Date:** The date and time when the trip began.
- **Start Station** Number: The identifier for the starting station.
- **Start Station:** The name of the starting station.
- **End Date:** The date and time when the trip ended.
- **End Station Number:** The identifier for the ending station.
- **End Station:** The name of the ending station.
- **Bike Number:** A unique identifier for the bicycle used.
- **Bike Model:** The model of the bicycle used.
- **Total Duration:** The total time duration of the trip (in a human-readable format).
- **Total Duration (ms):** The total time duration of the trip in milliseconds.


## Questions answered:

1. Provide the total ride time(minutes) per Bike model per week.
2. Count the number of bikes stationed per neighbourhood between 23:00 and 23:59 each day.
3. Select the 2nd, 4th and 6th most used start station based on the number of trips.
4. Find how many trips have started and finished at the same station, count then number of trips and sum total trip time(hours).
5. Find the 3rd busiest day of the month based on the nr.of trips.
6. For how many times was each bike used in August 2023? Provide the median bike usage.
7. What are top 5 the most used start and end station?