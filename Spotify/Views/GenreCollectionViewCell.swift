//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import UIKit
import SDWebImage /* 1129 */

class CategoryCollectionViewCell: UICollectionViewCell { /* 1034 */
    static let identifier = "CategoryCollectionViewCell" /* 1035 */
    
    private let imageView: UIImageView = { /* 1043 */
       let imageView = UIImageView() /* 1044 */ 
        imageView.contentMode = .scaleAspectFit /* 1045 */
        imageView.tintColor = .white /* 1046 */
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)) /* 1047 */
        return imageView /* 1048 */
    }()
    
    private let label: UILabel = { /* 1049 */
       let label = UILabel() /* 1050 */
        label.textColor = .white /* 1051 */
        label.font = .systemFont(ofSize: 22, weight: .semibold) /* 1052 */
        return label /* 1053 */
    }()
    
    private let colors: [UIColor] = [ /* 1072 */
            .systemPink,
            .systemBlue,
            .systemPurple,
            .systemOrange,
            .systemGreen,
            .systemRed,
            .systemYellow,
            .systemGray,
            .systemTeal
    ]
    
    override init(frame: CGRect) { /* 1036 */
        super.init(frame: frame) /* 1037 */
//        backgroundColor = .systemPurple /* 1038 */
        contentView.layer.cornerRadius = 8 /* 1070 */
        contentView.layer.masksToBounds = true /* 1071 */
        contentView.addSubview(label) /* 1054 */
        contentView.addSubview(imageView) /* 1055 */
    }
    
    required init?(coder: NSCoder) { /* 1039 */
        fatalError() /* 1040 */
    }
    
    override func prepareForReuse() { /* 1056 */
        super.prepareForReuse() /* 1057 */
        label.text = nil /* 1058 */
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)) /* 1059 */
    }
    
    override func layoutSubviews() { /* 1041 */
        super.layoutSubviews() /* 1042 */
        
        label.frame = CGRect(
            x: 10,
            y: contentView.height/2,
            width: contentView.width-20,
            height: contentView.height/2
        ) /* 1061 */
        
        imageView.frame = CGRect(
            x: contentView.width/2,
            y: 0,
            width: contentView.width/2,
            height: contentView.height/2
            ) /* 1062 */
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) { /* 1059 */ /* 1127 change String and change title to viewModel */
        label.text = viewModel.title /* 1060 */ /* 1128 add viewModel */
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil) /* 1130 */
        contentView.backgroundColor = colors.randomElement() /* 1069 */ /* 1073 change .systemPink */
    }
}
