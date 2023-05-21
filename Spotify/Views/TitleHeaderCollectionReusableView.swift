//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableIdentifier" /* 928 */
    
    private let label: UILabel = { /* 937 */
       let label = UILabel() /* 938 */
        label.textColor = .label /* 939 */
        label.numberOfLines = 1 /* 940 */
        label.font = .systemFont(ofSize: 22, weight: .regular) /* 941 */
        return label /* 942 */
    }()
    
    override init(frame: CGRect) { /* 929 */
        super.init(frame: frame) /* 930 */
        backgroundColor = .systemBackground /* 931 */
        addSubview(label) /* 943 */
    }
    
    required init?(coder: NSCoder) { /* 932 */
        fatalError() /* 933 */
    }
    
    override func layoutSubviews() { /* 935 */
        super.layoutSubviews() /* 936 */
        label.frame = CGRect(x: 15, y: 0, width: width-30, height: height) /* 945 */
    }
    
    func configure(with title: String) { /* 934 */
        label.text = title /* 944 */
    }
}
