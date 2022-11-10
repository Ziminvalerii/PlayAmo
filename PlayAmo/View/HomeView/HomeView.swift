//
//  HomeView.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 08.11.2022.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func okButtonPressed()
    func cancelButtonPressed()
}

class HomeView: UIView {
    
    @IBOutlet weak var containterView: UIView! {
        didSet {
            containterView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
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
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: HomeView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        delegate?.okButtonPressed()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.cancelButtonPressed()
    }
}
