package com.trendora.dao;

import com.trendora.model.Cart;
import com.trendora.model.CartItem;
import java.util.List;

public interface CartDAO {

    // Create a new cart for user
    boolean createCart(int userId);

    // Get cart by user ID
    Cart getCartByUserId(int userId);

    // Get cart by cart ID
    Cart getCartById(int cartId);

    // Check if cart exists for user
    boolean cartExistsForUser(int userId);

    // Add item to cart
    boolean addItemToCart(CartItem cartItem);

    // Get all items in a cart
    List<CartItem> getCartItemsByCartId(int cartId);

    // Get specific cart item by ID
    CartItem getCartItemById(int cartItemId);

    // Get cart item by cart ID, product ID and size label
    CartItem getCartItemByProductAndSize(int cartId, int productId, String sizeLabel);

    // Update quantity of a cart item
    boolean updateCartItemQuantity(int cartItemId, int quantity);

    // Remove a specific item from cart
    boolean removeCartItem(int cartItemId);

    // Clear all items from cart
    boolean clearCart(int cartId);

    // Get total number of items in cart
    int getCartItemCount(int userId);

    // Get total price of cart
    double getCartTotal(int cartId);
}