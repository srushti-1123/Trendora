package com.trendora.controller;

import com.trendora.dao.impl.UserDAOImpl;
import com.trendora.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class UserController extends HttpServlet {

    private UserDAOImpl userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.endsWith("/register")) {
            request.getRequestDispatcher("/views/register.jsp")
                    .forward(request, response);
        } else if (uri.endsWith("/login")) {
            request.getRequestDispatcher("/views/login.jsp")
                    .forward(request, response);
        } else if (uri.endsWith("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.getRequestDispatcher("/views/login.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) action = "";

        switch (action) {
            case "register":
                handleRegister(request, response);
                break;
            case "login":
                handleLogin(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/views/register.jsp")
                    .forward(request, response);
            return;
        }

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered! Please login.");
            request.getRequestDispatcher("/views/register.jsp")
                    .forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        user.setGender(gender);
        user.setAddress(address);

        boolean success = userDAO.registerUser(user);

        if (success) {
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/views/login.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("/views/register.jsp")
                    .forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.loginUser(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("/views/login.jsp")
                    .forward(request, response);
        }
    }
}