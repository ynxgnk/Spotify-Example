//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import UIKit
import SDWebImage /* 1340 */

class SearchResultDefaultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultDefaultTableViewCell" /* 1312 */

    private let label: UILabel = { /* 1321 */
       let label = UILabel() /* 1322 */
        label.numberOfLines = 1 /* 1323 */
        return label; /* 1324 */
    }()
    
    private let iconImageView: UIImageView = { /* 1325 */
       let imageView = UIImageView() /* 1326 */
        imageView.contentMode = .scaleAspectFill /* 1327 */
        return imageView /* 1328 */
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { /* 1313 */
        super.init(style: style, reuseIdentifier: reuseIdentifier) /* 1314 */
        contentView.addSubview(label) /* 1329 */
        contentView.addSubview(iconImageView) /* 1330 */
        contentView.clipsToBounds = true /* 1331 */
        accessoryType = .disclosureIndicator /* 1332 */
    }
    
    required init?(coder: NSCoder) { /* 1315 */
        fatalError() /* 1316 */
    }
    
    override func layoutSubviews() { /* 1317 */
        super.layoutSubviews() /* 1318 */
        let imageSize: CGFloat = contentView.height-10 /* 1352 */
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize, /* 1353 change to imageSize */
            height: imageSize /* 1354 change to imageSize */
        ) /* 1335 */
        iconImageView.layer.cornerRadius = imageSize/2 /* 1355 */
        iconImageView.layer.masksToBounds = true /* 1356 */
        label.frame = CGRect(
            x: iconImageView.right+10,
            y: 0,
            width: contentView.width - iconImageView.right-15,
            height: contentView.height
        ) /* 1336 */
    }
    
    override func prepareForReuse() { /* 1319 */
        super.prepareForReuse() /* 1320 */
        iconImageView.image = nil /* 1333 */
        label.text = nil /* 1334 */
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) { /* 1341 */
        label.text = viewModel.title /* 1342 */
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil) /* 1343 */ /* 1891 add placeholderImage*/
    }
}
 
