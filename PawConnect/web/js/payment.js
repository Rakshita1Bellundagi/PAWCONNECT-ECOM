// =============================================
// PAW CONNECT - Payment JavaScript
// =============================================

document.addEventListener('DOMContentLoaded', function() {

    // Payment method selection
    const methodOptions = document.querySelectorAll('.method-option');
    const paymentForms = document.querySelectorAll('.payment-form-section');
    const paymentMethodInput = document.getElementById('paymentMethodInput');

    methodOptions.forEach(option => {
        option.addEventListener('click', function() {
            // Remove active from all
            methodOptions.forEach(o => o.classList.remove('active'));
            this.classList.add('active');

            // Get selected method
            const method = this.getAttribute('data-method');
            if (paymentMethodInput) {
                paymentMethodInput.value = method;
            }

            // Show corresponding form
            paymentForms.forEach(form => {
                form.classList.remove('active');
                if (form.getAttribute('data-form') === method) {
                    form.classList.add('active');
                }
            });
        });
    });

    // Card number formatting
    const cardInput = document.getElementById('cardNumber');
    if (cardInput) {
        cardInput.addEventListener('input', function() {
            let value = this.value.replace(/\D/g, '');
            value = value.replace(/(.{4})/g, '$1 ').trim();
            this.value = value.substring(0, 19); // Max 16 digits + 3 spaces
        });
    }

    // Expiry date formatting
    const expiryInput = document.getElementById('expiryDate');
    if (expiryInput) {
        expiryInput.addEventListener('input', function() {
            let value = this.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2);
            }
            this.value = value.substring(0, 5);
        });
    }

    // CVV formatting
    const cvvInput = document.getElementById('cvv');
    if (cvvInput) {
        cvvInput.addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, '').substring(0, 3);
        });
    }

    // Payment form submission
    function showPaymentAlert(msg, el) {
        if (window.PawNotify) {
            PawNotify.warning(msg, 'Payment Information Required');
            if (el) el.focus();
        } else if (window.PawModal) {
            PawModal.alert({
                title: 'Payment Information Required',
                message: msg,
                type: 'warning',
                onConfirm: () => {
                    if (el) el.focus();
                }
            });
        } else {
            if (el) el.focus();
        }
    }

    const paymentForm = document.getElementById('paymentForm');
    if (paymentForm) {
        paymentForm.addEventListener('submit', function(e) {
            const method = paymentMethodInput ? paymentMethodInput.value : '';

            if (!method) {
                e.preventDefault();
                showPaymentAlert('Please select a payment method.');
                return;
            }

            // Validate based on method
            if (method === 'Credit Card' || method === 'Debit Card') {
                const card = document.getElementById('cardNumber');
                const expiry = document.getElementById('expiryDate');
                const cvv = document.getElementById('cvv');
                const name = document.getElementById('cardName');

                if (!card.value || card.value.replace(/\s/g, '').length < 16) {
                    e.preventDefault();
                    showPaymentAlert('Please enter a valid 16-digit card number.', card);
                    return;
                }
                if (!expiry.value || expiry.value.length < 5) {
                    e.preventDefault();
                    showPaymentAlert('Please enter a valid expiry date (MM/YY).', expiry);
                    return;
                }
                if (!cvv.value || cvv.value.length < 3) {
                    e.preventDefault();
                    showPaymentAlert('Please enter a valid 3-digit CVV.', cvv);
                    return;
                }
            } else if (method === 'UPI') {
                const upi = document.getElementById('upiId');
                if (!upi.value || !upi.value.includes('@')) {
                    e.preventDefault();
                    showPaymentAlert('Please enter a valid UPI ID (e.g., name@upi).', upi);
                    return;
                }
            } else if (method === 'Net Banking') {
                const bank = document.getElementById('bankSelect');
                if (!bank.value) {
                    e.preventDefault();
                    showPaymentAlert('Please select your bank.', bank);
                    return;
                }
            }

            // Show processing overlay and simulate payment delay
            const overlay = document.getElementById('paymentProcessing');
            if (overlay) {
                overlay.classList.add('active');
            }
            
            // Prevent immediate submission to simulate payment processing time
            e.preventDefault();
            setTimeout(function() {
                paymentForm.submit();
            }, 3000); // 3-second delay
        });
    }
});
