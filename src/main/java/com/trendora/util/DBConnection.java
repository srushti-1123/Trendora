package com.trendora.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Use Render environment variables if available,
    // otherwise use the local database.
    private static final String URL =
            System.getenv("DB_URL") != null
                    ? System.getenv("DB_URL")
                    : "jdbc:mysql://localhost:3306/trendora?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static final String USERNAME =
            System.getenv("DB_USERNAME") != null
                    ? System.getenv("DB_USERNAME")
                    : "root";

    private static final String PASSWORD =
            System.getenv("DB_PASSWORD") != null
                    ? System.getenv("DB_PASSWORD")
                    : "Srushtibharath1123"; // Replace with your local MySQL password

    public static Connection getConnection() {
        Connection connection = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

            System.out.println("======================================");
            System.out.println("Database Connected Successfully!");
            System.out.println("Database URL: " + connection.getMetaData().getURL());
            System.out.println("Database Name: " + connection.getCatalog());
            System.out.println("======================================");

        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Database Connection Failed.");
            e.printStackTrace();
        }

        return connection;
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}