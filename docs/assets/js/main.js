// Router và Navigation System
class Router {
    constructor() {
        this.routes = {};
        this.currentRoute = '';
        this.contentContainer = null;
    }

    init() {
        this.contentContainer = document.getElementById('content-container');
        this.setupRoutes();
        this.setupNavigation();
        this.handleInitialRoute();
        window.addEventListener('popstate', () => this.handleRouteChange());
    }

    setupRoutes() {
        this.routes = {
            'overview': {
                title: 'Tổng quan',
                file: 'pages/overview.html',
                icon: '📊'
            },
            'pdf-viewer': {
                title: 'Báo cáo PDF',
                file: 'pages/pdf-viewer.html', 
                icon: '📄'
            },
            'notion-viewer': {
                title: 'Quản lý Dự án',
                file: 'pages/notion-viewer.html',
                icon: '📝'
            }
        };
    }

    setupNavigation() {
        const navigation = document.getElementById('navigation');
        navigation.innerHTML = `
            <div class="nav-section">
                <div class="nav-title">Dashboard</div>
                ${Object.entries(this.routes).map(([route, config]) => `
                    <button class="nav-item" data-route="${route}">
                        <span class="nav-icon">${config.icon}</span>
                        <span>${config.title}</span>
                    </button>
                `).join('')}
            </div>
        `;

        // Add event listeners
        navigation.addEventListener('click', (e) => {
            const navItem = e.target.closest('.nav-item');
            if (navItem) {
                const route = navItem.dataset.route;
                this.navigate(route);
            }
        });
    }

    navigate(route) {
        if (!this.routes[route]) {
            route = 'overview';
        }

        this.currentRoute = route;
        this.updateNavigation();
        this.loadContent(route);
        
        // Update URL without page reload
        const newUrl = route === 'overview' ? '.' : `#${route}`;
        history.pushState({route}, '', newUrl);
    }

    updateNavigation() {
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.route === this.currentRoute);
        });
    }

    async loadContent(route) {
        const config = this.routes[route];
        if (!config) return;

        try {
            this.showLoading();
            
            // Simulate network delay for better UX
            await new Promise(resolve => setTimeout(resolve, 300));
            
            const response = await fetch(config.file);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            const content = await response.text();
            
            // Add page transition
            this.contentContainer.style.opacity = '0';
            
            setTimeout(() => {
                this.contentContainer.innerHTML = content;
                this.contentContainer.style.opacity = '1';
                this.hideLoading();
                
                // Initialize page-specific functionality
                this.initPageFeatures(route);
            }, 150);
            
        } catch (error) {
            console.error('Error loading content:', error);
            this.showError(route, error);
        }
    }

    initPageFeatures(route) {
        switch(route) {
            case 'pdf-viewer':
                this.initPDFViewer();
                break;
            case 'notion-viewer':
                this.initNotionViewer();
                break;
            case 'overview':
                this.initOverview();
                break;
        }
    }

    initPDFViewer() {
        const pdfFrame = document.getElementById('pdfFrame');
        const pdfLoading = document.getElementById('pdf-loading');
        
        if (pdfFrame && pdfLoading) {
            // Show loading
            pdfLoading.style.display = 'flex';
            
            // Set PDF source
            pdfFrame.src = 'assets/output/main.pdf';
            
            pdfFrame.onload = () => {
                pdfLoading.style.display = 'none';
                pdfFrame.style.display = 'block';
            };

            pdfFrame.onerror = () => {
                pdfLoading.innerHTML = `
                    <div class="error-container">
                        <div class="error-icon">❌</div>
                        <h3>Không thể tải PDF</h3>
                        <p>File PDF không tồn tại hoặc đường dẫn không chính xác.</p>
                    </div>
                `;
            };
        }
    }

initNotionViewer() {
    // URL Notion Embed được cung cấp
    const NOTION_EMBED_URL = 'https://hoanghv-gh.notion.site/ebd/1c46182789d880539cd9e686d9b19b99';
    
    const notionFrame = document.getElementById('notionFrame');
    const notionLoading = document.getElementById('notion-loading');
    const notionPlaceholder = document.getElementById('notion-placeholder');
    
    // Ẩn placeholder và hiện loading
    if (notionPlaceholder) notionPlaceholder.style.display = 'none';
    if (notionLoading) notionLoading.style.display = 'flex';
    
    if (notionFrame) {
        // Cấu hình iframe attributes để tối ưu cho Notion embed
        notionFrame.setAttribute('width', '100%');
        notionFrame.setAttribute('height', '600');
        notionFrame.setAttribute('frameborder', '0');
        notionFrame.setAttribute('allowfullscreen', 'true');
        
        // Set source URL
        notionFrame.src = NOTION_EMBED_URL;
        
        notionFrame.onload = () => {
            if (notionLoading) notionLoading.style.display = 'none';
            notionFrame.style.display = 'block';
        };

        notionFrame.onerror = () => {
            if (notionLoading) notionLoading.style.display = 'none';
            if (notionPlaceholder) {
                notionPlaceholder.style.display = 'block';
                notionPlaceholder.innerHTML = `
                    <div class="error-icon">📝</div>
                    <h3 style="margin-bottom: 1rem; color: var(--dark);">Không thể tải Notion</h3>
                    <p style="margin-bottom: 2rem;">
                        Có thể URL Notion embed chưa được cấu hình đúng hoặc có vấn đề kết nối mạng.
                    </p>
                    <button class="btn btn-primary" onclick="router.navigate('overview')">
                        Quay về Tổng quan
                    </button>
                    <button class="btn btn-secondary" onclick="window.refreshNotion()" style="margin-left: 1rem;">
                        Thử lại
                    </button>
                `;
            }
        };
    }
    
    // Make refresh function globally available
    window.refreshNotion = () => {
        if (notionFrame) {
            if (notionLoading) notionLoading.style.display = 'flex';
            notionFrame.src = NOTION_EMBED_URL; // Reload iframe với URL mới
            
            setTimeout(() => {
                if (notionLoading) notionLoading.style.display = 'none';
            }, 2000); // Timeout sau 2 giây nếu không load được
        }
    };
}

    initOverview() {
        // Update statistics
        this.updateOverviewStats();
    }

    updateOverviewStats() {
        // This could be extended to fetch real data
        const stats = {
            pdfCount: 1,
            notionPages: 'Connected',
            lastUpdate: 'Hôm nay',
            status: 'Hoạt động'
        };

        // Update status badge in header
        const statusText = document.getElementById('status-text');
        if (statusText) {
            statusText.textContent = 'Hệ thống hoạt động bình thường';
        }
    }

    handleInitialRoute() {
        const hash = window.location.hash.substring(1);
        const route = hash || 'overview';
        this.navigate(route);
    }

    handleRouteChange() {
        const hash = window.location.hash.substring(1);
        const route = hash || 'overview';
        this.navigate(route);
    }

    showLoading() {
        const overlay = document.getElementById('loading-overlay');
        if (overlay) {
            overlay.style.display = 'flex';
            overlay.querySelector('.loading-text').textContent = 'Đang tải, Vui lòng đợi...';
        }
    }

    hideLoading() {
        const overlay = document.getElementById('loading-overlay');
        if (overlay) {
            overlay.style.display = 'none';
        }
    }

    showError(route, error) {
        this.hideLoading();
        this.contentContainer.innerHTML = `
            <div class="error-container">
                <div class="error-icon">❌</div>
                <h2 style="color: var(--dark); margin-bottom: 1rem;">Lỗi tải trang</h2>
                <p style="margin-bottom: 2rem;">
                    Không thể tải nội dung cho "${this.routes[route]?.title || route}".
                    <br>
                    <small style="color: var(--gray-600);">Chi tiết lỗi: ${error.message}</small>
                </p>
                <button class="btn btn-primary" onclick="router.navigate('overview')">
                    Về trang chủ
                </button>
                <button class="btn btn-secondary" onclick="location.reload()" style="margin-left: 1rem;">
                    Tải lại trang
                </button>
            </div>
        `;
    }
}

// Utility Functions
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    if (sidebar) {
        sidebar.classList.toggle('open');
    }
}

// Theme và UI enhancements
class UIEnhancer {
    constructor() {
        this.init();
    }

    init() {
        this.setupScrollEffects();
        this.setupResponsiveHandling();
        this.setupKeyboardNavigation();
    }

    setupScrollEffects() {
        // Add scroll shadows to main content
        const main = document.querySelector('.main');
        if (main) {
            main.addEventListener('scroll', () => {
                const scrolled = main.scrollTop > 0;
                document.querySelector('.header').classList.toggle('scrolled', scrolled);
            });
        }
    }

    setupResponsiveHandling() {
        // Handle mobile sidebar
        document.addEventListener('click', (e) => {
            const sidebar = document.getElementById('sidebar');
            const isMobile = window.innerWidth <= 1024;
            
            if (isMobile && sidebar && sidebar.classList.contains('open')) {
                if (!sidebar.contains(e.target) && !e.target.classList.contains('mobile-toggle')) {
                    sidebar.classList.remove('open');
                }
            }
        });

        // Handle window resize
        window.addEventListener('resize', () => {
            const sidebar = document.getElementById('sidebar');
            if (window.innerWidth > 1024 && sidebar) {
                sidebar.classList.remove('open');
            }
        });
    }

    setupKeyboardNavigation() {
        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.metaKey) {
                switch(e.key) {
                    case '1':
                        e.preventDefault();
                        router.navigate('overview');
                        break;
                    case '2':
                        e.preventDefault();
                        router.navigate('pdf-viewer');
                        break;
                    case '3':
                        e.preventDefault();
                        router.navigate('notion-viewer');
                        break;
                }
            }
        });
    }
}

// Performance Monitor
class PerformanceMonitor {
    constructor() {
        this.metrics = {
            loadTime: 0,
            routeChanges: 0,
            errors: 0
        };
        this.startTime = performance.now();
    }

    recordRouteChange() {
        this.metrics.routeChanges++;
    }

    recordError() {
        this.metrics.errors++;
        this.updateStatus();
    }

    calculateLoadTime() {
        this.metrics.loadTime = performance.now() - this.startTime;
    }

    updateStatus() {
        const statusText = document.getElementById('status-text');
        if (statusText) {
            if (this.metrics.errors > 0) {
                statusText.textContent = `Phát hiện ${this.metrics.errors} lỗi`;
                statusText.parentElement.style.background = '#fef2f2';
                statusText.parentElement.style.color = '#dc2626';
            } else {
                statusText.textContent = 'Hệ thống hoạt động bình thường';
            }
        }
    }
}

// Initialize Application
document.addEventListener('DOMContentLoaded', () => {
    // Show initial loading
    const overlay = document.getElementById('loading-overlay');
    if (overlay) {
        overlay.style.display = 'flex';
        overlay.querySelector('.loading-text').textContent = 'Đang khởi tạo trang...';
    }

    // Initialize components with delay for smooth loading effect
    setTimeout(() => {
        // Initialize router
        window.router = new Router();
        router.init();

        // Initialize UI enhancements
        window.uiEnhancer = new UIEnhancer();

        // Initialize performance monitor
        window.performanceMonitor = new PerformanceMonitor();
        performanceMonitor.calculateLoadTime();

        // Hide loading overlay
        if (overlay) {
            overlay.style.display = 'none';
        }

        console.log('Dashboard initialized successfully');
    }, 200);
});

// Error handling
window.addEventListener('error', (e) => {
    console.error('Global error:', e.error);
    if (window.performanceMonitor) {
        performanceMonitor.recordError();
    }
});

// Prevent default browser navigation for hash links
window.addEventListener('hashchange', (e) => {
    e.preventDefault();
});