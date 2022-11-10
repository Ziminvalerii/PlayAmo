//
//  GameOverView.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 06.11.2022.
//

import UIKit


protocol GameOverViewDelegate: AnyObject {
    func menuButtonPressed()
}

class GameOverView: UIView {

    @IBOutlet weak var backgroundImage: UIImageView! {
        didSet {
            backgroundImage.image = UIImage(named: isWin ? "winBack" : "loseBack")
            
        }
    }
    @IBOutlet weak var secondLoseCupImage: UIImageView! {
        didSet {
            secondLoseCupImage.isHidden = isWin
        }
    }
    @IBOutlet weak var loseCupImage: UIImageView! {
        didSet {
            loseCupImage.isHidden = isWin
        }
    }
    @IBOutlet weak var firstCupImage: UIImageView! {
        didSet {
            firstCupImage.isHidden = !isWin
        }
    }
    @IBOutlet weak var secondCuPimage: UIImageView! {
        didSet {
            secondCuPimage.isHidden = !isWin
        }
    }
    @IBOutlet weak var secondsBallImage: UIImageView! {
        didSet {
            secondsBallImage.isHidden = !isWin
        }
    }
    @IBOutlet weak var firstBallImage: UIImageView! {
        didSet {
            firstBallImage.isHidden = !isWin
        }
    }
    @IBOutlet weak var imageTrailingConstrait: NSLayoutConstraint! {
        didSet {
            imageTrailingConstrait.constant = self.bounds.width
        }
    }
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint! {
        didSet {
            imageLeadingConstraint.constant = -self.bounds.width
        }
    }
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel! {
        didSet {
            resultLabel.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            resultLabel.alpha = 0
            
            resultLabel.text = isWin ? "YOU WIN" : "YOU LOSE"
        }
    }
    var isWin: Bool {
        didSet {
//            guard let isWin = isWin else {return}
//            firstBallImage.isHidden = !isWin
//            secondsBallImage.isHidden = !isWin
//            resultLabel.text = "YOU LOSE"
//            firstCupImage.isHidden = !isWin
//            secondCuPimage.isHidden = !isWin
//            secondLoseCupImage.isHidden = isWin
//            loseCupImage.isHidden = isWin
//            backgroundImage.image = UIImage(named: isWin ? "winBack" : "loseBack")
            
        }
    }
    var contentView: UIView?
    weak var delegate: GameOverViewDelegate?
    
     init(frame: CGRect, iswin: Bool) {
        self.isWin = iswin
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        isWin = false
        super.init(coder: aDecoder)
        configureView()
    }
    //MARK: -View Configuration
    private func configureView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: GameOverView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func animateImages() {
        UIView.animate(withDuration: 1, delay: 0.25) {
            self.resultLabel.alpha = 1
            self.resultLabel.transform = CGAffineTransform.identity
        }completion: { success in
            if success {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
                    self.imageLeadingConstraint.constant = 0
                    self.imageTrailingConstrait.constant = 0
                    self.layoutIfNeeded()
                }
            }
        }
    }
    

    @IBAction func menuButtonPressed(_ sender: Any) {
        delegate?.menuButtonPressed()
    }
}
