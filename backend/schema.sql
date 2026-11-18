PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS BankAccounts;
DROP TABLE IF EXISTS Investments;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Subscriptions;
DROP TABLE IF EXISTS UsersSubs;
DROP VIEW IF EXISTS bankTotals;

CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Username TEXT NOT NULL UNIQUE,
    Email TEXT UNIQUE,
    Password TEXT NOT NULL,
    TotalAmount REAL DEFAULT 0.00
);

CREATE TABLE BankAccounts (
    AccountID INTEGER PRIMARY KEY,
    UserID INTEGER,
    Amount REAL NOT NULL,
    AccountType TEXT NOT NULL,
    Interest TINYINT NOT NULL CHECK (Interest >= 0),

    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Investments (
    InvestmentID INTEGER PRIMARY KEY,
    UserID INTEGER,
    Name TEXT NOT NULL,
    EODPrice REAL,
    InvestType TEXT,
    BuyPrice REAL NOT NULL,

    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Loans (
    LoanID INTEGER PRIMARY KEY,
    UserID INTEGER,
    Amount REAL CHECK (Amount >= 0),
    Interest TINYINT CHECK (Interest > 0),
    LoanType TEXT,

    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Subscriptions (
    SubscriptionID INTEGER PRIMARY KEY,
    Name TEXT,
    Price Real NOT NULL CHECK (Price >= 0),
    LengthInDays INTEGER NOT NULL
);

CREATE TABLE UsersSubs (
    UserID INTEGER,
    SubscriptionID INTEGER,
    DateInDays INTEGER,
    Year INTEGER,

    PRIMARY KEY (UserID, SubscriptionID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscriptions(SubscriptionID)
);

CREATE VIEW bankTotals AS
    SELECT UserID, SUM(Amount) AS total
    FROM BankAccounts
    GROUP BY UserID;