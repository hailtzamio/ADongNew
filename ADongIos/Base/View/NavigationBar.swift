import Foundation
import UIKit

final class NavigationBar: UIView {
    
    private static let NIB_NAME = "NavigationBar"
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rightSecondButton: UIButton!
    
    @IBOutlet weak var btnRight2: UIButton!
    
    var leftAction: (() -> ())?
    var rightAction: (() -> ())?
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isLeftButtonHidden: Bool {
        set {
            leftButton.isHidden = newValue
        }
        get {
            return leftButton.isHidden
        }
    }
    
    var isRightButtonHide: Bool {
        set {
            rightSecondButton.isHidden = newValue
        }
        get {
            return rightSecondButton.isHidden
        }
    }
    
    var isRightButton2Hide: Bool {
        set {
            btnRight2.isHidden = newValue
        }
        get {
            return btnRight2.isHidden
        }
    }
    
    func changeUpdateIcon() {
        rightSecondButton.setImage(UIImage(named: "edit"), for: .normal)
    }
    
    func changePhotoIcon() {
         rightSecondButton.setImage(UIImage(named: "gallery"), for: .normal)
     }
    
    func changeDoneIcon() {
          rightSecondButton.setImage(UIImage(named: "tick"), for: .normal)
      }
    
    
    @IBAction func left(_ sender: Any) {
         self.leftAction?()
    }
    
    @IBAction func btnRight2Action(_ sender: Any) {
         self.rightAction?()
    }
    
    @IBAction func right(_ sender: Any) {
         self.rightAction?()
    }
    @IBAction func leftAction(_ sender: Any) {
        self.leftAction?()
    }
    
    @IBAction func rightAction(_ sender: Any) {
          self.rightAction?()
    }
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(NavigationBar.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
}
