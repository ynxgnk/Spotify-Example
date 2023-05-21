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
