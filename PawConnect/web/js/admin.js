// =============================================
// PAW CONNECT - Admin JavaScript
// =============================================

document.addEventListener('DOMContentLoaded', function() {

    // Confirm delete actions
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (!confirm('Are you sure you want to delete this item? This action cannot be undone.')) {
                e.preventDefault();
            }
        });
    });

    // Toggle user status confirmation
    document.querySelectorAll('.toggle-status-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            const isActive = this.getAttribute('data-active') === 'true';
            const action = isActive ? 'deactivate' : 'activate';
            if (!confirm('Are you sure you want to ' + action + ' this user?')) {
                e.preventDefault();
            }
        });
    });

    // Order status change confirmation
    document.querySelectorAll('.status-select').forEach(select => {
        select.addEventListener('change', function() {
            const form = this.closest('form');
            if (confirm('Update order status to "' + this.value + '"?')) {
                form.submit();
            } else {
                // Reset to previous value
                this.value = this.getAttribute('data-current');
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
