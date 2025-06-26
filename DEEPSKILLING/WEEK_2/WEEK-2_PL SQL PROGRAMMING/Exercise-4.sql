CREATE OR REPLACE FUNCTION CalculateAge(p_dob DATE) RETURN NUMBER IS
    v_age NUMBER;
BEGIN
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
    RETURN v_age;
END;
/
SET SERVEROUTPUT ON;

DECLARE
    v_age NUMBER;
BEGIN
    v_age := CalculateAge(TO_DATE('1985-05-15', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Age is: ' || v_age);
END;
/
CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment(
    p_loanAmount NUMBER,
    p_interestRate NUMBER,
    p_durationYears NUMBER
) RETURN NUMBER IS
    v_monthlyRate NUMBER;
    v_months NUMBER;
    v_emi NUMBER;
BEGIN
    v_monthlyRate := p_interestRate / 12 / 100;
    v_months := p_durationYears * 12;

    v_emi := (p_loanAmount * v_monthlyRate * POWER(1 + v_monthlyRate, v_months)) /
             (POWER(1 + v_monthlyRate, v_months) - 1);

    RETURN ROUND(v_emi, 2);
END;
/
DECLARE
    v_emi NUMBER;
BEGIN
    v_emi := CalculateMonthlyInstallment(5000, 5, 5);
    DBMS_OUTPUT.PUT_LINE('Monthly EMI is: ' || v_emi);
END;
/
CREATE OR REPLACE FUNCTION HasSufficientBalance(
    p_accountID NUMBER,
    p_amount NUMBER
) RETURN BOOLEAN IS
    v_balance NUMBER;
BEGIN
    SELECT Balance INTO v_balance
    FROM Accounts
    WHERE AccountID = p_accountID;

    RETURN v_balance >= p_amount;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
/
DECLARE
    v_result BOOLEAN;
BEGIN
    v_result := HasSufficientBalance(1, 500);
    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('Sufficient balance available.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insufficient balance.');
    END IF;
END;
/
