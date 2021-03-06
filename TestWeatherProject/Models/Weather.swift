import Foundation

struct Weather: Equatable {
    
    //MARK: - Public Properties
    var name: String
    var temperature: Int
    var feelsLike: Int
    var precType: Int
    var windSpeed: Double
    var pressureMm: Int
    var humidity: Int
    var condition: String
    var decription: String {
        switch condition {
        case "clear":
            return "ясно"
        case "partly-cloudy":
            return "малооблачно"
        case "cloudy":
            return "облачно с прояснениями"
        case "overcast":
            return "пасмурно"
        case "drizzle":
            return "морось"
        case "light-rain":
            return "небольшой дождь"
        case "rain":
            return "дождь"
        case "moderate-rain":
            return "умеренно сильный дождь."
        case "heavy-rain":
            return "сильный дождь"
        case "continuous-heavy-rain":
            return "длительный сильный дождь"
        case "showers":
            return "ливень"
        case "wet-snow":
            return "дождь со снегом"
        case "light-snow":
            return "небольшой снег"
        case "snow":
            return "снег"
        case "snow-showers":
            return "снегопад"
        case "hail":
            return "град"
        case "thunderstorm":
            return "гроза"
        case "thunderstorm-with-rain":
            return "дождь с грозой"
        case "thunderstorm-with-hail":
            return "гроза с градом"
        default:
            return "Неустановленные данные"
        }
    }
}
