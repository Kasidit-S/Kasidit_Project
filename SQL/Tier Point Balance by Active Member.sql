DROP TABLE IF EXISTS #POINT_Balance
DROP TABLE IF EXISTS #TIER_POINT


SELECT  A.MAIN_IDENTIFIER_NO
     ,CASE WHEN Last_bill >= '2024-06-24' THEN 'Active6M'
     ELSE 'Inactive' END AS ActiveM
     ,SUM(POINT_BALANCE + POINT_DELAY) AS Balance_Point
INTO #POINT_Balance
FROM SAS..CLM_POINT_BALANCE_CAR_BASE AS A
LEFT JOIN (SELECT RWD_CARD_NO, MAX(BILLING_DATE) AS Last_bill
          FROM sas..TRN_BILLING_ITEM_CAR_BASE 
          WHERE BILLING_DATE >= '2024-01-01'
          GROUP BY RWD_CARD_NO) AS B
ON A.MAIN_IDENTIFIER_NO = B.RWD_CARD_NO
WHERE MAIN_BALANCE_FLAG = 1
GROUP BY A.MAIN_IDENTIFIER_NO,
     CASE WHEN Last_bill >= '2024-06-24' THEN 'Active6M'
     ELSE 'Inactive' END



SELECT MAIN_IDENTIFIER_NO, ActiveM, Balance_Point,
CASE WHEN Balance_Point IS NULL OR Balance_Point = 0 THEN '0'
     WHEN Balance_Point <= 500 THEN '01) 1-500'
     WHEN Balance_Point <= 1000 THEN '02) 501-1000'
     WHEN Balance_Point <= 1500 THEN '03) 1001-1500'
     WHEN Balance_Point <= 2000 THEN '04) 1501-2000'
     WHEN Balance_Point <= 2500 THEN '05) 2001-2500'
     WHEN Balance_Point <= 3000 THEN '06) 2501-3000'
     WHEN Balance_Point <= 3500 THEN '07) 3001-3500'
     WHEN Balance_Point <= 4000 THEN '08) 3501-4000'
     WHEN Balance_Point <= 4500 THEN '09) 4001-4500'
     WHEN Balance_Point <= 5000 THEN '10) 4501-5000'
     WHEN Balance_Point <= 5500 THEN '11) 5001-5500'
     WHEN Balance_Point <= 6000 THEN '12) 5501-6000'
     WHEN Balance_Point <= 6500 THEN '13) 6001-6500'
     WHEN Balance_Point <= 7000 THEN '14) 6501-7000'
     WHEN Balance_Point <= 7500 THEN '15) 7001-7500'
     WHEN Balance_Point <= 8000 THEN '16) 7501-8000'
     WHEN Balance_Point <= 8500 THEN '17) 8001-8500'
     WHEN Balance_Point <= 9000 THEN '18) 8501-9000'
     WHEN Balance_Point <= 9500 THEN '19) 9001-9500'
     WHEN Balance_Point <= 10000 THEN '20) 9501-10000'
     WHEN Balance_Point > 10000 THEN '31) >10000'
     END AS Tier_Balance_Point
INTO #TIER_POINT
FROM #POINT_Balance


SELECT Tier_Balance_Point,ActiveM,COUNT(MAIN_IDENTIFIER_NO) AS Member,SUM(Balance_Point) AS Total_Balance_Point
FROM #TIER_POINT
WHERE Balance_Point <> 0
GROUP BY Tier_Balance_Point,ActiveM
ORDER BY ActiveM,Tier_Balance_Point