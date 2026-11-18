from flask import Flask, jsonify, render_template, abort, redirect, request, url_for
import sqlite3
from pathlib import Path
from datetime import date, timedelta

app = Flask(__name__)
PORT = 3015
DB = Path(__file__).resolve().parent.parent / 'backend' / 'financeWebsite.db'

def get_db_conn():
    conn = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row
    return conn

def format_day_of_year(day_number, year):
    if day_number is None or year is None:
        return 'Date unavailable'
    try:
        subscription_date = date(int(year), 1, 1) + timedelta(days=int(day_number) - 1)
    except (TypeError, ValueError, OverflowError):
        return 'Date unavailable'
    if subscription_date.year != int(year):
        return 'Date unavailable'
    return f'{subscription_date.strftime("%B")} {subscription_date.day}, {subscription_date.year}'

@app.route('/')
def here():
    return '<h1>Hello World</h1>'

@app.route('/homepage')
def home():
    return render_template('homepage.html')

@app.route('/login')
def loginpage():
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signuppage():
    if request.method == 'GET':
        return render_template('signup.html')

    name = request.form.get('name', '').strip()
    email = request.form.get('email', '').strip()
    username = request.form.get('username', '').strip()
    password = request.form.get('password', '')

    if not all((name, email, username, password)):
        return render_template(
            'signup.html',
            error='All fields are required.',
            entered_name=name,
            entered_email=email,
            entered_username=username,
        ), 400

    conn = get_db_conn()
    try:
        conn.execute(
            """
            INSERT INTO Users (Name, Email, Username, Password)
            VALUES (?, ?, ?, ?)
            """,
            (name, email, username, password),
        )
        conn.commit()
    except sqlite3.IntegrityError:
        conn.rollback()
        return render_template(
            'signup.html',
            error='That email or username is already in use.',
            entered_name=name,
            entered_email=email,
            entered_username=username,
        ), 409
    finally:
        conn.close()

    return redirect(url_for('loginpage'))

@app.route('/login-attempt', methods=['POST'])
def login_attempt():
    username = request.form.get('username', '').strip()
    password = request.form.get('password', '')

    conn = get_db_conn()
    columns = {row['name'] for row in conn.execute('PRAGMA table_info(Users)')}
    login_column = 'Username' if 'Username' in columns else 'Email'
    query = f"""
        SELECT UserID
        FROM Users
        WHERE {login_column} = ? AND Password = ?
        LIMIT 1
    """
    user = conn.execute(query, (username, password)).fetchone()
    conn.close()

    if not user:
        return render_template(
            'login.html',
            error='Invalid username or password.',
            entered_username=username,
        ), 401

    return redirect(url_for('account', user_id=user['UserID']))

@app.route('/account/<user_id>')
def account(user_id):
    conn = get_db_conn()
    query = "SELECT UserID, Name FROM Users WHERE UserID = ?"
    info = conn.execute(query, (user_id,)).fetchone()
    if not info:
        conn.close()
        abort(404)
    total_balance = conn.execute(
        """
        SELECT SUM(ba.Amount + i.EODPrice)
        FROM BankAccounts AS ba
        JOIN Investments AS i
            ON i.UserID = ba.UserID
        WHERE ba.UserID = ?
        """,
        (user_id,),
    ).fetchone()[0]
    monthly_costs = conn.execute(
        """
        SELECT COALESCE(SUM(s.Price * 30.0 / s.LengthInDays), 0)
        FROM UsersSubs AS us
        JOIN Subscriptions AS s
          ON s.SubscriptionID = us.SubscriptionID
        WHERE us.UserID = ?
        """,
        (user_id,),
    ).fetchone()[0]
    loan_interest = conn.execute(
        """
        SELECT COALESCE(SUM(Amount * Interest / 100.0 / 12.0), 0)
        FROM Loans
        WHERE UserID = ?
        """,
        (user_id,),
    ).fetchone()[0]
    bank_interest = conn.execute(
        """
        SELECT COALESCE(SUM(Amount * Interest / 100.0 / 12.0), 0)
        FROM BankAccounts
        WHERE UserID = ?
        """,
        (user_id,),
    ).fetchone()[0]
    investment_income = conn.execute(
        """
        SELECT COALESCE(SUM(COALESCE(EODPrice, BuyPrice) - BuyPrice), 0)
        FROM Investments
        WHERE UserID = ?
        """,
        (user_id,),
    ).fetchone()[0]
    conn.close()
    dashboard_info = {
        **dict(info),
        'Balance': total_balance,
        'MonthlyCosts': monthly_costs + loan_interest,
        'MonthlyIncome': bank_interest + investment_income,
    }
    return render_template('account.html', info=dashboard_info)

@app.route('/subscriptions/<user_id>')
def subscriptions(user_id):
    conn = get_db_conn()
    user = conn.execute(
        "SELECT Name FROM Users WHERE UserID = ?",
        (user_id,),
    ).fetchone()
    if not user:
        conn.close()
        abort(404)

    user_subscriptions = conn.execute(
        """
        SELECT Subscriptions.Name, Subscriptions.Price,
               Subscriptions.LengthInDays, UsersSubs.DateInDays,
               UsersSubs.Year
        FROM UsersSubs
        JOIN Subscriptions
          ON Subscriptions.SubscriptionID = UsersSubs.SubscriptionID
        WHERE UsersSubs.UserID = ?
        ORDER BY Subscriptions.Name
        """,
        (user_id,),
    ).fetchall()
    conn.close()
    user_subscriptions = [
        {
            **dict(subscription),
            'RenewalDate': format_day_of_year(
                subscription['DateInDays'],
                subscription['Year'],
            ),
        }
        for subscription in user_subscriptions
    ]
    return render_template(
        'subscriptions.html',
        user=user,
        subscriptions=user_subscriptions,
        user_id=user_id,
    )

def get_user_and_rows(user_id, query):
    conn = get_db_conn()
    user = conn.execute(
        "SELECT Name FROM Users WHERE UserID = ?",
        (user_id,),
    ).fetchone()
    if not user:
        conn.close()
        abort(404)
    rows = conn.execute(query, (user_id,)).fetchall()
    conn.close()
    return user, rows

@app.route('/bank-accounts/<user_id>')
@app.route('/bank-accounts/<user_id>', methods=['POST'])
def bank_accounts(user_id):
    if request.method == 'POST':
        get_user_and_rows(user_id, "SELECT 1 FROM Users WHERE UserID = ?")
        account_type = request.form.get('account_type', '').strip()
        try:
            amount = float(request.form.get('amount', ''))
            interest = float(request.form.get('interest', ''))
            if not account_type or amount < 0 or interest < 0:
                raise ValueError
        except ValueError:
            return render_bank_accounts(user_id, 'Enter a valid account type, amount, and interest rate.'), 400
        conn = get_db_conn()
        try:
            conn.execute(
                """
                INSERT INTO BankAccounts (UserID, Amount, AccountType, Interest)
                VALUES (?, ?, ?, ?)
                """,
                (user_id, amount, account_type, interest),
            )
            conn.commit()
        finally:
            conn.close()
        return redirect(url_for('bank_accounts', user_id=user_id))

    return render_bank_accounts(user_id)

def render_bank_accounts(user_id, error=None):
    user, accounts = get_user_and_rows(
        user_id,
        """
        SELECT AccountID, Amount, AccountType, Interest
        FROM BankAccounts
        WHERE UserID = ?
        ORDER BY AccountType, AccountID
        """,
    )
    return render_template(
        'bank_accounts.html',
        user=user,
        accounts=accounts,
        user_id=user_id,
        error=error,
    )

@app.route('/bank-accounts/<user_id>/delete/<int:account_id>', methods=['POST'])
def delete_bank_account(user_id, account_id):
    conn = get_db_conn()
    try:
        conn.execute(
            """
            DELETE FROM BankAccounts
            WHERE AccountID = ? AND UserID = ?
            """,
            (account_id, user_id),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for('bank_accounts', user_id=user_id))

@app.route('/investments/<user_id>')
@app.route('/investments/<user_id>', methods=['POST'])
def investments(user_id):
    if request.method == 'POST':
        get_user_and_rows(user_id, "SELECT 1 FROM Users WHERE UserID = ?")
        name = request.form.get('name', '').strip()
        invest_type = request.form.get('invest_type', '').strip()
        eod_price_text = request.form.get('eod_price', '').strip()
        try:
            buy_price = float(request.form.get('buy_price', ''))
            eod_price = float(eod_price_text) if eod_price_text else None
            if not name or buy_price < 0 or (eod_price is not None and eod_price < 0):
                raise ValueError
        except ValueError:
            return render_investments(user_id, 'Enter a valid name and price.'), 400
        conn = get_db_conn()
        try:
            conn.execute(
                """
                INSERT INTO Investments (UserID, Name, EODPrice, InvestType, BuyPrice)
                VALUES (?, ?, ?, ?, ?)
                """,
                (user_id, name, eod_price, invest_type or None, buy_price),
            )
            conn.commit()
        finally:
            conn.close()
        return redirect(url_for('investments', user_id=user_id))

    return render_investments(user_id)

def render_investments(user_id, error=None):
    user, user_investments = get_user_and_rows(
        user_id,
        """
        SELECT InvestmentID, Name, EODPrice, InvestType, BuyPrice
        FROM Investments
        WHERE UserID = ?
        ORDER BY Name
        """,
    )
    return render_template(
        'investments.html',
        user=user,
        investments=user_investments,
        user_id=user_id,
        error=error,
    )

@app.route('/investments/<user_id>/delete/<int:investment_id>', methods=['POST'])
def delete_investment(user_id, investment_id):
    conn = get_db_conn()
    try:
        conn.execute(
            """
            DELETE FROM Investments
            WHERE InvestmentID = ? AND UserID = ?
            """,
            (investment_id, user_id),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for('investments', user_id=user_id))

@app.route('/loans/<user_id>')
@app.route('/loans/<user_id>', methods=['POST'])
def loans(user_id):
    if request.method == 'POST':
        get_user_and_rows(user_id, "SELECT 1 FROM Users WHERE UserID = ?")
        loan_type = request.form.get('loan_type', '').strip()
        try:
            amount = float(request.form.get('amount', ''))
            interest = float(request.form.get('interest', ''))
            if amount < 0 or interest <= 0:
                raise ValueError
        except ValueError:
            return render_loans(user_id, 'Enter a valid loan type, amount, and interest rate.'), 400
        conn = get_db_conn()
        try:
            conn.execute(
                """
                INSERT INTO Loans (UserID, Amount, Interest, LoanType)
                VALUES (?, ?, ?, ?)
                """,
                (user_id, amount, interest, loan_type or None),
            )
            conn.commit()
        finally:
            conn.close()
        return redirect(url_for('loans', user_id=user_id))

    return render_loans(user_id)

def render_loans(user_id, error=None):
    user, user_loans = get_user_and_rows(
        user_id,
        """
        SELECT LoanID, Amount, Interest, LoanType
        FROM Loans
        WHERE UserID = ?
        ORDER BY LoanType
        """,
    )
    return render_template(
        'loans.html',
        user=user,
        loans=user_loans,
        user_id=user_id,
        error=error,
    )

@app.route('/loans/<user_id>/delete/<int:loan_id>', methods=['POST'])
def delete_loan(user_id, loan_id):
    conn = get_db_conn()
    try:
        conn.execute(
            """
            DELETE FROM Loans
            WHERE LoanID = ? AND UserID = ?
            """,
            (loan_id, user_id),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for('loans', user_id=user_id))

if __name__ == "__main__":
    app.run(port=PORT, debug=True)