//
//  HapticsManager.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 29.04.2023.
//

import Foundation
import UIKit /* 2034 */

final class HapticsManager { /* 2033 */
    static let shared = HapticsManager() /* 2035 */
    
    private init() {} /* 2036 */
    
    public func vibrateForSelection() { /* 2037 */
        DispatchQueue.main.async { /* 2045 */
            let generator = UISelectionFeedbackGenerator() /* 2039 */
            generator.prepare() /* 2040 */
            generator.selectionChanged() /* 2041 */
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) { /* 2038 */
        DispatchQueue.main.async { /* 2046 */
            let generator = UINotificationFeedbackGenerator() /* 2042 */
            generator.prepare() /* 2043 */
            generator.notificationOccurred(type) /* 2044 */
        }
    }
}

