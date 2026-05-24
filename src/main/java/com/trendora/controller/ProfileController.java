package com.trendora.controller;

import com.trendora.dao.impl.UserDAOImpl;
import com.trendora.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class ProfileController extends HttpServlet {

    private UserDAOImpl userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Fetch fresh user data from database
        User freshUser = userDAO.getUserById(user.getUserId());

        request.setAttribute("user", freshUser);
        request.getRequestDispatcher("/views/profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleUpdateProfile(request, response, user);
        } else if ("updateAddress".equals(action)) {
            handleUpdateAddress(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setGender(gender);

        boolean success = userDAO.updateUserProfile(user);

        if (success) {
            // Update session with new data
            request.getSession().setAttribute("user", user);
            request.setAttribute("success", "Profile updated successfully!");
        } else {
            request.setAttribute("error", "Profile update failed! Please try again.");
        }

        User freshUser = userDAO.getUserById(user.getUserId());
        request.setAttribute("user", freshUser);
        request.getRequestDispatcher("/views/profile.jsp")
                .forward(request, response);
    }

    private void handleUpdateAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String address = request.getParameter("address");

        boolean success = userDAO.updateUserAddress(user.getUserId(), address);

        if (success) {
            user.setAddress(address);
            request.getSession().setAttribute("user", user);
            request.setAttribute("success", "Address updated successfully!");
        } else {
            request.setAttribute("error", "Address update failed! Please try again.");
        }

        User freshUser = userDAO.getUserById(user.getUserId());
        request.setAttribute("user", freshUser);
        request.getRequestDispatcher("/views/profile.jsp")
                .forward(request, response);
    }
}