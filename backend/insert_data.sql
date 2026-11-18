PRAGMA foreign_keys = ON;

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Devang Jumbo', 'DevilDev', 'devil@gmail.com', 'whyShouldITellYou'
);

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Jason Dang', 'Wu865', 'dong@yahoo.com', 'laptopMyLove'
);

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Joplin Mills', 'VFLJop', 'VFLJop@yahoo.com', 'MouseMouse'
);

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Tyler Creator', 'Spooderman', 'JoJoB@gmail.com', 'RiVols'
);

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Colin One', 'YearningAsian', 'OneColin@gmail.com', 'NeedleInAHaystack'
);

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Kaden Biss', 'MidnightStalker', 'Gorgious@hotmail.com', 'BicycleHotline'
);

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Lucy Reynolds', 'BackAgo', 'GotMarried@yahoo.com', 'CalebDavid'
);

INSERT INTO Users (Name, Username, Email, Password) VALUES (
    'Candyman', 'Candy Dude', 'Candyland@hotmail.com', 'Candycane'
)

INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest) VALUES (
    2, 0, 'Checking', 0
);

INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest) VALUES (
    1, 500, 'Savings', 2
);

INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest) VALUES (
    4, 1000, 'Savings', 3
);

INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest) VALUES (
    4, 200, 'Checking', 0
);

INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest) VALUES (
    3, 1500, 'Checking', 1
);

INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest) VALUES (
    5, 100000, 'Savings', 3
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    2, 'MSFT', 'Stock', 470, 520
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    5, 'MSFT', 'Stock', 440, 520
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    2, 'NVDA', 'Stock', 220, 170
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    1, 'Treasury Bond', 'Bond', 100, 110
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    4, 'MSFT', 'Stock', 390, 520
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    4, 'Treasury Bond', 'Bond', 250, 275
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    3, 'Treasury Bond', 'Bond', 100, 120
);

INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES (
    5, 'Treasury Bond', 'Bond', 250, 300
);

INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES (
    1, 300000, 4, 'Mortgage'
);

INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES (
    1, 3000, 8, 'Car Loan'
);

INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES (
    3, 600000, 5, 'Mortgage'
);

INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES (
    4, 500000, 4, 'Mortgage'
);

INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES (
    2, 50000, 10, 'Car Loan'
);

INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES (
    2, 36000, 7, 'Car Loan'
);

INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES (
    2, 87000, 8, 'Car Loan'
);

INSERT INTO Subscriptions (Name, Price, LengthInDays) VALUES (
    'Netflix', 14.99, 30
);

INSERT INTO Subscriptions (Name, Price, LengthInDays) VALUES (
    'GrubHub+', 9.99, 30
);

INSERT INTO Subscriptions (Name, Price, LengthInDays) VALUES (
    'Annual CrunchyRoll', 89.99, 365
);

INSERT INTO Subscriptions (Name, Price, LengthInDays) VALUES (
    'Adult Coloring Monthly', 12.50, 30
);

INSERT INTO Subscriptions (Name, Price, LengthInDays) VALUES (
    'CatLadyBox', 38.33, 30
);

INSERT INTO Subscriptions (Name, Price, LengthInDays) VALUES (
    'Pickle Of The Month Club', 24.95, 30
);

INSERT INTO UsersSubs VALUES (
    1, 1, 6, 2025
);

INSERT INTO UsersSubs VALUES (
    2, 1, 17, 2023
);

INSERT INTO UsersSubs VALUES (
    3, 5, 264, 2024
);

INSERT INTO UsersSubs VALUES (
    4, 6, 317, 2020
);

INSERT INTO UsersSubs VALUES (
    2, 6, 166, 2023
);

INSERT INTO UsersSubs VALUES (
    1, 3, 97, 2025
);

INSERT INTO UsersSubs VALUES (
    5, 4, 162, 2022
);

INSERT INTO UsersSubs VALUES (
    5, 5, 65, 2026
);

INSERT INTO UsersSubs VALUES (
    5, 3, 195, 2016
);

INSERT INTO UsersSubs VALUES (
    5, 2, 345, 2023
);

-- Ten additional bank accounts
INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest) VALUES
    (1, 2500, 'Checking', 0),
    (2, 12000, 'Savings', 2),
    (3, 800, 'Savings', 1),
    (4, 3500, 'Checking', 0),
    (5, 75000, 'Money Market', 4),
    (6, 4200, 'Checking', 0),
    (6, 18500, 'Savings', 3),
    (7, 900, 'Checking', 0),
    (7, 6400, 'Savings', 2),
    (8, 1500, 'Checking', 0);

-- Ten additional investments
INSERT INTO Investments (UserID, Name, InvestType, BuyPrice, EODPrice) VALUES
    (1, 'AAPL', 'Stock', 180, 195),
    (2, 'VOO', 'ETF', 410, 425),
    (3, 'TSLA', 'Stock', 220, 205),
    (4, 'AMZN', 'Stock', 165, 178),
    (5, 'Municipal Bond', 'Bond', 1000, 1015),
    (6, 'GOOGL', 'Stock', 140, 152),
    (6, 'VTI', 'ETF', 250, 262),
    (7, 'Corporate Bond', 'Bond', 500, 508),
    (7, 'AMD', 'Stock', 125, 145),
    (8, 'International ETF', 'ETF', 75, 82);

-- Ten additional loans
INSERT INTO Loans (UserID, Amount, Interest, LoanType) VALUES
    (1, 15000, 6, 'Personal Loan'),
    (2, 12000, 9, 'Student Loan'),
    (3, 25000, 7, 'Home Improvement Loan'),
    (4, 18000, 8, 'Personal Loan'),
    (5, 22000, 6, 'Student Loan'),
    (6, 280000, 5, 'Mortgage'),
    (6, 15000, 9, 'Car Loan'),
    (7, 7500, 10, 'Personal Loan'),
    (7, 320000, 4, 'Mortgage'),
    (8, 9000, 8, 'Car Loan');

-- Ten additional subscriptions
INSERT INTO Subscriptions (Name, Price, LengthInDays) VALUES
    ('Spotify', 11.99, 30),
    ('Hulu', 17.99, 30),
    ('Cloud Storage', 2.99, 30),
    ('Gym Membership', 29.99, 30),
    ('Meal Kit Service', 59.99, 30),
    ('News Subscription', 8.99, 30),
    ('Music Lessons', 80.00, 30),
    ('Language App', 12.99, 30),
    ('Movie Streaming', 15.99, 30),
    ('Magazine Subscription', 6.99, 30);

-- Ten additional user subscriptions
INSERT INTO UsersSubs (UserID, SubscriptionID, DateInDays, Year) VALUES
    (1, 7, 22, 2026),
    (2, 8, 45, 2026),
    (3, 9, 68, 2026),
    (4, 10, 91, 2026),
    (5, 11, 114, 2026),
    (6, 12, 137, 2026),
    (6, 13, 160, 2026),
    (7, 14, 183, 2026),
    (7, 15, 206, 2026),
    (8, 16, 229, 2026);