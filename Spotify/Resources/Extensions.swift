//
//  Extensions.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation
import UIKit /* 90 */

extension UIView { /* 91 */
    var width: CGFloat { /* 92 */
        return frame.size.width /* 93 */
    }
    var height: CGFloat { /* 92 */
        return frame.size.height /* 93 */
    }
    var left: CGFloat { /* 92 */
        return frame.origin.x /* 93 */
    }
    var right: CGFloat { /* 92 */
        return left + width /* 93 */
    }
    var top: CGFloat { /* 92 */
        return frame.origin.y /* 93 */
    }
    var bottom: CGFloat { /* 92 */
        return top + height /* 93 */
    }
}

extension DateFormatter { /* 977 */
    static let dateFormatter: DateFormatter = { /* 978 */
        let dateFormatter = DateFormatter() /* 979 */
        dateFormatter.dateFormat = "YYYY-MM-dd" /* 980 */
        return dateFormatter /* 981 */
    }()
    
    static let displayDateFormatter: DateFormatter = { /* 985 */
        let dateFormatter = DateFormatter() /* 986 */
        dateFormatter.dateStyle = .medium /* 987 */
        return dateFormatter /* 988 */
    }()
}

extension String { /* 982 */
    static func formattedDate(string: String) -> String { /* 983 */
        guard let date = DateFormatter.dateFormatter.date(from: string) else { /* 984 */
            return string /* 990 */
        }
        return DateFormatter.displayDateFormatter.string(from: date) /* 989 */
    }
}

extension Notification.Name { /* 2024 */
    static let albumSavedNotification = Notification.Name("albumSavedNotification") /* 2025 */
}
