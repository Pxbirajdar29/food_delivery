// Menu Data
const menuData = [
    { 
        id: 1, 
        name: "Cheese Burger", 
        price: 299, 
        image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=250&fit=crop", 
        description: "Juicy beef patty with melted cheese, fresh lettuce, and special sauce" 
    },
    { 
        id: 2, 
        name: "Margherita Pizza", 
        price: 449, 
        image: "https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=400&h=250&fit=crop", 
        description: "Classic pizza with fresh mozzarella, tomatoes, and basil leaves" 
    },
    { 
        id: 3, 
        name: "Pasta Alfredo", 
        price: 349, 
        image: "https://images.unsplash.com/photo-1645112411344-0df8b8b5a7d2?w=400&h=250&fit=crop", 
        description: "Creamy pasta with parmesan cheese and grilled chicken" 
    },
    { 
        id: 4, 
        name: "Caesar Salad", 
        price: 249, 
        image: "https://images.unsplash.com/photo-1550304943-4f24f54dd8ca?w=400&h=250&fit=crop", 
        description: "Fresh salad with grilled chicken, parmesan, and Caesar dressing" 
    },
    { 
        id: 5, 
        name: "Chicken Wings", 
        price: 399, 
        image: "https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=400&h=250&fit=crop", 
        description: "Crispy chicken wings with spicy buffalo sauce" 
    },
    { 
        id: 6, 
        name: "Chocolate Brownie", 
        price: 199, 
        image: "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=250&fit=crop", 
        description: "Warm chocolate brownie served with vanilla ice cream" 
    }
];

// Cart array
let cart = JSON.parse(localStorage.getItem('cart')) || [];

// Display menu items
function displayMenu() {
    const menuGrid = document.getElementById('menuGrid');
    if (!menuGrid) return;
    
    menuGrid.innerHTML = menuData.map(item => `
        <div class="menu-card">
            <img src="${item.image}" alt="${item.name}" class="menu-image" loading="lazy">
            <div class="menu-info">
                <h3 class="menu-title">${item.name}</h3>
                <p>${item.description}</p>
                <p class="menu-price">₹${item.price}</p>
                <button class="add-to-cart" onclick="addToCart(${item.id})">
                    Add to Cart 🛒
                </button>
            </div>
        </div>
    `).join('');
}

// Add to cart
function addToCart(id) {
    const item = menuData.find(i => i.id === id);
    const existing = cart.find(i => i.id === id);
    
    if(existing) {
        existing.quantity++;
    } else {
        cart.push({...item, quantity: 1});
    }
    
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartCount();
    
    // Show feedback
    const btn = event.target;
    const originalText = btn.textContent;
    btn.textContent = 'Added! ✓';
    setTimeout(() => btn.textContent = originalText, 1000);
}

// Update cart count badge
function updateCartCount() {
    const count = cart.reduce((sum, item) => sum + item.quantity, 0);
    const cartCount = document.getElementById('cartCount');
    if (cartCount) cartCount.textContent = count;
}

// Show home section
function showHome() {
    document.getElementById('homeSection').style.display = 'flex';
    document.getElementById('menuSection').style.display = 'none';
}

// Show menu section
function showMenu() {
    document.getElementById('homeSection').style.display = 'none';
    document.getElementById('menuSection').style.display = 'block';
    displayMenu();
}

// Show cart modal
function showCart() {
    const modal = document.getElementById('cartModal');
    const cartItemsDiv = document.getElementById('cartItems');
    const cartTotalSpan = document.getElementById('cartTotal');
    
    if(cart.length === 0) {
        cartItemsDiv.innerHTML = '<p style="text-align: center;">Your cart is empty 🍽️</p>';
        cartTotalSpan.textContent = '0';
    } else {
        cartItemsDiv.innerHTML = cart.map(item => `
            <div class="cart-item">
                <div>
                    <strong>${item.name}</strong><br>
                    ₹${item.price} x ${item.quantity}
                </div>
                <div>
                    <strong>₹${item.price * item.quantity}</strong>
                    <button class="remove-btn" onclick="removeFromCart(${item.id})">Remove</button>
                </div>
            </div>
        `).join('');
        
        const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        cartTotalSpan.textContent = total;
    }
    
    modal.style.display = 'block';
}

// Remove from cart
function removeFromCart(id) {
    cart = cart.filter(item => item.id !== id);
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartCount();
    showCart(); // Refresh modal
}

// Close cart modal
function closeCart() {
    document.getElementById('cartModal').style.display = 'none';
}

// Checkout
function checkout() {
    if(cart.length === 0) {
        alert('Your cart is empty!');
        return;
    }
    
    const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    alert(`🎉 Order placed successfully!\nTotal: ₹${total}\nYour food will arrive in 30 minutes!`);
    cart = [];
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartCount();
    closeCart();
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('cartModal');
    if (event.target === modal) {
        closeCart();
    }
}

// Initialize
updateCartCount();

// Show home by default
showHome();