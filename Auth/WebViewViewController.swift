import UIKit
import WebKit
// MARK: - Constants
enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
// MARK: - Delegate Protocol
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
// MARK: - IBOutlets
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
// MARK: - Public Properties
    weak var delegate: WebViewViewControllerDelegate?
// MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()
        
        estimatedProgressObservation = webView.observe( // новое kvo апи
            \.estimatedProgress,
            options: [.new]
        ) { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgress()
        }
        
        updateProgress()
    }
    

// MARK: - IBActions
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
// MARK: - Private Methods
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {        print("[WebViewViewController]: Failed to create URLComponents from string: \(WebViewConstants.unsplashAuthorizeURLString)")
            return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url else {
            print("[WebViewViewController]: Failed to construct URL from URLComponents")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        updateProgress()
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
}
// MARK: - WKNavigationDelegate
    extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

