CREATE TABLE HIERARCHY1 (NODE INTEGER, PARENT_NODE INTEGER);

INSERT INTO HIERARCHY1 VALUES (1,2);
INSERT INTO HIERARCHY1 VALUES (3,2);
INSERT INTO HIERARCHY1 VALUES (6,8);
INSERT INTO HIERARCHY1 VALUES (9,8);
INSERT INTO HIERARCHY1 VALUES (2,5);
INSERT INTO HIERARCHY1 VALUES (8,5);
INSERT INTO HIERARCHY1 (NODE) VALUES (5);

SELECT NODES.NODE, NODES.PARENT_NODE, CHILD.NODE AS CHILD_NODE
FROM HIERARCHY1 NODES
LEFT OUTER JOIN HIERARCHY1 CHILD
ON NODES.NODE = CHILD.PARENT_NODE
ORDER BY NODES.NODE;

SELECT DISTINCT NODE, NODE_LEVEL FROM
(SELECT NODES.NODE AS NODE, NODES.PARENT_NODE, CHILD.NODE AS CHILD_NODE,
CASE 
WHEN NODES.PARENT_NODE IS NULL THEN 'ROOT'
WHEN CHILD.NODE IS NULL AND NODES.PARENT_NODE IS NOT NULL THEN 'LEAF'
WHEN NODES.PARENT_NODE IS NOT NULL AND CHILD.NODE IS NOT NULL THEN 'INNER'
END AS NODE_LEVEL
FROM HIERARCHY1 NODES
LEFT OUTER JOIN HIERARCHY1 CHILD
ON NODES.NODE = CHILD.PARENT_NODE) AS RESULT
ORDER BY NODE;

-----------------------------------------------------------------------------------------
-- Contest Leaderboard
SELECT INNER_Q1.HACKER_ID, H.NAME, SUM(INNER_Q1.MAX_SCORE) AS TOTAL_SCORE FROM
    (SELECT HACKER_ID, CHALLENGE_ID, MAX(SCORE) AS MAX_SCORE
    FROM SUBMISSIONS
    GROUP BY HACKER_ID, CHALLENGE_ID) AS INNER_Q1
LEFT OUTER JOIN HACKERS H
ON H.HACKER_ID = INNER_Q1.HACKER_ID
GROUP BY HACKER_ID
HAVING TOTAL_SCORE > 0
ORDER BY TOTAL_SCORE DESC, INNER_Q1.HACKER_ID ASC ;
---------------------------------------------------------------------------------------------------

LAT_N, LONG_W

P1(X,Y) = (MIN(LAT_N), MIN(LONG_W))
P2(X,Y) = (MAX(LAT_N), MAX(LONG_W))

SELECT ROUND(SQRT(POWER((MAX(LAT_N) - MIN(LAT_N)),2) + POWER((MAX(LONG_W)- MIN(LONG_W)),2)),4) FROM STATION;