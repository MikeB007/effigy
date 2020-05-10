package com.effify.pics;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.sql.Statement;
import java.sql.ResultSet;


@SpringBootApplication
public class PicsApplication {
	public static void main(String[] args) {
		SpringApplication.run(PicsApplication.class, args);
	}
}
