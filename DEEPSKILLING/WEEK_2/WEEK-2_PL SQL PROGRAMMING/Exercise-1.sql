-- Add a loan for 'Senior Citizen' (age > 60)
INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (3, 3, 8000, 6, SYSDATE, ADD_MONTHS(SYSDATE, 12)); -- not due in 30 days

-- Add a loan due in 10 days for 'Senior Citizen' to see reminder too
INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (4, 3, 2000, 6, SYSDATE, SYSDATE + 5);

-- Add a loan for 'Rich Person' (to show VIP flag update)
INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (5, 4, 15000, 6.5, SYSDATE, ADD_MONTHS(SYSDATE, 24));

COMMIT;
SET SERVEROUTPUT ON;

BEGIN
  -- Scenario 1: Apply 1% interest discount to customers over 60
  FOR rec IN (
    SELECT l.LoanID, l.InterestRate
    FROM Loans l
    JOIN Customers c ON l.CustomerID = c.CustomerID
    WHERE MONTHS_BETWEEN(SYSDATE, c.DOB)/12 > 60
  ) LOOP
    UPDATE Loans
    SET InterestRate = rec.InterestRate - 1
    WHERE LoanID = rec.LoanID;

    DBMS_OUTPUT.PUT_LINE('1% discount applied to LoanID ' || rec.LoanID);
  END LOOP;

  -- Scenario 2: Mark customers with balance > 10000 as VIP
  FOR rec IN (
    SELECT CustomerID, Balance FROM Customers
  ) LOOP
    IF rec.Balance > 10000 THEN
      UPDATE Customers
      SET IsVIP = 'T'
      WHERE CustomerID = rec.CustomerID;

      DBMS_OUTPUT.PUT_LINE('CustomerID ' || rec.CustomerID || ' marked as VIP.');
    ELSE
      UPDATE Customers
      SET IsVIP = 'F'
      WHERE CustomerID = rec.CustomerID;
    END IF;
  END LOOP;

  -- Scenario 3: Remind customers with loans due in 30 days
  FOR rec IN (
    SELECT c.Name, l.EndDate
    FROM Loans l
    JOIN Customers c ON c.CustomerID = l.CustomerID
    WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Reminder: Loan for customer ' || rec.Name ||
                         ' is due on ' || TO_CHAR(rec.EndDate, 'YYYY-MM-DD'));
  END LOOP;

  COMMIT;
END;
/
