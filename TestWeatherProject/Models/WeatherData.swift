
import Foundation

struct WeatherData: Decodable {
    let fact: Fact
}

struct Fact: Decodable {
    let temp: Int
    let condition: String
    let feelsLike: Int
    let precType: Int
    let windSpeed: Double
    let pressureMm: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case condition
        case precType = "prec_type"
        case windSpeed = "wind_speed"
        case pressureMm = "pressure_mm"
        case humidity
        case temp
    }
}

