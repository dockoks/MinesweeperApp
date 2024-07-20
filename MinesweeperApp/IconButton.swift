import UIKit

class IconButton: UIButton {
    
    init(systemName: String, action: Selector, target: Any?, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        setupButton(systemName: systemName, action: action, target: target, cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(systemName: String, action: Selector, target: Any?, cornerRadius: CGFloat) {
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        self.setImage(image, for: .normal)
        self.tintColor = .label
        self.backgroundColor = .systemFill
        self.layer.cornerRadius = cornerRadius
        self.layer.cornerCurve = .continuous
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
