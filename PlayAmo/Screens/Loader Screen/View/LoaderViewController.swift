//
//  LoaderViewController.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 06.11.2022.
//

import UIKit
import Lottie

class LoaderViewController: BaseViewController<LoaderPresenterProtocol>, LoaderView {

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.frame.size = CGSize(width: 250, height: 50)
        progressView.center.x = view.center.x
        progressView.frame.origin.y = view.bounds.height - 50
        
        progressView.progressTintColor = UIColor(red: 255/255, green: 237/255, blue: 154/255, alpha: 1)
//        UIColor(red: 29/255, green: 77/255, blue: 21/255, alpha: 1.0)
        
        progressView.trackTintColor = .lightGray.withAlphaComponent(0.5)
        
        progressView.progress = 0
//        progressView.
        
        progressView.transform = CGAffineTransform(scaleX: 1, y: 5)
        
        return progressView
    }()
    
    @IBOutlet weak var welcomeLabel: UIImageView! {
        didSet {
            welcomeLabel.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }
    }
    @IBOutlet weak var pingPongAnimationView: AnimationView! {
        didSet {
            pingPongAnimationView.loopMode = .loop
            pingPongAnimationView.play()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(progressView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setAnimatedProgress(duration: 3) {
            let progressViewCenter = self.progressView.center
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.progressView.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 1.5) { [weak self] in
                    self?.welcomeLabel.transform = CGAffineTransform.identity
                } completion: { _ in
                     let rootNavVC = UINavigationController()
                    let builder = Builder()
                    let router = Router(navigationController: rootNavVC, builder: builder)
                    router.start()
                    (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = rootNavVC
                }
            }
        }
    }
    
    func setAnimatedProgress(progress: Float = 1, duration: Float = 1, completion: (() -> ())? = nil) {
        let duration = TimeInterval.random(in: 0.1 ... 0.5)
        Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { (timer) in
                DispatchQueue.main.async {
                    let current = self.progressView.progress
                    let progress = Float.random(in: 0.01 ... 0.3)
                    self.progressView.setProgress(current+(progress), animated: true)
                }
                if self.progressView.progress >= progress {
                    timer.invalidate()
                    if completion != nil {
                        completion!()
                    }
                }
            }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
