SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
    UPDATE accounts
    SET balance = balance * 1.01,
        lastmodified = SYSDATE
    WHERE accounttype = 'Savings';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Monthly interest applied to all Savings accounts.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error applying interest: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department IN VARCHAR2,
    p_bonus_pct  IN NUMBER
) AS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_bonus_pct / 100)
    WHERE department = p_department;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees found in department ' || p_department);
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Bonus of ' || p_bonus_pct || '% applied to employees in ' || p_department);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error applying employee bonus: ' || SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_acc IN NUMBER,
    p_to_acc   IN NUMBER,
    p_amount   IN NUMBER
) AS
    v_balance NUMBER;
BEGIN
    SELECT balance INTO v_balance FROM accounts WHERE accountid = p_from_acc FOR UPDATE;

    IF v_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
    END IF;

    UPDATE accounts
    SET balance = balance - p_amount,
        lastmodified = SYSDATE
    WHERE accountid = p_from_acc;

    UPDATE accounts
    SET balance = balance + p_amount,
        lastmodified = SYSDATE
    WHERE accountid = p_to_acc;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transferred ₹' || p_amount || ' from account ' || p_from_acc || ' to ' || p_to_acc);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('One or both accounts not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error during fund transfer: ' || SQLERRM);
END;
/
BEGIN
    ProcessMonthlyInterest;
END;
/

BEGIN
    UpdateEmployeeBonus('IT', 10);
END;
/

BEGIN
    TransferFunds(1, 2, 200);
END;
/
