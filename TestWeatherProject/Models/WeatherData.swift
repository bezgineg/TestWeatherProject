
import Foundation

struct WeatherData: Decodable {
    //let now: Int
    let fact: Fact
    //let forecasts: [Forecast]
}

struct Fact: Decodable {
    let temp: Int
    let condition: String
//    let cloudness: Double
//    let precType, precProb, precStrength: Int
//    let isThunder: Bool
//    let windSpeed: Double
//    let windDir: String
//    let pressureMm, pressurePa, humidity: Int
//    let daytime: String
//    let polar: Bool
//    let season, source: String
//    let accumPrec: [String: Double]
//    let soilMoisture: Double
//    let soilTemp, uvIndex, windGust: Int
//
//    enum CodingKeys: String, CodingKey {
//        case obsTime = "obs_time"
//        case uptime, temp
//        case feelsLike = "feels_like"
//        case icon, condition, cloudness
//        case precType = "prec_type"
//        case precProb = "prec_prob"
//        case precStrength = "prec_strength"
//        case isThunder = "is_thunder"
//        case windSpeed = "wind_speed"
//        case windDir = "wind_dir"
//        case pressureMm = "pressure_mm"
//        case pressurePa = "pressure_pa"
//        case humidity, daytime, polar, season, source
//        case accumPrec = "accum_prec"
//        case soilMoisture = "soil_moisture"
//        case soilTemp = "soil_temp"
//        case uvIndex = "uv_index"
//        case windGust = "wind_gust"
//    }
}

//struct Forecast: Decodable {
//    let date: String
//    let dateTs, week: Int
//    let sunrise, sunset, riseBegin, setEnd: String
//    let moonCode: Int
//    let moonText: String
//
//    enum CodingKeys: String, CodingKey {
//        case date
//        case dateTs = "date_ts"
//        case week, sunrise, sunset
//        case riseBegin = "rise_begin"
//        case setEnd = "set_end"
//        case moonCode = "moon_code"
//        case moonText = "moon_text"
//    }
//}
