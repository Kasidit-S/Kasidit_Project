----------------------------------- BKK -------------------------------------------
DROP TABLE IF EXISTS #BILL
DROP TABLE IF EXISTS #TIER_SALES
SELECT DISTINCT RWD_CARD_NO,TICKET_NO,SUM(NET_ITEM_AMT) AS Sales
INTO #BILL
FROM BILLING
WHERE EXISTS (SELECT MAIN_IDENTIFIER_NO FROM CUST
              WHERE APPLY_DATE BETWEEN '2024-06-01' AND '2024-08-31' AND ADR_PROVINCE = 'กรุงเทพมหานคร'
                AND sas..CLM_MST_CUSTOMER_CAR_BASE.MAIN_IDENTIFIER_NO = sas..TRN_BILLING_ITEM_CAR_BASE.RWD_CARD_NO)
      AND BILLING_DATE BETWEEN '2024-06-01' AND '2024-08-31'
GROUP BY RWD_CARD_NO,TICKET_NO



SELECT RWD_CARD_NO,TICKET_NO,Sales
     ,CASE WHEN Sales <= 0  THEN 'RETURN'
          WHEN Sales <= 999 THEN 'G01_1 - 999'
          WHEN Sales <= 1999 THEN 'G02_1,000 - 1,999'
          WHEN Sales <= 2999 THEN 'G03_2,000 - 2,999'
          WHEN Sales <= 3999 THEN 'G04_3,000 - 3,999'
          WHEN Sales <= 4999 THEN 'G05_4,000 - 4,999'
          WHEN Sales <= 5999 THEN 'G06_5,000 - 5,999'
          WHEN Sales <= 6999 THEN 'G07_6,000 - 6,999'
          WHEN Sales <= 7999 THEN 'G08_7,000 - 7,999'
          WHEN Sales <= 8999 THEN 'G09_8,000 - 8,999'
          WHEN Sales <= 9999 THEN 'G10_9,000 - 9,999'
          WHEN Sales <= 11999 THEN 'G11_10,000 - 11,999'
          WHEN Sales <= 13999 THEN 'G12_12,000 - 13,999'
          WHEN Sales <= 19999 THEN 'G13_14,000 - 19,999'
          WHEN Sales <= 24999 THEN 'G14_20,000 - 24,999'
          WHEN Sales <= 29999 THEN 'G15_25,000 - 29,999'
          WHEN Sales <= 34999 THEN 'G16_30,000 - 34,999'
          WHEN Sales <= 39999 THEN 'G17_35,000 - 39,999'
          WHEN Sales <= 49999 THEN 'G18_40,000 - 49,999'
          WHEN Sales <= 69999 THEN 'G19_50,000 - 69,999'
          WHEN Sales <= 79999 THEN 'G20_70,000 - 79,999'
          WHEN Sales <= 99999 THEN 'G21_80,000 - 99,999'
          WHEN Sales <= 149999 THEN 'G22_100,000 - 149,999'
          WHEN Sales <= 199999 THEN 'G23_150,000 - 199,999'
          WHEN Sales <= 299999 THEN 'G24_200,000 - 299,999'
          WHEN Sales <= 499999 THEN 'G25_300,000 - 499,999'
          WHEN Sales <= 999999 THEN 'G26_500,000 - 999,999'
          WHEN Sales >= 1000000 THEN 'G27 1,000,000.-'
          END AS TIER_Sales
INTO #TIER_SALES
FROM #BILL


SELECT 'Total' AS TIER_Sales,COUNT(DISTINCT RWD_CARD_NO) AS Members,COUNT(DISTINCT TICKET_NO) AS Tickets,SUM(Sales) AS Sales
FROM #TIER_SALES

UNION

SELECT TIER_Sales,COUNT(DISTINCT RWD_CARD_NO) AS Members,COUNT(DISTINCT TICKET_NO) AS Tickets,SUM(Sales) AS Sales
FROM #TIER_SALES
GROUP BY TIER_Sales
ORDER BY TIER_Sales
