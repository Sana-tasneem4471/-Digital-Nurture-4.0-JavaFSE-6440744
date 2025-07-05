package com.cognizant.ormlearn;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

import com.cognizant.ormlearn.model.Employee;
import com.cognizant.ormlearn.service.EmployeeService;

@SpringBootApplication
public class OrmLearnApplication {

    public static void main(String[] args) {
        ApplicationContext context = SpringApplication.run(OrmLearnApplication.class, args);

        EmployeeService employeeService = context.getBean(EmployeeService.class);

        Employee employee = new Employee();
        employee.setName("John");
        employee.setDepartment("HR");
        employee.setSalary(50000);

        employeeService.addEmployee(employee);

        System.out.println("Employee added: " + employee);
    }
}