//
//  InfoViewController.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 01.11.2022.
//

import UIKit

class InfoViewController: BaseViewController<InfoPresenterProtocol>, InfoView {

    @IBOutlet weak var firstOnboardingView: OnboardingView! {
        didSet {
            firstOnboardingView.configure(text: "You are given 2 tennis balls. Use these balls to hit the cup. As soon as the ball hits the cup, the cup is removed.")
        }
    }
    @IBOutlet weak var secondOnboardingView: OnboardingView! {
        didSet {
            secondOnboardingView.configure(text: "After you have thrown 2 balls, the turn is passed to your opponent. As soon as one of you hits the balls, the game is over, the one who hit all the cups won")
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func scrollToIndex(index: Int) {
        
        scrollView.scrollRectToVisible(CGRect(x: CGFloat(index) * scrollView.bounds.width,
                                              y: 0,
                                              width: view.frame.width,
                                              height: view.frame.height), animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func crossButtonPressed(_ sender: Any) {
        presenter.dismissVC()
    }
    
}

extension InfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollView.bounds.width)
//        scrollToIndex(index: Int(pageIndex))
    }
}
