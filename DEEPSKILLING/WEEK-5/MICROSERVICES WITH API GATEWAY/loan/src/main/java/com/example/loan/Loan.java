package com.example.loan;
public class Loan {
    private String number;
    private String type;
    private int loan;
    private int emi;
    private int tenure;

    // Constructor
    public Loan(String number, String type, int loan, int emi, int tenure) {
        this.number = number;
        this.type = type;
        this.loan = loan;
        this.emi = emi;
        this.tenure = tenure;
    }

    // Getters
    public String getNumber() { return number; }
    public String getType() { return type; }
    public int getLoan() { return loan; }
    public int getEmi() { return emi; }
    public int getTenure() { return tenure; }
}
