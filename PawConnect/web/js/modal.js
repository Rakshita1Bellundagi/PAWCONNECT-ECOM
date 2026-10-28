// =======================================================
// PAW CONNECT - In-App Notification & Custom Modal System
// 1. Toast Notifications (Success, Error, Warning, Info)
// 2. Custom Centered Confirmation & Prompt Modals
// 3. Fully replaces browser native alert(), confirm(), prompt()
// =======================================================

(function() {
    'use strict';

    // =======================================================
    // 1. TOAST NOTIFICATION ENGINE (PawNotify)
    // =======================================================
    let toastContainer = null;

    function ensureToastContainer() {
        if (!toastContainer) {
            toastContainer = document.getElementById('pawToastContainer');
            if (!toastContainer) {
                toastContainer = document.createElement('div');
                toastContainer.id = 'pawToastContainer';
                toastContainer.className = 'paw-toast-container';
                toastContainer.setAttribute('aria-live', 'polite');
                toastContainer.setAttribute('aria-atomic', 'true');
                document.body.appendChild(toastContainer);
            }
        }
        return toastContainer;
    }

    const PawNotify = {
        /**
         * Show an in-app toast notification
         * @param {Object} opts
         * @param {'success'|'error'|'warning'|'info'} opts.type
         * @param {string} opts.title
         * @param {string} opts.message
         * @param {number} opts.duration In milliseconds, default 4500. 0 for persistent.
         * @param {string} opts.icon Custom FontAwesome icon class
         */
        show: function(opts) {
            const container = ensureToastContainer();
            const type = opts.type || 'info';
            const title = opts.title || (type.charAt(0).toUpperCase() + type.slice(1));
            const message = opts.message || '';
            const duration = typeof opts.duration === 'number' ? opts.duration : 4500;

            let iconClass = opts.icon;
            if (!iconClass) {
                switch (type) {
                    case 'success':
                        iconClass = 'fa-solid fa-circle-check';
                        break;
                    case 'error':
                        iconClass = 'fa-solid fa-circle-xmark';
                        break;
                    case 'warning':
                        iconClass = 'fa-solid fa-triangle-exclamation';
                        break;
                    case 'info':
                    default:
                        iconClass = 'fa-solid fa-circle-info';
                        break;
                }
            }

            const toast = document.createElement('div');
            toast.className = 'paw-toast ' + type;
            toast.setAttribute('role', 'alert');

            toast.innerHTML = `
                <div class="paw-toast-icon-wrap">
                    <i class="${iconClass}"></i>
                </div>
                <div class="paw-toast-body">
                    <div class="paw-toast-title">${escapeHtml(title)}</div>
                    <div class="paw-toast-message">${escapeHtml(message)}</div>
                </div>
                <button type="button" class="paw-toast-close" aria-label="Close notification">&times;</button>
                ${duration > 0 ? '<div class="paw-toast-progress"><div class="paw-toast-progress-bar"></div></div>' : ''}
            `;

            container.appendChild(toast);

            // Trigger slide in animation
            requestAnimationFrame(() => {
                toast.classList.add('paw-toast-show');
            });

            const closeBtn = toast.querySelector('.paw-toast-close');
            let dismissTimeout = null;
            let startTime = Date.now();
            let remaining = duration;
            const progressBar = toast.querySelector('.paw-toast-progress-bar');

            function dismissToast() {
                if (dismissTimeout) clearTimeout(dismissTimeout);
                toast.classList.remove('paw-toast-show');
                toast.classList.add('paw-toast-hiding');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 280);
            }

            closeBtn.addEventListener('click', dismissToast);

            if (duration > 0 && progressBar) {
                progressBar.style.transition = `transform ${duration}ms linear`;
                requestAnimationFrame(() => {
                    progressBar.style.transform = 'scaleX(0)';
                });

                dismissTimeout = setTimeout(dismissToast, duration);

                // Pause timer on hover
                toast.addEventListener('mouseenter', () => {
                    clearTimeout(dismissTimeout);
                    remaining -= (Date.now() - startTime);
                    progressBar.style.transitionPlayState = 'paused';
                });

                toast.addEventListener('mouseleave', () => {
                    startTime = Date.now();
                    progressBar.style.transitionPlayState = 'running';
                    if (remaining > 0) {
                        dismissTimeout = setTimeout(dismissToast, remaining);
                    } else {
                        dismissToast();
                    }
                });
            }

            return {
                dismiss: dismissToast
            };
        },

        success: function(message, title, duration) {
            return this.show({ type: 'success', title: title || 'Success', message, duration });
        },

        error: function(message, title, duration) {
            return this.show({ type: 'error', title: title || 'Error', message, duration });
        },

        warning: function(message, title, duration) {
            return this.show({ type: 'warning', title: title || 'Warning', message, duration });
        },

        info: function(message, title, duration) {
            return this.show({ type: 'info', title: title || 'Notice', message, duration });
        }
    };

    function escapeHtml(str) {
        if (!str) return '';
        const div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }


    // =======================================================
    // 2. CUSTOM IN-APP MODAL ENGINE (PawModal)
    // Centered in the middle of the screen
    // =======================================================
    let modalEl = null;
    let activeResolve = null;
    let activeOnConfirm = null;
    let activeOnCancel = null;
    let currentMode = 'confirm'; // 'confirm' | 'alert' | 'prompt'

    function ensureModal() {
        if (modalEl) return modalEl;

        const existing = document.getElementById('pawModalBackdrop');
        if (existing) {
            modalEl = existing;
            return modalEl;
        }

        const wrapper = document.createElement('div');
        wrapper.id = 'pawModalBackdrop';
        wrapper.className = 'paw-modal-backdrop';
        wrapper.setAttribute('role', 'dialog');
        wrapper.setAttribute('aria-modal', 'true');
        wrapper.setAttribute('aria-labelledby', 'pawModalTitle');
        wrapper.setAttribute('aria-describedby', 'pawModalMessage');

        wrapper.innerHTML = `
            <div class="paw-modal-card" id="pawModalCard">
                <button type="button" class="paw-modal-close" id="pawModalClose" aria-label="Close modal">&times;</button>
                <div class="paw-modal-icon-wrapper" id="pawModalIconWrapper">
                    <i id="pawModalIcon" class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div class="paw-modal-body">
                    <h3 class="paw-modal-title" id="pawModalTitle">Confirmation</h3>
                    <p class="paw-modal-message" id="pawModalMessage">Are you sure?</p>
                    <div class="paw-modal-prompt-wrap" id="pawModalPromptWrap" style="display:none;">
                        <input type="text" class="paw-modal-input" id="pawModalInput" autocomplete="off" />
                        <div class="paw-modal-input-error" id="pawModalInputError" style="display:none;"></div>
                    </div>
                </div>
                <div class="paw-modal-actions" id="pawModalActions">
                    <button type="button" class="paw-modal-btn paw-modal-cancel" id="pawModalCancel">Cancel</button>
                    <button type="button" class="paw-modal-btn paw-modal-confirm" id="pawModalConfirm">Confirm</button>
                </div>
            </div>
        `;

        document.body.appendChild(wrapper);
        modalEl = wrapper;

        const closeBtn = document.getElementById('pawModalClose');
        const cancelBtn = document.getElementById('pawModalCancel');
        const confirmBtn = document.getElementById('pawModalConfirm');
        const inputEl = document.getElementById('pawModalInput');

        closeBtn.addEventListener('click', () => handleModalClose(false));
        cancelBtn.addEventListener('click', () => handleModalClose(false));
        confirmBtn.addEventListener('click', () => handleModalClose(true));

        // Click on backdrop (outside card) closes modal
        wrapper.addEventListener('click', (e) => {
            if (e.target === wrapper) {
                handleModalClose(false);
            }
        });

        // Keyboard navigation (Esc to close, Enter to submit)
        document.addEventListener('keydown', (e) => {
            if (!modalEl || !modalEl.classList.contains('paw-modal-active')) return;

            if (e.key === 'Escape') {
                e.preventDefault();
                handleModalClose(false);
            } else if (e.key === 'Enter') {
                // If textarea or specific button focused, let normal action occur
                if (document.activeElement === cancelBtn) {
                    e.preventDefault();
                    handleModalClose(false);
                } else if (document.activeElement !== closeBtn) {
                    e.preventDefault();
                    handleModalClose(true);
                }
            }
        });

        return modalEl;
    }

    function handleModalClose(confirmed) {
        if (!modalEl || !modalEl.classList.contains('paw-modal-active')) return;

        let promptValue = null;
        if (currentMode === 'prompt' && confirmed) {
            const inputEl = document.getElementById('pawModalInput');
            const errorEl = document.getElementById('pawModalInputError');
            promptValue = inputEl.value;

            if (inputEl.hasAttribute('data-required') && !promptValue.trim()) {
                errorEl.textContent = 'This field cannot be empty.';
                errorEl.style.display = 'block';
                inputEl.focus();
                return;
            }
        }

        modalEl.classList.remove('paw-modal-active');
        document.body.classList.remove('paw-modal-open');

        const callbackConfirm = activeOnConfirm;
        const callbackCancel = activeOnCancel;
        const resolve = activeResolve;
        const mode = currentMode;

        setTimeout(() => {
            if (modalEl) {
                modalEl.style.display = 'none';
                document.getElementById('pawModalPromptWrap').style.display = 'none';
                document.getElementById('pawModalInputError').style.display = 'none';
            }

            if (confirmed) {
                if (mode === 'prompt') {
                    if (typeof callbackConfirm === 'function') callbackConfirm(promptValue);
                    if (resolve) resolve(promptValue);
                } else {
                    if (typeof callbackConfirm === 'function') callbackConfirm();
                    if (resolve) resolve(true);
                }
            } else {
                if (typeof callbackCancel === 'function') callbackCancel();
                if (resolve) resolve(mode === 'prompt' ? null : false);
            }

            activeResolve = null;
            activeOnConfirm = null;
            activeOnCancel = null;
            currentMode = 'confirm';
        }, 220);
    }

    const PawModal = {
        /**
         * Open a confirmation modal centered on the screen
         * @param {Object|string} opts
         * @returns {Promise<boolean>}
         */
        confirm: function(opts) {
            return new Promise((resolve) => {
                const options = typeof opts === 'string' ? { message: opts } : (opts || {});
                ensureModal();

                activeResolve = resolve;
                activeOnConfirm = options.onConfirm || null;
                activeOnCancel = options.onCancel || null;
                currentMode = 'confirm';

                const type = options.type || 'danger';
                const title = options.title || (type === 'danger' ? 'Confirm Action' : 'Are you sure?');
                const message = options.message || 'Are you sure you want to proceed?';
                const confirmText = options.confirmText || (type === 'danger' ? 'Yes, Proceed' : 'Confirm');
                const cancelText = options.cancelText || 'Cancel';

                let iconClass = options.icon;
                if (!iconClass) {
                    switch (type) {
                        case 'danger':
                            iconClass = 'fa-solid fa-triangle-exclamation';
                            break;
                        case 'warning':
                            iconClass = 'fa-solid fa-circle-exclamation';
                            break;
                        case 'success':
                            iconClass = 'fa-solid fa-circle-check';
                            break;
                        case 'info':
                        default:
                            iconClass = 'fa-solid fa-circle-question';
                            break;
                    }
                }

                document.getElementById('pawModalTitle').textContent = title;
                document.getElementById('pawModalMessage').textContent = message;

                const iconWrapper = document.getElementById('pawModalIconWrapper');
                iconWrapper.className = 'paw-modal-icon-wrapper ' + type;
                document.getElementById('pawModalIcon').className = iconClass;

                document.getElementById('pawModalPromptWrap').style.display = 'none';

                const cancelBtn = document.getElementById('pawModalCancel');
                cancelBtn.textContent = cancelText;
                cancelBtn.style.display = 'inline-flex';

                const confirmBtn = document.getElementById('pawModalConfirm');
                confirmBtn.textContent = confirmText;
                confirmBtn.className = 'paw-modal-btn paw-modal-confirm ' + type;

                // Show modal with centering
                modalEl.style.display = 'flex';
                void modalEl.offsetWidth; // Reflow
                modalEl.classList.add('paw-modal-active');
                document.body.classList.add('paw-modal-open');

                setTimeout(() => {
                    if (type === 'danger') {
                        cancelBtn.focus();
                    } else {
                        confirmBtn.focus();
                    }
                }, 50);
            });
        },

        /**
         * Open an alert modal (single OK button)
         * @param {Object|string} opts
         * @returns {Promise<void>}
         */
        alert: function(opts) {
            return new Promise((resolve) => {
                const options = typeof opts === 'string' ? { message: opts } : (opts || {});
                ensureModal();

                activeResolve = resolve;
                activeOnConfirm = options.onConfirm || null;
                activeOnCancel = null;
                currentMode = 'alert';

                const type = options.type || 'info';
                const title = options.title || 'Notice';
                const message = options.message || '';
                const confirmText = options.confirmText || 'OK';

                let iconClass = options.icon;
                if (!iconClass) {
                    switch (type) {
                        case 'danger':
                            iconClass = 'fa-solid fa-circle-xmark';
                            break;
                        case 'warning':
                            iconClass = 'fa-solid fa-triangle-exclamation';
                            break;
                        case 'success':
                            iconClass = 'fa-solid fa-circle-check';
                            break;
                        case 'info':
                        default:
                            iconClass = 'fa-solid fa-circle-info';
                            break;
                    }
                }

                document.getElementById('pawModalTitle').textContent = title;
                document.getElementById('pawModalMessage').textContent = message;

                const iconWrapper = document.getElementById('pawModalIconWrapper');
                iconWrapper.className = 'paw-modal-icon-wrapper ' + type;
                document.getElementById('pawModalIcon').className = iconClass;

                document.getElementById('pawModalPromptWrap').style.display = 'none';

                const cancelBtn = document.getElementById('pawModalCancel');
                cancelBtn.style.display = 'none';

                const confirmBtn = document.getElementById('pawModalConfirm');
                confirmBtn.textContent = confirmText;
                confirmBtn.className = 'paw-modal-btn paw-modal-confirm ' + (type === 'danger' ? 'danger' : (type === 'success' ? 'success' : 'primary'));

                modalEl.style.display = 'flex';
                void modalEl.offsetWidth;
                modalEl.classList.add('paw-modal-active');
                document.body.classList.add('paw-modal-open');

                setTimeout(() => {
                    confirmBtn.focus();
                }, 50);
            });
        },

        /**
         * Open an in-app prompt modal (replaces window.prompt)
         * @param {Object|string} opts
         * @returns {Promise<string|null>}
         */
        prompt: function(opts) {
            return new Promise((resolve) => {
                const options = typeof opts === 'string' ? { message: opts } : (opts || {});
                ensureModal();

                activeResolve = resolve;
                activeOnConfirm = options.onConfirm || null;
                activeOnCancel = options.onCancel || null;
                currentMode = 'prompt';

                const title = options.title || 'Input Required';
                const message = options.message || 'Please enter a value:';
                const defaultValue = options.defaultValue || '';
                const placeholder = options.placeholder || 'Type here...';
                const confirmText = options.confirmText || 'Submit';
                const cancelText = options.cancelText || 'Cancel';
                const required = options.required !== false;

                document.getElementById('pawModalTitle').textContent = title;
                document.getElementById('pawModalMessage').textContent = message;

                const iconWrapper = document.getElementById('pawModalIconWrapper');
                iconWrapper.className = 'paw-modal-icon-wrapper info';
                document.getElementById('pawModalIcon').className = options.icon || 'fa-solid fa-pen-to-square';

                const promptWrap = document.getElementById('pawModalPromptWrap');
                promptWrap.style.display = 'block';

                const inputEl = document.getElementById('pawModalInput');
                inputEl.value = defaultValue;
                inputEl.placeholder = placeholder;
                if (required) {
                    inputEl.setAttribute('data-required', 'true');
                } else {
                    inputEl.removeAttribute('data-required');
                }

                const errorEl = document.getElementById('pawModalInputError');
                errorEl.style.display = 'none';

                const cancelBtn = document.getElementById('pawModalCancel');
                cancelBtn.textContent = cancelText;
                cancelBtn.style.display = 'inline-flex';

                const confirmBtn = document.getElementById('pawModalConfirm');
                confirmBtn.textContent = confirmText;
                confirmBtn.className = 'paw-modal-btn paw-modal-confirm primary';

                modalEl.style.display = 'flex';
                void modalEl.offsetWidth;
                modalEl.classList.add('paw-modal-active');
                document.body.classList.add('paw-modal-open');

                setTimeout(() => {
                    inputEl.focus();
                    inputEl.select();
                }, 80);
            });
        }
    };

    // =======================================================
    // 3. OVERRIDE BROWSER-NATIVE POPUPS (Safety Net)
    // =======================================================
    // Override window.alert to show modern in-app toast
    window.alert = function(message) {
        PawNotify.warning(message, 'Notice');
    };

    // Global in-app notification & modal objects
    window.PawNotify = PawNotify;
    window.PawModal = PawModal;

    // =======================================================
    // 4. AUTOMATIC PAGE ENHANCEMENTS
    // =======================================================
    document.addEventListener('DOMContentLoaded', function() {
        // Automatically check URL parameters for notifications (e.g. ?success=... or ?error=... or ?msg=...)
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('success')) {
            PawNotify.success(urlParams.get('success'));
        }
        if (urlParams.has('error')) {
            PawNotify.error(urlParams.get('error'));
        }
        if (urlParams.has('msg')) {
            PawNotify.info(urlParams.get('msg'));
        }

        // Intercept logout links to provide confirmation modal
        document.querySelectorAll('a[href$="/logout"], a[href$="/admin/logout"]').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const destUrl = this.href;
                PawModal.confirm({
                    title: 'Log Out?',
                    message: 'Are you sure you want to log out of your session?',
                    confirmText: 'Yes, Log Out',
                    cancelText: 'Stay Logged In',
                    type: 'warning',
                    icon: 'fa-solid fa-right-from-bracket',
                    onConfirm: () => {
                        window.location.href = destUrl;
                    }
                });
            });
        });
    });

})();
