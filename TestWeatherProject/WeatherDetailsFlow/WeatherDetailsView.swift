
import UIKit

class WeatherDetailsView: UIView {
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let feelslikeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "По ощущениям"
        label.textColor = .black
        return label
    }()
    
    private let feelslikeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let precipitationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Осадки"
        label.textColor = .black
        return label
    }()
    
    private let precipitationValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Влажность воздуха"
        label.textColor = .black
        return label
    }()
    
    private let humidityValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Атмосферное давление"
        label.textColor = .black
        return label
    }()
    
    private let pressureValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let windspeedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Скорость ветра"
        label.textColor = .black
        return label
    }()
    
    private let windspeedValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with weather: Weather) {
        temperatureLabel.text = "\(weather.temperature)°C"
        descriptionLabel.text = weather.decription
        feelslikeValueLabel.text = "\(weather.feelsLike)°C"
        precipitationValueLabel.text = "\(configurePrecipitation(with: weather.precType))"
        humidityValueLabel.text = "\(weather.humidity)%"
        pressureValueLabel.text = "\(weather.pressureMm) мм рт.ст."
        windspeedValueLabel.text = "\(Int(weather.windSpeed)) м/с"
        setupBackgroundColor(with: weather.temperature)
    }
    
    private func configurePrecipitation(with value: Int) -> String {
        switch value {
        case 0: return "Без осадков"
        case 1: return "Дождь"
        case 2: return "Дождь со снегом"
        case 3: return "Снег"
        case 4: return "Град"
        default: return ""
        }
    }
    
    private func setupBackgroundColor(with value: Int) {
        switch value {
        case ..<0: backgroundColor = .blue
        case 0..<10: backgroundColor = .gray
        case 10..<20: backgroundColor = .cyan
        case 20..<30: backgroundColor = .yellow
        case 30...: backgroundColor = .orange
        default: backgroundColor = .white
        }
    }
     
    private func setupLayout() {
        addSubviews(temperatureLabel, descriptionLabel, feelslikeLabel, feelslikeValueLabel, precipitationLabel, precipitationValueLabel, humidityLabel, humidityValueLabel, pressureLabel, pressureValueLabel, windspeedLabel, windspeedValueLabel)
        
        let constraints = [
            temperatureLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 15),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            feelslikeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            feelslikeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            
            feelslikeValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            feelslikeValueLabel.centerYAnchor.constraint(equalTo: feelslikeLabel.centerYAnchor),
            
            precipitationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            precipitationLabel.topAnchor.constraint(equalTo: feelslikeLabel.bottomAnchor, constant: 25),
            
            precipitationValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            precipitationValueLabel.centerYAnchor.constraint(equalTo: precipitationLabel.centerYAnchor),
            
            humidityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            humidityLabel.topAnchor.constraint(equalTo: precipitationLabel.bottomAnchor, constant: 25),
            
            humidityValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            humidityValueLabel.centerYAnchor.constraint(equalTo: humidityLabel.centerYAnchor),
            
            pressureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            pressureLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 25),
            
            pressureValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            pressureValueLabel.centerYAnchor.constraint(equalTo: pressureLabel.centerYAnchor),
            
            windspeedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            windspeedLabel.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor, constant: 25),
            
            windspeedValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            windspeedValueLabel.centerYAnchor.constraint(equalTo: windspeedLabel.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
