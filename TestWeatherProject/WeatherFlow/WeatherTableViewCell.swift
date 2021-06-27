
import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "Город"
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "0°C"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = "погода"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with weather: Weather) {
        cityLabel.text = weather.name
        temperatureLabel.text = "\(weather.temperature)°C"
        descriptionLabel.text = weather.decription
    }
    
    private func setupLayout() {
        addSubviews(cityLabel, temperatureLabel, descriptionLabel)
        
        let constraints = [
            cityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -15),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }


}
