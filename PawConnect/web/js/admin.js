// =============================================
// PAW CONNECT - Admin JavaScript
// Custom In-App Modals & Notifications
// =============================================

document.addEventListener('DOMContentLoaded', function() {

    // Helper: Safely confirm action using PawModal without browser popups
    function requestConfirmation(options) {
        if (window.PawModal && typeof window.PawModal.confirm === 'function') {
            return PawModal.confirm(options);
        } else {
            // Self-contained emergency modal if modal.js is delayed
            console.warn('PawModal not yet loaded, creating modal');
            setTimeout(() => {
                if (window.PawModal) PawModal.confirm(options);
            }, 100);
        }
    }

    // 1. Confirm delete actions (Pets, Categories, Reviews)
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const form = this.closest('form');
            const href = this.getAttribute('href');

            requestConfirmation({
                title: 'Delete Item?',
                message: 'Are you sure you want to delete this item? This action cannot be undone.',
                confirmText: 'Yes, Delete',
                cancelText: 'Cancel',
                type: 'danger',
                icon: 'fa-solid fa-trash-can',
                onConfirm: () => {
                    if (form && this.tagName.toLowerCase() === 'button') {
                        form.submit();
                    } else if (href && href !== '#' && !href.startsWith('javascript:')) {
                        window.location.href = href;
                    } else if (form) {
                        form.submit();
                    }
                }
            });
        });
    });

    // 2. Toggle user status confirmation (Deactivate / Activate User)
    document.querySelectorAll('.toggle-status-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const form = this.closest('form');
            const isActive = this.getAttribute('data-active') === 'true';
            const title = isActive ? 'Deactivate User?' : 'Activate User?';
            const message = isActive 
                ? 'Are you sure you want to deactivate this user? They will not be able to log in until reactivated.' 
                : 'Are you sure you want to activate this user? They will regain full access to their account.';
            const confirmText = isActive ? 'Yes, Deactivate' : 'Yes, Activate';
            const type = isActive ? 'danger' : 'success';
            const icon = isActive ? 'fa-solid fa-user-slash' : 'fa-solid fa-user-check';

            requestConfirmation({
                title: title,
                message: message,
                confirmText: confirmText,
                cancelText: 'Cancel',
                type: type,
                icon: icon,
                onConfirm: () => {
                    form.submit();
                }
            });
        });
    });

    // 3. Order status change confirmation
    document.querySelectorAll('.status-select').forEach(select => {
        select.addEventListener('change', function(e) {
            e.preventDefault();

            const form = this.closest('form');
            const currentVal = this.getAttribute('data-current') || 'Pending';
            const newVal = this.value;

            if (newVal === currentVal) return;

            requestConfirmation({
                title: 'Update Order Status',
                message: 'Update order status to "' + newVal + '"?',
                confirmText: 'Update Status',
                cancelText: 'Cancel',
                type: 'info',
                icon: 'fa-solid fa-box-open',
                onConfirm: () => {
                    form.submit();
                },
                onCancel: () => {
                    select.value = currentVal;
                }
            });
        });
    });

    // 4. Live search in admin tables
    const searchInput = document.getElementById('adminSearch');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const query = this.value.toLowerCase();
            const rows = document.querySelectorAll('table tbody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    }

    // 5. Image preview for pet upload
    const imageInput = document.getElementById('imageUrl');
    const imagePreview = document.getElementById('imagePreview');
    if (imageInput && imagePreview) {
        imageInput.addEventListener('input', function() {
            if (this.value) {
                imagePreview.style.display = 'block';
                imagePreview.textContent = 'Image: ' + this.value;
            } else {
                imagePreview.style.display = 'none';
            }
        });
    }
});
