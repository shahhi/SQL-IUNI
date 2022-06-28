/*
Author : Himani Shah (shahhi@iu.edu)

CREATE TABLE user;
CREATE TABLE user_answers;

users
—-----
*userID integer
Initials text unique
Fullname text
 
user_answers
—----------------
userID integer
*answerID integer
Attempt integer
isCorrect boolean


* A correct answer counts as 1 point and incorrect answer counts as 0 points.  
* A question that has not been answered does not count towards the score.  
* Users may attempt the quiz multiple times.  
* The total score for an attempt will be a percentage of correct answers to total answers.

*/

-- Write a SQL query that gets the attempt for each user that has the highest score amongst all of that user’s attempts.

SELECT u.* , 100 * COUNT(*) FILTER (WHERE isCorrect)/COUNT(isCorrect) AS finalScore
FROM users i
INNER JOIN (SELECT u.* 
            ROW_NUMBER() OVER 
            (PARTITION BY userID
            ORDER BY finalScore DESC) AS r
            FROM user_answers u
            ) u
ON i.userID = u.userID
WHERE r = 1;

-- Write a SQL query that fetches all attempts and total scores for each attempt for a given user, defined by that user’s initials.  


SELECT u.* , 100 * COUNT(*) FILTER (WHERE isCorrect)/COUNT(isCorrect) AS finalScore
FROM users i
INNER JOIN user_answers u
ON i.userID = u.userID
GROUP BY Initials;

-- Write a SQL query that will update the user’s initials based on their fullname. 

UPDATE users i
SET i.Initials = (
SELECT substring(Fullname,1,1) + substring(Fullname,charindex(' ',Fullname)+1,1) AS updateInitials 
FROM users u
WHERE i.userID = u.userID
);

-- Restructure the schema (if necessary) to optimize the above queries (make the queries simpler, run faster, etc)

/* 
We can use schemas to logically divide data for faster retrival and separate Domains. 
Even though complexity increases there is trade off with organizing into logical and more manageable groups.

I propose to genrate a new table in schema using user and user_answer tables. 
And keep updating the the table when a new entry is added to user_answer that has new finalScore greater then old finalScore.

CREATE TABLE update_answers

user_answers
—----------------

*userID integer
Attempt integer
finalScore integer

*/
