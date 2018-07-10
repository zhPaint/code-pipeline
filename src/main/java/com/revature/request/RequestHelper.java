package com.revature.request;

import javax.servlet.http.HttpServletRequest;

import com.revature.controller.CustomerControllerAlpha;
import com.revature.controller.HomeControllerAlpha;
import com.revature.controller.LoginControllerAlpha;

public class RequestHelper {
	
	private RequestHelper() {}
	
	public static Object process(HttpServletRequest request) {
		switch(request.getRequestURI()) {
		case "/java-demo/login.do":
			return LoginControllerAlpha.getInstance().login(request);
		case "/java-demo/logout.do":
			return LoginControllerAlpha.getInstance().logout(request);
		case "/java-demo/register.do":
			return CustomerControllerAlpha.getInstance().register(request);
		case "/java-demo/getAll.do":
			return CustomerControllerAlpha.getInstance().getAllCustomers(request);
		case "/java-demo/home.do":
			return HomeControllerAlpha.getInstance().home(request);
		default:
			return "not-implemented.html";
		}
	}
}
