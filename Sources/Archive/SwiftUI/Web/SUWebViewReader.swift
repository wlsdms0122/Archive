//
//  SUWebViewReader.swift
//  
//
//  Created by jsilver on 2/24/24.
//

import SwiftUI
import WebKit

struct SUWebViewContainerEnvironmentKey: EnvironmentKey {
    static var defaultValue: SUWebViewContainer?
}

extension EnvironmentValues {
    var suWebViewContainer: SUWebViewContainer? {
        get {
            self[SUWebViewContainerEnvironmentKey.self]
        }
        set {
            self[SUWebViewContainerEnvironmentKey.self] = newValue
        }
    }
}

public struct SUWebViewProxy {
    // MARK: - Property
    private let container: SUWebViewContainer
    private var webView: WKWebView? { container.webView }
    
    public var title: String? { webView?.title }
    public var url: URL? { webView?.url }
    public var canGoBack: Bool { webView?.canGoBack ?? false }
    public var canGoForward: Bool { webView?.canGoForward ?? false }
    
    // MARK: - Initializer
    init(_ container: SUWebViewContainer) {
        self.container = container
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Public
    public func goBack() {
        webView?.goBack()
    }
    
    public func goForward() {
        webView?.goForward()
    }
    
    public func reload() {
        webView?.reload()
    }
    
    // MARK: - Private
}

final class SUWebViewContainer: ObservableObject {
    // MARK: - Property
    weak var webView: WKWebView?
    
    // MARK: - Initializer
    public init() {
        
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public struct SUWebViewReader<Content: View>: View {
    // MARK: - View
    public var body: some View {
        content(SUWebViewProxy(container))
            .environment(\.suWebViewContainer, container)
    }
    
    // MARK: - Property
    @StateObject
    private var container = SUWebViewContainer()
    private let content: (SUWebViewProxy) -> Content
    
    // MARK: - Initializer
    public init(@ViewBuilder content: @escaping (SUWebViewProxy) -> Content) {
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
