# A FINANCE WEBSITE
Created by Parker Dawes

# Information
## Description:
The following is a relational database system.
There are seven tables in this database: 
  Users, BankAccounts, Investments,
  Loans, Subscriptions, UsersSubs

## To Use:
  * move to frontend folder
  * run 'python app.py'
  * go to 'localhost:3015/homepage'

  If a reset of database is needed
  * To go '/backend'
  * run run_queries.sh script

# Meaningful Queries
1. *SELECT* SUM(ba.Amount + i.EODPrice)
  FROM BankAccounts AS ba
  JOIN Investments AS i
      ON i.UserID = ba.UserID
  WHERE ba.UserID = ?
2. SELECT COALESCE(SUM(s.Price * 30.0 / s.LengthInDays), 0)
  FROM *UsersSubs* AS us
  JOIN *Subscriptions* AS s
    ON s.SubscriptionID = us.SubscriptionID
  WHERE us.UserID = ?
3. *INSERT* INTO BankAccounts (UserID, Amount, AccountType, Interest)
  VALUES (?, ?, ?, ?)
4. *DELETE* FROM BankAccounts
  WHERE AccountID = ? AND UserID = ?
5. SELECT AccountID, Amount, AccountType, Interest
  FROM BankAccounts
  *WHERE* UserID = ?
  *ORDER BY* AccountType, AccountID
6. SELECT *SUM* (ba.Amount + i.EODPrice) 
  FROM BankAccounts AS ba
  JOIN Investments AS i
      ON i.UserID = ba.UserID
  WHERE ba.UserID = ?

# Each Table's Attributes
* Updated ER diagram provided

## Users:
  * UserID - PK INTEGER
  * Name - TEXT NOT NULL
  * Email - TEXT UNIQUE
  * Password - TEXT NOT NULL
  * TotalAmount - REAL DEFAULT 0.00

## BankAccounts:
  * AccountID - PK INTEGER
  * UserID - FK INTEGER
  * Amount - REAL NOT NULL
  * AccountType - TEXT NOT NULL
  * Interest - TINYINT NOT NULL CHECK (Interest >= 0)

## Investments:
  * InvestmentID - PK INTEGER
  * UserID INTEGER
  * Name TEXT NOT NULL
  * EODPrice REAL
  * InvestType TEXT
  * BuyPrice REAL NOT NULL

## Loans:
  * LoanID - PK INTEGER
  * UserID INTEGER
  * Amount REAL CHECK (Amount >= 0)
  * Interest TINYINT CHECK (Interest > 0)
  * LoanType TEXT

## Subscriptions:
  * SubscriptionID - PK INTEGER
  * Name TEXT
  * Price Real NOT NULL CHECK (Price >= 0)
  * LengthInDays INTEGER NOT NULL

## UsersSubs:
  * UserID - FK INTEGER
  * SubscriptionID - FK INTEGER
  * DateInDays INTEGER
  * Year INTEGER

# Note of AI Usage
Co-Pilot was used in the frontend of this program
as mentioned was allowed to create a neat application.

An end-to-end solution with sql was created and
AI was asked to make a clean frontend with the sql 
and html/css that was already provided. 
AI created a clean UI, and it did add COALESCE to 
some sql queries for display reasons in the frontend 
as well as some if/else statements in the html files.