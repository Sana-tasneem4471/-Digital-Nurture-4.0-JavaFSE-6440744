-- Enable output
SET SERVEROUTPUT ON;

-- Drop existing tables (optional cleanup)
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Transactions';
  EXECUTE IMMEDIATE 'DROP TABLE Accounts';
  EXECUTE IMMEDIATE 'DROP TABLE Loans';
  EXECUTE IMMEDIATE 'DROP TABLE Employees';
  EXECUTE IMMEDIATE 'DROP TABLE Customers';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

-- Create Tables
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    DOB DATE,
    Balance NUMBER,
    LastModified DATE
);

CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    AccountType VARCHAR2(20),
    Balance NUMBER,
    LastModified DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID NUMBER PRIMARY KEY,
    AccountID NUMBER,
    TransactionDate DATE,
    Amount NUMBER,
    TransactionType VARCHAR2(10),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Loans (
    LoanID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    LoanAmount NUMBER,
    InterestRate NUMBER,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Position VARCHAR2(50),
    Salary NUMBER,
    Department VARCHAR2(50),
    HireDate DATE
);

-- Insert Sample Data
INSERT INTO Customers VALUES (1, 'John Doe', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 1000, SYSDATE);
INSERT INTO Customers VALUES (2, 'Jane Smith', TO_DATE('1990-07-20', 'YYYY-MM-DD'), 1500, SYSDATE);

INSERT INTO Accounts VALUES (1, 1, 'Savings', 1000, SYSDATE);
INSERT INTO Accounts VALUES (2, 2, 'Checking', 1500, SYSDATE);

INSERT INTO Transactions VALUES (1, 1, SYSDATE, 500, 'Deposit');
INSERT INTO Transactions VALUES (2, 2, SYSDATE, 300, 'Withdrawal');

-- ✅ Insert sample Loan (Scenario 3)
INSERT INTO Loans VALUES (1, 1, 5000, 5, SYSDATE, ADD_MONTHS(SYSDATE, 60));

-- Optional: Employees
INSERT INTO Employees VALUES (1, 'Alice Johnson', 'Manager', 70000, 'HR', TO_DATE('2015-06-15', 'YYYY-MM-DD'));
INSERT INTO Employees VALUES (2, 'Bob Brown', 'Developer', 60000, 'IT', TO_DATE('2017-03-20', 'YYYY-MM-DD'));

COMMIT;

-- 🔹 Scenario 1: Monthly Statements
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Monthly Statements for Current Month ---');

  FOR cust IN (SELECT CustomerID, Name FROM Customers) LOOP
    DBMS_OUTPUT.PUT_LINE('Customer: ' || cust.Name || ' (ID: ' || cust.CustomerID || ')');

    FOR txn IN (
      SELECT T.TransactionDate, T.Amount, T.TransactionType
      FROM Transactions T
      JOIN Accounts A ON T.AccountID = A.AccountID
      WHERE A.CustomerID = cust.CustomerID
        AND TO_CHAR(T.TransactionDate, 'MMYYYY') = TO_CHAR(SYSDATE, 'MMYYYY')
      ORDER BY T.TransactionDate
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(
        '  Date: ' || TO_CHAR(txn.TransactionDate, 'YYYY-MM-DD') ||
        ' | Type: ' || txn.TransactionType ||
        ' | Amount: ' || txn.Amount
      );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
  END LOOP;
END;
/

-- 🔹 Scenario 2: Apply Annual Fee to All Accounts
DECLARE
  CURSOR acc_cursor IS
    SELECT AccountID, Balance FROM Accounts;

  v_account_id Accounts.AccountID%TYPE;
  v_balance    Accounts.Balance%TYPE;
BEGIN
  FOR acc_rec IN acc_cursor LOOP
    v_account_id := acc_rec.AccountID;
    v_balance := acc_rec.Balance;

    UPDATE Accounts
    SET Balance = Balance - 100,
        LastModified = SYSDATE
    WHERE AccountID = v_account_id;

    DBMS_OUTPUT.PUT_LINE('Annual fee applied to Account ID: ' || v_account_id ||
                         ' | Old Balance: ' || v_balance ||
                         ' | New Balance: ' || (v_balance - 100));
  END LOOP;
  COMMIT;
END;
/

-- 🔹 Scenario 3: Update Loan Interest Rates
DECLARE
  CURSOR loan_cursor IS
    SELECT LoanID, InterestRate FROM Loans;

  v_new_rate NUMBER;
  v_found BOOLEAN := FALSE;
BEGIN
  FOR loan_rec IN loan_cursor LOOP
    v_found := TRUE;

    IF loan_rec.InterestRate < 6 THEN
      v_new_rate := loan_rec.InterestRate + 1;
    ELSE
      v_new_rate := loan_rec.InterestRate + 0.5;
    END IF;

    UPDATE Loans
    SET InterestRate = v_new_rate
    WHERE LoanID = loan_rec.LoanID;

    DBMS_OUTPUT.PUT_LINE('Loan ID: ' || loan_rec.LoanID ||
                         ' | Old Rate: ' || loan_rec.InterestRate ||
                         ' | New Rate: ' || v_new_rate);
  END LOOP;

  IF NOT v_found THEN
    DBMS_OUTPUT.PUT_LINE('No loans found in the table.');
  END IF;

  COMMIT;
END;
/

-- 🔍 Verify Updated Loans
SELECT * FROM Loans;
