SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE CustomerManagement IS
  PROCEDURE AddCustomer(p_id NUMBER, p_name VARCHAR2, p_dob DATE, p_balance NUMBER);
  PROCEDURE UpdateCustomer(p_id NUMBER, p_name VARCHAR2, p_dob DATE);
  FUNCTION GetCustomerBalance(p_id NUMBER) RETURN NUMBER;
END CustomerManagement;
/
CREATE OR REPLACE PACKAGE BODY CustomerManagement IS

  PROCEDURE AddCustomer(p_id NUMBER, p_name VARCHAR2, p_dob DATE, p_balance NUMBER) IS
  BEGIN
    INSERT INTO Customers VALUES (p_id, p_name, p_dob, p_balance, SYSDATE);
  END;

  PROCEDURE UpdateCustomer(p_id NUMBER, p_name VARCHAR2, p_dob DATE) IS
  BEGIN
    UPDATE Customers
    SET Name = p_name,
        DOB = p_dob,
        LastModified = SYSDATE
    WHERE CustomerID = p_id;
  END;

  FUNCTION GetCustomerBalance(p_id NUMBER) RETURN NUMBER IS
    v_balance NUMBER;
  BEGIN
    SELECT Balance INTO v_balance FROM Customers WHERE CustomerID = p_id;
    RETURN v_balance;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END;

END CustomerManagement;
/
CREATE OR REPLACE PACKAGE EmployeeManagement IS
  PROCEDURE HireEmployee(p_id NUMBER, p_name VARCHAR2, p_position VARCHAR2, p_salary NUMBER, p_dept VARCHAR2, p_hire DATE);
  PROCEDURE UpdateEmployee(p_id NUMBER, p_salary NUMBER);
  FUNCTION CalculateAnnualSalary(p_id NUMBER) RETURN NUMBER;
END EmployeeManagement;
/
CREATE OR REPLACE PACKAGE BODY EmployeeManagement IS

  PROCEDURE HireEmployee(p_id NUMBER, p_name VARCHAR2, p_position VARCHAR2, p_salary NUMBER, p_dept VARCHAR2, p_hire DATE) IS
  BEGIN
    INSERT INTO Employees VALUES (p_id, p_name, p_position, p_salary, p_dept, p_hire);
  END;

  PROCEDURE UpdateEmployee(p_id NUMBER, p_salary NUMBER) IS
  BEGIN
    UPDATE Employees
    SET Salary = p_salary
    WHERE EmployeeID = p_id;
  END;

  FUNCTION CalculateAnnualSalary(p_id NUMBER) RETURN NUMBER IS
    v_salary NUMBER;
  BEGIN
    SELECT Salary INTO v_salary FROM Employees WHERE EmployeeID = p_id;
    RETURN v_salary * 12;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END;

END EmployeeManagement;
/
CREATE OR REPLACE PACKAGE AccountOperations IS
  PROCEDURE OpenAccount(p_id NUMBER, p_cust_id NUMBER, p_type VARCHAR2, p_balance NUMBER);
  PROCEDURE CloseAccount(p_id NUMBER);
  FUNCTION GetTotalBalance(p_cust_id NUMBER) RETURN NUMBER;
END AccountOperations;
/
CREATE OR REPLACE PACKAGE BODY AccountOperations IS

  PROCEDURE OpenAccount(p_id NUMBER, p_cust_id NUMBER, p_type VARCHAR2, p_balance NUMBER) IS
  BEGIN
    INSERT INTO Accounts VALUES (p_id, p_cust_id, p_type, p_balance, SYSDATE);
  END;

  PROCEDURE CloseAccount(p_id NUMBER) IS
  BEGIN
    DELETE FROM Accounts WHERE AccountID = p_id;
  END;

  FUNCTION GetTotalBalance(p_cust_id NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(Balance), 0) INTO v_total
    FROM Accounts
    WHERE CustomerID = p_cust_id;
    RETURN v_total;
  END;

END AccountOperations;
/
-- Add a new customer
BEGIN
  CustomerManagement.AddCustomer(3, 'Robert Green', TO_DATE('1992-08-20', 'YYYY-MM-DD'), 2000);
END;
/

-- Update existing customer
BEGIN
  CustomerManagement.UpdateCustomer(3, 'Robert G', TO_DATE('1992-08-20', 'YYYY-MM-DD'));
END;
/

-- Show customer balance
DECLARE
  v_bal NUMBER;
BEGIN
  v_bal := CustomerManagement.GetCustomerBalance(3);
  DBMS_OUTPUT.PUT_LINE('Customer 3 Balance: ' || v_bal);
END;
/

-- Hire a new employee
BEGIN
  EmployeeManagement.HireEmployee(3, 'Sarah Miles', 'Analyst', 50000, 'Finance', SYSDATE);
END;
/

-- Show annual salary
DECLARE
  v_salary NUMBER;
BEGIN
  v_salary := EmployeeManagement.CalculateAnnualSalary(3);
  DBMS_OUTPUT.PUT_LINE('Employee 3 Annual Salary: ' || v_salary);
END;
/

-- Open a new account
BEGIN
  AccountOperations.OpenAccount(3, 3, 'Savings', 1200);
END;
/

-- Get total balance across accounts
DECLARE
  v_total NUMBER;
BEGIN
  v_total := AccountOperations.GetTotalBalance(3);
  DBMS_OUTPUT.PUT_LINE('Customer 3 Total Account Balance: ' || v_total);
END;
/

