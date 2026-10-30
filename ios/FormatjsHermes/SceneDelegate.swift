import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
import UIKit

class SceneDelegate: RCTDefaultReactNativeFactoryDelegate, UIWindowSceneDelegate {
  var window: UIWindow?
  var reactNativeFactory: RCTReactNativeFactory?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else {
      return
    }

    dependencyProvider = RCTAppDependencyProvider()
    reactNativeFactory = RCTReactNativeFactory(delegate: self)
    window = UIWindow(windowScene: windowScene)

    #if DEBUG
    let devMenuConfiguration = RCTDevMenuConfiguration(
      devMenuEnabled: true,
      shakeGestureEnabled: true,
      keyboardShortcutsEnabled: true
    )
    reactNativeFactory?.devMenuConfiguration = devMenuConfiguration
    #endif

    reactNativeFactory?.startReactNative(
      withModuleName: "FormatjsHermes",
      in: window,
      connectionOptions: connectionOptions
    )


  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    RCTLinkingManager.scene(scene, openURLContexts: URLContexts)
  }

  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    RCTLinkingManager.scene(scene, continue: userActivity)
  }

  override func setRootView(_ rootView: UIView, toRootViewController rootViewController: UIViewController) {
    let container = rootViewController.view!
    container.backgroundColor = .white
    container.addSubview(rootView)
    rootView.translatesAutoresizingMaskIntoConstraints = false
    let safeArea = container.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      rootView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      rootView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      rootView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      rootView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    ])
  }

  override func bundleURL() -> URL? {
    #if DEBUG
    RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
    #else
    Bundle.main.url(forResource: "main", withExtension: "jsbundle")
    #endif
  }
}
