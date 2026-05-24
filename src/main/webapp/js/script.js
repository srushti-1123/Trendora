// =====================
// NAVBAR SCROLL EFFECT
// =====================
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.style.boxShadow = '0 2px 20px rgba(0,0,0,0.3)';
    } else {
        navbar.style.boxShadow = 'none';
    }
});

// =====================
// SEARCH BAR VALIDATION
// =====================
const searchForm = document.querySelector('.search-bar');
if (searchForm) {
    searchForm.addEventListener('submit', function(e) {
        const searchInput = document.querySelector('.search-bar input');
        if (searchInput.value.trim() === '') {
            e.preventDefault();
            searchInput.focus();
        }
    });
}

// =====================
// PRODUCT CARD HOVER
// =====================
const productCards = document.querySelectorAll('.product-card');
productCards.forEach(function(card) {
    card.addEventListener('mouseenter', function() {
        this.style.cursor = 'pointer';
    });
});

// =====================
// SMOOTH SCROLL
// =====================
document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// =====================
// AUTO HIDE ALERTS
// =====================
window.addEventListener('load', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s';
            setTimeout(function() {
                alert.remove();
            }, 500);
        }, 3000);
    });
});