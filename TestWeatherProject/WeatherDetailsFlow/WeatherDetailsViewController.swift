
import UIKit

final class WeatherDetailsViewController: UIViewController {
    
    //MARK: - Public Properties
    let weather: Weather
    
    //MARK: - Private Properties
    private let weatherDetailsView: WeatherDetailsView = {
        let view = WeatherDetailsView()
        return view
    }()
    
    //MARK: - Initializers
    init(weather: Weather) {
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        weatherDetailsView.configure(with: weather)
    }
    
    override func loadView() {
        view = weatherDetailsView
    }
    
    //MARK: - Private Methods
    private func setupNavigationBar() {
        title = weather.name
    }
}
