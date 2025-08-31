enum WatchSize: String, Codable {
    // Series 9
    case series9_45mm = "Series 9 45mm"
    case series9_41mm = "Series 9 41mm"
    
    // SE Models
    case se_44mm = "SE 44mm"
    case se_40mm = "SE 40mm"
    
    // Ultra Models
    case ultra_49mm = "Ultra 49mm"
    case seriesUltra2 = "Ultra 2"
    
    var width: CGFloat {
        switch self {
        case .series9_45mm: return 396
        case .series9_41mm: return 352
        case .se_44mm: return 384
        case .se_40mm: return 324
        case .ultra_49mm, .seriesUltra2: return 410
        }
    }
    
    var height: CGFloat {
        switch self {
        case .series9_45mm: return 484
        case .series9_41mm: return 430
        case .se_44mm: return 448
        case .se_40mm: return 394
        case .ultra_49mm, .seriesUltra2: return 502
        }
    }
}
