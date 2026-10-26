<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.pawconnect.model.CartItem" %>
        <%@ page import="java.util.List" %>
            <jsp:include page="/jsp/common/header.jsp">
                <jsp:param name="pageTitle" value="Payment" />
            </jsp:include>
            <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                    Double cartTotal = (Double) request.getAttribute("cartTotal");
                    String ctx = request.getContextPath();
                    %>
                    <link rel="stylesheet" href="<%= ctx %>/css/payment.css">
                    <!-- QR Code Library -->
                    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>

                    <div class="page-header">
                        <div class="container">
                            <h1><i class="fa-solid fa-credit-card"></i> Secure Payment</h1>
                            <p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / <a href="<%= ctx %>/cart/">Cart</a> /
                                <a href="<%= ctx %>/checkout/">Checkout</a> / Payment</p>
                        </div>
                    </div>

                    <div class="payment-page">
                        <!-- Order Summary -->
                        <div class="order-summary-mini">
                            <h3><i class="fa-solid fa-box-open"></i> Order Summary</h3>
                            <% if (cartItems !=null) { for (CartItem item : cartItems) { %>
                                <div class="item-row">
                                    <span>
                                        <%= item.getPetName() %> (<%= item.getBreed() %>)
                                    </span>
                                    <span><i class="fa-solid fa-indian-rupee-sign"></i>
                                        <%= String.format("%,.2f", item.getPrice()) %>
                                    </span>
                                </div>
                                <% } } %>
                                    <div class="total">
                                        <span>Total Amount</span>
                                        <span><i class="fa-solid fa-indian-rupee-sign"></i>
                                            <%= String.format("%,.2f", cartTotal) %>
                                        </span>
                                    </div>
                        </div>

                        <!-- Secure Badge -->
                        <div class="secure-badge">
                            <i class="fa-solid fa-lock"></i> Your payment is secured with 256-bit SSL encryption
                        </div>

                        <!-- Payment Method Selection -->
                        <h2>Select Payment Method</h2>
                        <div class="method-grid">
                            <div class="method-option" data-method="UPI">
                                <span class="method-icon"><i class="fa-solid fa-mobile-screen"></i></span>
                                <span class="method-name">UPI</span>
                            </div>
                            <div class="method-option" data-method="Credit Card">
                                <span class="method-icon"><i class="fa-solid fa-credit-card"></i></span>
                                <span class="method-name">Credit Card</span>
                            </div>
                            <div class="method-option" data-method="Debit Card">
                                <span class="method-icon"><i class="fa-solid fa-credit-card"></i></span>
                                <span class="method-name">Debit Card</span>
                            </div>
                            <div class="method-option" data-method="Net Banking">
                                <span class="method-icon"><i class="fa-solid fa-building-columns"></i></span>
                                <span class="method-name">Net Banking</span>
                            </div>
                            <div class="method-option" data-method="Wallet">
                                <span class="method-icon"><i class="fa-solid fa-wallet"></i></span>
                                <span class="method-name">Wallet</span>
                            </div>
                        </div>

                        <!-- Payment Form -->
                        <form id="paymentForm" method="post" action="<%= ctx %>/payment/">
                            <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="">

                            <!-- UPI Form -->
                            <div class="payment-form-section" data-form="UPI">
                                <h3><i class="fa-solid fa-mobile-screen"></i> Pay via UPI</h3>

                                <!-- UPI Tabs -->
                                <div style="display: flex; gap: 8px; margin-bottom: 20px;">
                                    <button type="button" class="btn btn-sm btn-primary" id="upiTabId"
                                        onclick="switchUpiTab('id')" style="flex:1;">Enter UPI ID</button>
                                    <button type="button" class="btn btn-sm btn-outline" id="upiTabQr"
                                        onclick="switchUpiTab('qr')" style="flex:1;">Scan QR Code</button>
                                </div>

                                <!-- UPI ID Entry -->
                                <div id="upiIdSection">
                                    <div class="form-group" style="margin-bottom: 16px; min-width: unset; flex: unset;">
                                        <label>UPI ID</label>
                                        <input type="text" id="upiId" name="upiId" class="form-control"
                                            placeholder="yourname@upi">
                                    </div>
                                    <p style="font-size: 0.85rem; color: var(--text-light); margin-bottom: 16px;">
                                        Supported: Google Pay, PhonePe, Paytm, BHIM</p>
                                </div>

                                <!-- QR Code Section -->
                                <div id="upiQrSection" style="display: none; text-align: center;">
                                    <p style="font-size: 0.9rem; color: var(--text-secondary); margin-bottom: 16px;">
                                        Scan this QR code with any UPI app to pay</p>
                                    <div
                                        style="background: #fff; display: inline-block; padding: 20px; border-radius: 16px; border: 2px solid var(--border); margin-bottom: 16px;">
                                        <div id="upiQrCode"></div>
                                    </div>
                                    <p style="font-size: 0.85rem; color: var(--text-light); margin-bottom: 8px;">
                                        Merchant UPI: <strong>pawconnect@upi</strong></p>
                                    <p
                                        style="font-size: 1.1rem; font-weight: 700; color: var(--primary); margin-bottom: 16px;">
                                        Amount: <i class="fa-solid fa-indian-rupee-sign"></i>
                                        <%= String.format("%,.2f", cartTotal) %>
                                    </p>
                                    <div
                                        style="background: #FFF7ED; border: 1px solid #FDBA74; border-radius: 12px; padding: 16px; text-align: left; margin-bottom: 16px;">
                                        <p style="font-size: 0.85rem; color: #9A3412;"><i
                                                class="fa-solid fa-info-circle"></i> <strong>Steps:</strong></p>
                                        <ol
                                            style="font-size: 0.8rem; color: #9A3412; padding-left: 16px; margin-top: 8px;">
                                            <li>Open your UPI app (GPay, PhonePe, Paytm)</li>
                                            <li>Scan the QR code above</li>
                                            <li>Verify amount and complete payment</li>
                                            <li>Click "I Have Paid" below</li>
                                        </ol>
                                    </div>
                                </div>

                                <button type="submit" id="upiSubmitBtn" class="pay-btn"><i class="fa-solid fa-lock"></i> Pay <i
                                        class="fa-solid fa-indian-rupee-sign"></i>
                                    <%= String.format("%,.2f", cartTotal) %>
                                </button>
                            </div>

                            <!-- Credit Card Form -->
                            <div class="payment-form-section" data-form="Credit Card">
                                <h3><i class="fa-solid fa-credit-card"></i> Credit Card Payment</h3>
                                <div class="form-group" style="margin-bottom: 16px; min-width: unset; flex: unset;">
                                    <label>Card Number</label>
                                    <input type="text" id="cardNumber" name="cardNumber" class="form-control"
                                        placeholder="1234 5678 9012 3456" maxlength="19">
                                </div>
                                <div class="form-group" style="margin-bottom: 16px; min-width: unset; flex: unset;">
                                    <label>Cardholder Name</label>
                                    <input type="text" id="cardName" name="cardName" class="form-control"
                                        placeholder="Name on card">
                                </div>
                                <div class="card-input-group">
                                    <div class="form-group" style="min-width: unset; flex: unset;">
                                        <label>Expiry Date</label>
                                        <input type="text" id="expiryDate" name="expiryDate" class="form-control"
                                            placeholder="MM/YY" maxlength="5">
                                    </div>
                                    <div class="form-group" style="min-width: unset; flex: unset;">
                                        <label>CVV</label>
                                        <input type="password" id="cvv" name="cvv" class="form-control"
                                            placeholder="123" maxlength="3">
                                    </div>
                                </div>
                                <button type="submit" class="pay-btn" style="margin-top: 16px;"><i
                                        class="fa-solid fa-lock"></i> Pay <i class="fa-solid fa-indian-rupee-sign"></i>
                                    <%= String.format("%,.2f", cartTotal) %>
                                </button>
                            </div>

                            <!-- Debit Card Form -->
                            <div class="payment-form-section" data-form="Debit Card">
                                <h3><i class="fa-solid fa-credit-card"></i> Debit Card Payment</h3>
                                <div class="form-group" style="margin-bottom: 16px; min-width: unset; flex: unset;">
                                    <label>Card Number</label>
                                    <input type="text" name="cardNumber" class="form-control"
                                        placeholder="1234 5678 9012 3456" maxlength="19">
                                </div>
                                <div class="form-group" style="margin-bottom: 16px; min-width: unset; flex: unset;">
                                    <label>Cardholder Name</label>
                                    <input type="text" name="cardName" class="form-control" placeholder="Name on card">
                                </div>
                                <div class="card-input-group">
                                    <div class="form-group" style="min-width: unset; flex: unset;">
                                        <label>Expiry Date</label>
                                        <input type="text" name="expiryDate" class="form-control" placeholder="MM/YY"
                                            maxlength="5">
                                    </div>
                                    <div class="form-group" style="min-width: unset; flex: unset;">
                                        <label>CVV</label>
                                        <input type="password" name="cvv" class="form-control" placeholder="123"
                                            maxlength="3">
                                    </div>
                                </div>
                                <button type="submit" class="pay-btn" style="margin-top: 16px;"><i
                                        class="fa-solid fa-lock"></i> Pay <i class="fa-solid fa-indian-rupee-sign"></i>
                                    <%= String.format("%,.2f", cartTotal) %>
                                </button>
                            </div>

                            <!-- Net Banking Form -->
                            <div class="payment-form-section" data-form="Net Banking">
                                <h3><i class="fa-solid fa-building-columns"></i> Net Banking</h3>
                                <div class="form-group" style="margin-bottom: 16px; min-width: unset; flex: unset;">
                                    <label>Select Bank</label>
                                    <select id="bankSelect" name="bankSelect" class="form-control">
                                        <option value="">-- Select Your Bank --</option>
                                        <option value="SBI">State Bank of India</option>
                                        <option value="HDFC">HDFC Bank</option>
                                        <option value="ICICI">ICICI Bank</option>
                                        <option value="Axis">Axis Bank</option>
                                        <option value="Kotak">Kotak Mahindra Bank</option>
                                        <option value="PNB">Punjab National Bank</option>
                                        <option value="BOB">Bank of Baroda</option>
                                        <option value="Canara">Canara Bank</option>
                                    </select>
                                </div>
                                <button type="submit" class="pay-btn"><i class="fa-solid fa-lock"></i> Pay <i
                                        class="fa-solid fa-indian-rupee-sign"></i>
                                    <%= String.format("%,.2f", cartTotal) %>
                                </button>
                            </div>

                            <!-- Wallet Form -->
                            <div class="payment-form-section" data-form="Wallet">
                                <h3><i class="fa-solid fa-wallet"></i> Digital Wallet</h3>
                                <div class="form-group" style="margin-bottom: 16px; min-width: unset; flex: unset;">
                                    <label>Select Wallet</label>
                                    <select name="walletType" class="form-control">
                                        <option value="Paytm">Paytm Wallet</option>
                                        <option value="PhonePe">PhonePe Wallet</option>
                                        <option value="Amazon Pay">Amazon Pay</option>
                                        <option value="Mobikwik">Mobikwik</option>
                                    </select>
                                </div>
                                <p style="font-size: 0.85rem; color: var(--text-light); margin-bottom: 16px;">You will
                                    be redirected to your wallet app to complete the payment.</p>
                                <button type="submit" class="pay-btn"><i class="fa-solid fa-lock"></i> Pay <i
                                        class="fa-solid fa-indian-rupee-sign"></i>
                                    <%= String.format("%,.2f", cartTotal) %>
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Processing Overlay -->
                    <div id="paymentProcessing" class="payment-processing">
                        <div class="process-spinner"></div>
                        <h2>Processing Payment...</h2>
                        <p>Please do not close or refresh this page</p>
                    </div>

                    <script>
                        // Generate UPI QR Code on page load
                        var qrGenerated = false;
                        function generateUpiQr() {
                            if (qrGenerated) return;
                            var amount = '<%= String.format("%.2f", cartTotal) %>';
                            var upiUrl = 'upi://pay?pa=7022367376-2@ybl&pn=PawConnect&am=' + amount + '&cu=INR&tn=PawConnect+Pet+Purchase';
                            var qrDiv = document.getElementById('upiQrCode');
                            if (qrDiv) {
                                new QRCode(qrDiv, {
                                    text: upiUrl,
                                    width: 200,
                                    height: 200,
                                    colorDark: "#0F172A",
                                    colorLight: "#ffffff",
                                    correctLevel: QRCode.CorrectLevel.H
                                });
                                qrGenerated = true;
                            }
                        }

                        function switchUpiTab(tab) {
                            var btn = document.getElementById('upiSubmitBtn');
                            if (tab === 'qr') {
                                document.getElementById('upiIdSection').style.display = 'none';
                                document.getElementById('upiQrSection').style.display = 'block';
                                document.getElementById('upiTabId').className = 'btn btn-sm btn-outline';
                                document.getElementById('upiTabQr').className = 'btn btn-sm btn-primary';
                                btn.innerHTML = '<i class="fa-solid fa-check-circle"></i> I Have Paid';
                                btn.style.background = 'var(--success)';
                                generateUpiQr();
                            } else {
                                document.getElementById('upiIdSection').style.display = 'block';
                                document.getElementById('upiQrSection').style.display = 'none';
                                document.getElementById('upiTabId').className = 'btn btn-sm btn-primary';
                                document.getElementById('upiTabQr').className = 'btn btn-sm btn-outline';
                                btn.innerHTML = '<i class="fa-solid fa-lock"></i> Pay <i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", cartTotal) %>';
                                btn.style.background = '';
                            }
                        }
                    </script>

                    <script src="<%= ctx %>/js/payment.js"></script>
                    <jsp:include page="/jsp/common/footer.jsp" />