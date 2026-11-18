PRAGMA foreign_keys = ON;
.mode box

-- Questions/Reports that were answered by Queries
-- Database will report how much money the user currently has in an Account [Query 6]
-- Database will report how much money a user is spending for a given time period. [Query 4]
-- Does a person have enough money to cover their subscription payments? [Query 7]
-- How much does a person have in assets? [Query 9]

-- Query 1. Filtering and Sorting
-- AccountID of Savings Accounts
SELECT AccountID
FROM BankAccounts
WHERE AccountType = 'Savings'
ORDER BY Amount;

-- Query 2. INNER JOIN
-- People who have a checking account
SELECT Name
FROM Users AS u
JOIN BankAccounts AS b
    ON u.UserID = b.UserID
WHERE AccountType = 'Checking';

-- Query 3. LEFT JOIN
-- People having loans and all the loans they have
SELECT u.Name, l.LoanType
FROM Users AS u
LEFT JOIN Loans AS l
    ON u.UserID = l.UserID;

-- Query 4. Three-Table Join
-- Sum of a person's subscriptions per day
SELECT u.Name, SUM(s.Price / s.LengthInDays) AS PricePerDay
FROM UsersSubs AS us
JOIN Subscriptions AS s
    ON us.SubscriptionID = s.SubscriptionID
JOIN Users AS u
    ON u.UserID = us.UserID
GROUP BY us.UserID;

-- Query 5. Aggregate Query
-- The number of subscriptions all users have
SELECT u.Name, COUNT(us.SubscriptionID) AS num_of_subs
FROM Users AS u
LEFT JOIN UsersSubs AS us
    ON u.UserID = us.UserID
GROUP BY u.UserID;

-- Query 6. GROUP BY and HAVING
-- Amount of money in Everyone's Savings accounts (if any)
SELECT u.Name, b.Amount
FROM Users AS u
JOIN BankAccounts AS b
    ON u.UserID = b.UserID
GROUP BY b.AccountID
HAVING AccountType = 'Savings';

-- Query 7. Subquery
-- Listing everyone who has enough to pay for their subscriptions
SELECT u.Name, SUM(b.Amount) AS SubscriptionAmount
FROM Users AS u
LEFT JOIN BankAccounts AS b
    ON u.UserID = b.UserID
WHERE b.Amount > (
    SELECT SUM(s.Price)
    FROM UsersSubs AS us
    JOIN Subscriptions AS s
        ON us.SubscriptionID = s.SubscriptionID
    JOIN Users AS u
        ON u.UserID = us.UserID
    GROUP BY us.UserID
)
GROUP BY u.UserID;

-- Query 8. Set Operation
-- People who have both an investment and loan
SELECT u.Name
FROM Users AS u
JOIN Investments AS i
    ON i.UserID = u.UserID
INTERSECT
SELECT u.Name
FROM Users AS u
JOIN Loans AS l
    ON l.UserID = u.UserID;

-- Query 9. View
-- Total Amount in User's Assets
SELECT u.Name, SUM(v.total + i.BuyPrice) AS total
FROM Users AS u
JOIN bankTotals AS v
    ON u.UserID = v.UserID
JOIN Investments AS i
    ON i.UserID = u.UserID
GROUP BY u.UserID;