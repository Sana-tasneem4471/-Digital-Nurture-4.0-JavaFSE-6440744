package com.example.demo;

public class Account {

    private String number;
    private String type;
    private int balance;

    // Constructor
    public Account(String number, String type, int balance) {
        this.number = number;
        this.type = type;
        this.balance = balance;
    }

    // Getters
    public String getNumber() {
        return number;
    }

    public String getType() {
        return type;
    }

    public int getBalance() {
        return balance;
    }
}
