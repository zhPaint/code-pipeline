package com.revature.controller;

import javax.servlet.http.HttpServletRequest;

import com.revature.model.Customer;

public class HomeControllerAlpha implements HomeController {

	private static HomeController homeController = new HomeControllerAlpha();
	
	private HomeControllerAlpha() {}
	
	public static HomeController getInstance() {
		return homeController;
	}
	
	@Override
	public String home(HttpServletRequest request) {
		Customer loggedCustomer = (Customer) request.getSession().getAttribute("loggedCustomer");
		
		/* If customer is not logged in */
		if(loggedCustomer == null) {
			return "login.html";
		}
		
		return "home.html";
	}

}
