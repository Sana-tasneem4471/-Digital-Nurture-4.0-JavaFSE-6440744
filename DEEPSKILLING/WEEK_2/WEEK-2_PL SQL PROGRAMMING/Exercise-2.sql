SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE SafeTransferFunds (
    p_from_acc_id IN NUMBER,
    p_to_acc_id   IN NUMBER,
    p_amount      IN NUMBER
) AS
    v_balance NUMBER;
BEGIN
    SELECT balance INTO v_balance FROM accounts WHERE accountid = p_from_acc_id FOR UPDATE;

    IF v_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds.');
    END IF;

    UPDATE accounts
    SET balance = balance - p_amount,
        lastmodified = SYSDATE
    WHERE accountid = p_from_acc_id;

    UPDATE accounts
    SET balance = balance + p_amount,
        lastmodified = SYSDATE
    WHERE accountid = p_to_acc_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Funds transferred from Account ' || p_from_acc_id || ' to Account ' || p_to_acc_id);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: One of the accounts does not exist.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error during transfer: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE UpdateSalary (
    p_emp_id  IN NUMBER,
    p_percent IN NUMBER
) AS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_percent / 100)
    WHERE employeeid = p_emp_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_emp_id || ' not found.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Salary increased by ' || p_percent || '% for Employee ID ' || p_emp_id);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE AddNewCustomer (
    p_customer_id IN NUMBER,
    p_name        IN VARCHAR2,
    p_dob         IN DATE,
    p_balance     IN NUMBER
) AS
BEGIN
    INSERT INTO customers (customerid, name, dob, balance, lastmodified)
    VALUES (p_customer_id, p_name, p_dob, p_balance, SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('New customer added successfully. ID: ' || p_customer_id);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Customer ID ' || p_customer_id || ' already exists.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error adding customer: ' || SQLERRM);
END;
/
-- Add a new customer with a unique ID
BEGIN
    AddNewCustomer(4, 'Divya Nair', TO_DATE('1990-12-01', 'YYYY-MM-DD'), 2200);
END;
/

-- Update salary for Employee ID 1 (already exists in sample data)
BEGIN
    UpdateSalary(1, 20);
END;
/

-- Transfer funds between two valid accounts
BEGIN
    SafeTransferFunds(1, 2, 100);
END;
/
