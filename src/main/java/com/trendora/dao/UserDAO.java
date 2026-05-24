package com.trendora.dao;

import com.trendora.model.User;

public interface UserDAO {

    // Registration
    boolean registerUser(User user);

    // Login
    User loginUser(String email, String password);

    // Get user by ID
    User getUserById(int userId);

    // Get user by email
    User getUserByEmail(String email);

    // Update user profile
    boolean updateUserProfile(User user);

    // Update address
    boolean updateUserAddress(int userId, String address);

    // Check if email already exists
    boolean emailExists(String email);

    // Delete user
    boolean deleteUser(int userId);
}