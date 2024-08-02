import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingsCell"
    
    let titleLabel = UILabel()
    var control: UIControl?
    let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .label
        contentView.addSubview(titleLabel)
        
        valueLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 20.0
        let verticalPadding: CGFloat = 20.0
        let interItemPadding: CGFloat = 8.0
        
        // Set titleLabel frame
        let titleSize = titleLabel.sizeThatFits(CGSize(width: contentView.frame.width / 2, height: CGFloat.greatestFiniteMagnitude))
        titleLabel.frame = CGRect(x: padding, y: verticalPadding, width: titleSize.width, height: titleSize.height)
        
        // Set valueLabel frame
        let valueSize = valueLabel.sizeThatFits(CGSize(width: contentView.frame.width / 2, height: CGFloat.greatestFiniteMagnitude))
        valueLabel.frame = CGRect(x: contentView.frame.width - valueSize.width * 2 - padding, y: verticalPadding, width: valueSize.width * 2, height: valueSize.height)
        
        // Set control frame if it exists
        if let control = control {
            let controlY = max(titleLabel.frame.maxY, valueLabel.frame.maxY) + interItemPadding
            let controlHeight = control.intrinsicContentSize.height
            control.frame = CGRect(x: padding, y: controlY, width: contentView.frame.width - padding * 2, height: controlHeight)
        }
    }
    
    func configure(title: String, control: UIControl?, value: String) {
        titleLabel.text = title
        valueLabel.text = value
        
        self.control?.removeFromSuperview()
        self.control = control
        if let control = control {
            contentView.addSubview(control)
        }
        
        setNeedsLayout()
    }
}
