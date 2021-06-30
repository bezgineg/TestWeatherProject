
import UIKit

class WeatherDetailsViewController: UIViewController {
    
    let weather: Weather
    
    private let weatherDetailsView: WeatherDetailsView = {
        let view = WeatherDetailsView()
        return view
    }()
    
    init(weather: Weather) {
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = weather.name
        weatherDetailsView.configure(with: weather)
    }
    
    override func loadView() {
        self.view = weatherDetailsView
    }
}
