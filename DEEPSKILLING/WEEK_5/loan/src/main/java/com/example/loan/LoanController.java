package com.example.loan;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoanController {

	@GetMapping("/loans/{number}")
	public Loan getLoanDetails(@PathVariable("number") String number) {
	    return new Loan("H00987987972342", "car", 400000, 3258, 18);
	}

}
