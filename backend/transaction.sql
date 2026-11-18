PRAGMA foreign_keys = ON;

-- Transaction:
-- Adds MSFT Stock if the User has enough in their bank account
-- Values to insert are hard-coded into this example.
BEGIN;

-- Inserts Here
INSERT INTO Investments (UserID, Name, InvestType, BuyPrice)
SELECT 3, 'MSFT', 'Stock', 390
-- Checks whether there is enough in combined accounts
WHERE EXISTS (
    SELECT 1
    FROM Users AS u
    JOIN bankTotals AS v
        ON u.UserID = v.UserID
    WHERE u.UserID = 3
    GROUP BY u.UserID
    HAVING SUM(v.total) >= 390
);

-- Updates one bank account
UPDATE BankAccounts
SET Amount = (Amount - 390)
-- Finds one bank account to subtraact from
WHERE rowid = (
    SELECT rowid
    FROM BankAccounts
    WHERE UserID = 3
    GROUP BY UserID
    LIMIT 1
)
-- Same check to make sure there is enough money
AND EXISTS (
    SELECT 1
    FROM Users AS u
    JOIN bankTotals AS v
        ON u.UserID = v.UserID
    WHERE u.UserID = 3
    GROUP BY u.UserID
    HAVING SUM(v.total) >= 390
);

-- For test this rollbacks no matter what
ROLLBACK;
