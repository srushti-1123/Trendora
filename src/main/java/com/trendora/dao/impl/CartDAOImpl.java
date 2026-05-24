package com.trendora.dao.impl;

import com.trendora.dao.CartDAO;
import com.trendora.model.Cart;
import com.trendora.model.CartItem;
import com.trendora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAOImpl implements CartDAO {

    @Override
    public boolean createCart(int userId) {
        String query = "INSERT INTO cart (user_id) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating cart: " + e.getMessage());
        }
        return false;
    }

    @Override
    public Cart getCartByUserId(int userId) {
        String query = "SELECT * FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart by user ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public Cart getCartById(int cartId) {
        String query = "SELECT * FROM cart WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart by ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean cartExistsForUser(int userId) {
        String query = "SELECT cart_id FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("Error checking cart existence: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean addItemToCart(CartItem cartItem) {
        String query = "INSERT INTO cart_items (cart_id, product_id, size_label, quantity, unit_price) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartItem.getCartId());
            ps.setInt(2, cartItem.getProductId());
            ps.setString(3, cartItem.getSizeLabel());
            ps.setInt(4, cartItem.getQuantity());
            ps.setDouble(5, cartItem.getUnitPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding item to cart: " + e.getMessage());
        }
        return false;
    }

    @Override
    public List<CartItem> getCartItemsByCartId(int cartId) {
        List<CartItem> cartItems = new ArrayList<>();
        String query = "SELECT * FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cartItems.add(mapResultSetToCartItem(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart items: " + e.getMessage());
        }
        return cartItems;
    }

    @Override
    public CartItem getCartItemById(int cartItemId) {
        String query = "SELECT * FROM cart_items WHERE cart_item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCartItem(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart item by ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public CartItem getCartItemByProductAndSize(int cartId, int productId, String sizeLabel) {
        String query = "SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ? AND size_label = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            ps.setString(3, sizeLabel);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCartItem(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart item by product and size: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean updateCartItemQuantity(int cartItemId, int quantity) {
        String query = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating cart item quantity: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean removeCartItem(int cartItemId) {
        String query = "DELETE FROM cart_items WHERE cart_item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error removing cart item: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean clearCart(int cartId) {
        String query = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error clearing cart: " + e.getMessage());
        }
        return false;
    }

    @Override
    public int getCartItemCount(int userId) {
        String query = "SELECT SUM(ci.quantity) FROM cart_items ci JOIN cart c ON ci.cart_id = c.cart_id WHERE c.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart item count: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public double getCartTotal(int cartId) {
        String query = "SELECT SUM(quantity * unit_price) FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting cart total: " + e.getMessage());
        }
        return 0.0;
    }

    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setUserId(rs.getInt("user_id"));
        cart.setCreatedAt(rs.getTimestamp("created_at"));
        cart.setUpdatedAt(rs.getTimestamp("updated_at"));
        return cart;
    }

    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem cartItem = new CartItem();
        cartItem.setCartItemId(rs.getInt("cart_item_id"));
        cartItem.setCartId(rs.getInt("cart_id"));
        cartItem.setProductId(rs.getInt("product_id"));
        cartItem.setSizeLabel(rs.getString("size_label"));
        cartItem.setQuantity(rs.getInt("quantity"));
        cartItem.setUnitPrice(rs.getDouble("unit_price"));
        cartItem.setAddedAt(rs.getTimestamp("added_at"));
        return cartItem;
    }
}