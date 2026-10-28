// =============================================
// PAW CONNECT - Admin JavaScript
// =============================================

document.addEventListener('DOMContentLoaded', function() {

    // Confirm delete actions
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const form = this.closest('form');
            const href = this.getAttribute('href');

            if (window.PawModal) {
                PawModal.confirm({
                    title: 'Delete Confirmation',
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
            } else {
                if (confirm('Are you sure you want to delete this item? This action cannot be undone.')) {
                    if (form && this.tagName.toLowerCase() === 'button') {
                        form.submit();
                    } else if (href && href !== '#' && !href.startsWith('javascript:')) {
                        window.location.href = href;
                    }
                }
            }
        });
    });

    // Toggle user status confirmation
    document.querySelectorAll('.toggle-status-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const form = this.closest('form');
            const isActive = this.getAttribute('data-active') === 'true';
            const action = isActive ? 'deactivate' : 'activate';
            const title = isActive ? 'Deactivate User?' : 'Activate User?';
            const message = isActive 
                ? 'Are you sure you want to deactivate this user? They will not be able to log in until reactivated.' 
                : 'Are you sure you want to activate this user? They will regain access to the platform.';
            const confirmText = isActive ? 'Yes, Deactivate' : 'Yes, Activate';
            const type = isActive ? 'danger' : 'success';
            const icon = isActive ? 'fa-solid fa-user-slash' : 'fa-solid fa-user-check';

            if (window.PawModal) {
                PawModal.confirm({
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
            } else {
                if (confirm('Are you sure you want to ' + action + ' this user?')) {
                    form.submit();
                }
            }
        });
    });

    // Order status change confirmation
    document.querySelectorAll('.status-select').forEach(select => {
        select.addEventListener('change', function() {
            const form = this.closest('form');
            const currentVal = this.getAttribute('data-current') || 'Pending';
            const newVal = this.value;

            if (newVal === currentVal) return;

            if (window.PawModal) {
                PawModal.confirm({
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
            } else {
                if (confirm('Update order status to "' + newVal + '"?')) {
                    form.submit();
                } else {
                    select.value = currentVal;
                }
            }
        });
    });

    // Search in admin tables
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

    // Image preview
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
