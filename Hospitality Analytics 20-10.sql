/*Q1 Total Revenue /*
/answer */
SELECT 
    CONCAT(ROUND(sum(Revenue_realized / 1000000), 2), ' M') AS Total_Revenue
FROM fact_bookings;

/* Q2 Occupancy
answer*/
SELECT 
ROUND((SUM(a.successful_bookings) / SUM(a.capacity))*100, 2 ) AS Occupancy_Rate_Percent
FROM fact_aggregated_bookings as a 
left join fact_bookings as b on a.property_id=b.property_id and b.booking_status = 'Checked Out';

/*Q3 Cancellation Rate
answer*/
SELECT 
    ROUND(SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 /COUNT(*),2) AS Cancellation_Rate_Percent
FROM fact_bookings;

/* Q4 Total Booking

Answer total bookings*/
SELECT 
 COUNT(booking_id) AS Total_Bookings
FROM fact_bookings;

/*Answer b
total booking by property*/
SELECT 
 a.property_name AS Hotel_Name,
    COUNT(b.booking_id) AS Total_Bookings
FROM dim_hotels as a join fact_bookings as b on a.property_id=b.property_id
GROUP BY a.property_name
ORDER BY Total_Bookings DESC;

/*Answer c
total booking by month*/

SELECT 
    DATE_FORMAT(booking_date, '%Y-%m') AS Month,
    COUNT(booking_id) AS Total_Bookings
FROM fact_bookings
GROUP BY DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY Month;

/* Q5 Utilize capacity 
Answer a*/
SELECT 
    ROUND(SUM(CASE WHEN booking_status = 'Checked Out' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),2) AS Utilized_Capacity_Percent
FROM fact_bookings;


/*Answer b by property*/
SELECT 
    a.property_name AS Hotel_Name,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN b.booking_status = 'Checked Out' THEN 1 ELSE 0 END) AS Occupied_Bookings,
    ROUND(
        SUM(CASE WHEN b.booking_status = 'Checked Out' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),2) AS Utilized_Capacity_Percent
FROM dim_hotels as a join fact_bookings as b on a.property_id=b.property_id
GROUP BY a.property_name
ORDER BY Utilized_Capacity_Percent DESC;
 
 /*Q6 Trend Analysis 
 Answer A */
 SELECT 
    DATE_FORMAT(booking_date, '%Y-%m') AS Month,
    concat(round(SUM(revenue_realized/1000000),2),'M') AS Total_Revenue
FROM fact_bookings
GROUP BY DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY Month;

/* Answer B overall trend analysis*/
SELECT 
    DATE_FORMAT(booking_date, '%Y-%m') AS Month,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled_Bookings,
    SUM(CASE WHEN booking_status = 'Checked Out' THEN 1 ELSE 0 END) AS Occupied_Bookings,
    ROUND(SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Cancellation_Rate_Percent,
    ROUND(SUM(CASE WHEN booking_status = 'Checked Out' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS Utilized_Capacity_Percent,
concat(round(SUM(revenue_realized/1000000),2),'M') AS Total_Revenue
FROM fact_bookings
GROUP BY DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY Month;

/* Q7 Weekday  & Weekend Revenue and Booking
Answer */
SELECT CASE WHEN DAYOFWEEK(booking_date) IN (1, 7) THEN 'Weekend'ELSE 'Weekday'
    END AS Day_Type,
    COUNT(*) AS Total_Bookings,
 concat(round(SUM(revenue_realized/1000000),2),'M') AS Total_Revenue
FROM fact_bookings
WHERE booking_status = 'Checked Out'
GROUP BY CASE WHEN DAYOFWEEK(booking_date) IN (1, 7) THEN 'Weekend'ELSE 'Weekday'
    END;
/*Q8 Revenue by State & hotel
    Answer */
    SELECT 
    a.city,
    a.property_name,
 concat(round(SUM(b.revenue_realized/1000000),2),'M') AS Total_Revenue
FROM fact_bookings as b join dim_hotels as a on a.property_id=b.property_id
WHERE b.booking_status = 'Checked Out'
GROUP BY a.city, a.property_name
ORDER BY a.city, Total_Revenue DESC;

   /* Answer by using subquery same question*/
    SELECT 
    a.city,
    a.property_name,
    (SELECT  concat(round(SUM(b.revenue_realized/1000000),2),'M') AS Total_Revenue
     FROM fact_bookings b
     WHERE b.property_id = a.property_id
       AND b.booking_status = 'Checked Out') AS Total_Revenue
FROM dim_hotels a
GROUP BY a.city, a.property_name
ORDER BY a.city, Total_Revenue DESC;

 /* Q9 Class Wise Revenue
 Answer*/
 SELECT 
   a.room_class AS Class_Wise,
concat(round(SUM(b.revenue_realized/1000000),2),'M') AS Total_Revenue
FROM fact_bookings as b join dim_rooms as a on b.room_category=a.room_id
GROUP BY a.room_class
ORDER BY 
    Total_Revenue DESC;
    
   /* Answer b. using window function*/
SELECT DISTINCT
    a.room_class,
    concat(round(SUM(b.revenue_realized) OVER (PARTITION BY room_category) / 1000000,2),'M') AS Class_Total_Revenue
FROM fact_bookings as b join dim_rooms as a on b.room_category=a.room_id
order by class_total_revenue desc;

/* Q10 Checked out, Cancel & No show
answer*/
SELECT    
    booking_status,
    concat(round(SUM(revenue_realized/1000000),2),'M') AS Total_Revenue
FROM fact_bookings
GROUP BY booking_status;

/*Q11 Weekly trend Key trend (Revenue, Total booking, Occupancy) 
Answer*/

SELECT
    WEEK(STR_TO_DATE(check_in_date, '%Y-%m-%d')) AS week_number,
    concat(round(SUM(revenue_realized/100000),2),'M') AS total_revenue,
    COUNT(booking_id) AS total_bookings
FROM fact_bookings 
WHERE revenue_realized IS NOT NULL
GROUP BY WEEK(STR_TO_DATE(check_in_date, '%Y-%m-%d'))
ORDER BY week_number;















