import UIKit

enum Colors {
    
    case red, green, blue, purple, yellow, magenta, orange, clear, white
    
    var color: UIColor {
        switch self {
            case .red:
                return UIColor.red
                
            case .green:
                return UIColor.green
                
            case .blue:
                return UIColor.blue
            
            case .purple:
                return UIColor.purple
            
            case .yellow:
                return UIColor.yellow
            
            case .magenta:
                return UIColor.magenta
            
            case .orange:
                return UIColor.orange
            
            case .clear:
                return UIColor.clear
            case .white:
                return UIColor.white
            
        }
    }
}
