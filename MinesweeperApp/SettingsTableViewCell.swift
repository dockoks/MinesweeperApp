import UIKit

class SettingTableViewCell: UITableViewCell {
    
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
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8)
        ])
    }
    
    func configure(title: String, control: UIControl, value: String) {
        titleLabel.text = title
        valueLabel.text = value
        
        self.control?.removeFromSuperview()
        self.control = control
        control.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(control)
        
        NSLayoutConstraint.activate([
            control.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            control.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            control.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            control.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
