// =============================================
// PAW CONNECT - Main JavaScript
// =============================================

document.addEventListener('DOMContentLoaded', function() {

    // Mobile Hamburger Menu Toggle
    const hamburger = document.getElementById('hamburgerBtn');
    const navMenu = document.getElementById('navbarNav');
    if (hamburger && navMenu) {
        hamburger.addEventListener('click', function() {
            this.classList.toggle('active');
            navMenu.classList.toggle('active');
            document.body.style.overflow = navMenu.classList.contains('active') ? 'hidden' : '';
        });
        // Close menu when a nav link is clicked
        navMenu.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', function() {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
                document.body.style.overflow = '';
            });
        });
    }
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // Add to cart confirmation
    document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            this.innerHTML = '&#10003; Added!';
            this.style.background = '#10B981';
            if (window.PawNotify) {
                PawNotify.success('Item added to your shopping cart!', 'Added to Cart');
            }
            setTimeout(() => {
                this.innerHTML = '&#128722; Add to Cart';
                this.style.background = '';
            }, 2000);
        });
    });

    // Search form auto-submit on select change
    document.querySelectorAll('.search-bar select').forEach(select => {
        select.addEventListener('change', function() {
            // Don't auto-submit, let user click search
        });
    });

    // Star rating input
    document.querySelectorAll('.star-rating-input .star').forEach(star => {
        star.addEventListener('click', function() {
            const value = this.getAttribute('data-value');
            const container = this.closest('.star-rating-input');
            const input = container.querySelector('input[name="rating"]');
            input.value = value;

            container.querySelectorAll('.star').forEach((s, index) => {
                if (index < value) {
                    s.classList.add('filled');
                } else {
                    s.classList.remove('filled');
                }
            });
        });

        star.addEventListener('mouseenter', function() {
            const value = this.getAttribute('data-value');
            const container = this.closest('.star-rating-input');
            container.querySelectorAll('.star').forEach((s, index) => {
                if (index < value) {
                    s.style.color = '#FFC107';
                } else {
                    s.style.color = '#DDD';
                }
            });
        });
    });

    document.querySelectorAll('.star-rating-input').forEach(container => {
        container.addEventListener('mouseleave', function() {
            const input = this.querySelector('input[name="rating"]');
            const value = input.value || 0;
            this.querySelectorAll('.star').forEach((s, index) => {
                if (index < value) {
                    s.style.color = '#FFC107';
                    s.classList.add('filled');
                } else {
                    s.style.color = '#DDD';
                    s.classList.remove('filled');
                }
            });
        });
    });

    // Form validation
    document.querySelectorAll('form[data-validate]').forEach(form => {
        form.addEventListener('submit', function(e) {
            let valid = true;
            this.querySelectorAll('[required]').forEach(field => {
                if (!field.value.trim()) {
                    valid = false;
                    field.style.borderColor = '#EF4444';
                    field.addEventListener('input', function() {
                        this.style.borderColor = '';
                    }, { once: true });
                }
            });
            if (!valid) {
                e.preventDefault();
                if (window.PawModal) {
                    PawModal.alert({
                        title: 'Required Fields Missing',
                        message: 'Please fill in all required fields before submitting.',
                        type: 'warning'
                    });
                } else {
                    alert('Please fill in all required fields.');
                }
            }
        });
    });

    // Auto-dismiss alerts after 5 seconds
    document.querySelectorAll('.alert').forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(() => alert.remove(), 300);
        }, 5000);
    });

    // Confirm before delete / action
    document.querySelectorAll('[data-confirm]').forEach(element => {
        element.addEventListener('click', function(e) {
            e.preventDefault();
            const message = this.getAttribute('data-confirm') || 'Are you sure?';
            const form = this.closest('form');
            const href = this.getAttribute('href');

            if (window.PawModal) {
                PawModal.confirm({
                    title: 'Confirmation',
                    message: message,
                    confirmText: 'Yes, Proceed',
                    cancelText: 'Cancel',
                    type: 'warning',
                    icon: 'fa-solid fa-circle-question',
                    onConfirm: () => {
                        if (form && (this.type === 'submit' || this.tagName.toLowerCase() === 'button')) {
                            form.submit();
                        } else if (href && href !== '#' && !href.startsWith('javascript:')) {
                            window.location.href = href;
                        } else if (form) {
                            form.submit();
                        }
                    }
                });
            } else {
                if (confirm(message)) {
                    if (form && (this.type === 'submit' || this.tagName.toLowerCase() === 'button')) {
                        form.submit();
                    } else if (href && href !== '#' && !href.startsWith('javascript:')) {
                        window.location.href = href;
                    }
                }
            }
        });
    });

    // Price formatter
    document.querySelectorAll('.price-format').forEach(el => {
        const value = parseFloat(el.textContent);
        if (!isNaN(value)) {
            el.textContent = '\u20B9' + value.toLocaleString('en-IN', { minimumFractionDigits: 2 });
        }
    });
});

// Utility: Format currency
function formatCurrency(amount) {
    return '\u20B9' + parseFloat(amount).toLocaleString('en-IN', { minimumFractionDigits: 2 });
}
