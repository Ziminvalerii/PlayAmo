//
//  BuyView.swift
//  Paf
//
//  Created by Anastasia Koldunova on 10.10.2022.
//

import UIKit

protocol BuyViewDelegate: AnyObject {
    func confirmButtonPressed(item: Product)
    func cancelButtonPressed(item: Product)
}

class BuyView: UIView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: BuyViewDelegate?
    var character: Product
    var contentView: UIView?
    
    init(frame: CGRect, character: Product) {
        self.character = character
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        character = Ball(rawValue: 0)!
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
        let nibName = String(describing: BuyView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.cancelButtonPressed(item: character)
    }
    @IBAction func confirmButtonPressed(_ sender: Any) {
        delegate?.confirmButtonPressed(item: character)
    }
}
