//
//  WaitingView.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 09.11.2022.
//

import UIKit

class WaitingView: UIView {

    @IBOutlet weak var waitingLabel: UILabel!
    var contentView: UIView?
    weak var delegate : HomeViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
        
    }
    //MARK: -View Configuration
    private func configureView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.layer.cornerRadius = 10
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        waitingLabel.animatePulse()
        waitingLabel.doGlowAnimation(withColor: .white, withEffect: .normal)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: WaitingView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
