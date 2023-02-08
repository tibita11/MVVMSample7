//
//  WKWebViewController.swift
//  MVVMSample7
//
//  Created by 鈴木楓香 on 2023/02/07.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import RxOptional
import RxWebKit

class WKWebViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    private func setupWebView() {
        // プログレスバーの表示制御、ゲージ制御、アクティビティーインジケーター表示制御で使うため、一旦オブザーバーを定義
        let loadingObservable = webView.rx.loading
            .share()

        // プログレスバーの表示・非表示
        loadingObservable
            .map { return !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // iPhoneの上部の時計のこと路のバーのアクティビティーインジケーター表示制御
        loadingObservable
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        // NavigationControllerのタイトル表示
        webView.rx.title
            .filterNil()
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        // プログレスバーのゲージ制御
        webView.rx.estimatedProgress
            .map { return Float($0) }
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        let url = URL(string: "https://www.google.com/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        
    }


}
