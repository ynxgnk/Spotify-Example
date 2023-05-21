//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import UIKit
import SDWebImage /* 1357 copy whole file from SearchResultDefaultTableViewCell and change */

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell" /* 1357 */
    
    private let label: UILabel = { /* 1357 */
        let label = UILabel() /* 1357 */
        label.numberOfLines = 1 /* 1357 */
        return label; /* 1357 */
    }()
    
    private let subtitleLabel: UILabel = { /* 1357 */
       let label = UILabel() /* 1357 */
        label.textColor = .secondaryLabel /* 1358 */
        label.numberOfLines = 1 /* 1357 */
        return label; /* 1357 */
    }()
    
    private let iconImageView: UIImageView = { /* 1357 */
       let imageView = UIImageView() /* 1357 */
        imageView.contentMode = .scaleAspectFill /* 1357 */
        return imageView /* 1357 */
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { /* 1357 */
        super.init(style: style, reuseIdentifier: reuseIdentifier) /* 1357 */
        contentView.addSubview(label) /* 1357 */
        contentView.addSubview(subtitleLabel) /* 1359 */
        contentView.addSubview(iconImageView) /* 1357 */
        contentView.clipsToBounds = true /* 1357 */
        accessoryType = .disclosureIndicator /* 1357 */
    }
    
    required init?(coder: NSCoder) { /* 1357 */
        fatalError() /* 1357 */
    }
    
    override func layoutSubviews() { /* 1357 */
        super.layoutSubviews() /* 1357 */
        let imageSize: CGFloat = contentView.height-10 /* 1357 */
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize, /* 1357 */
            height: imageSize /* 1357 */
        ) /* 1357 */
        let labelHeight = contentView.height/2 /* 1365 */
        label.frame = CGRect(
            x: iconImageView.right+10,
            y: 0,
            width: contentView.width - iconImageView.right-15,
            height: labelHeight /* 1366 add labelHeight */
        ) /* 1357 */
        
        subtitleLabel.frame = CGRect(
            x: iconImageView.right+10,
            y: label.bottom,
            width: contentView.width - iconImageView.right-15,
            height: labelHeight
        ) /* 1367 */
    }
    
    override func prepareForReuse() { /* 1357 */
        super.prepareForReuse() /* 1357 */
        iconImageView.image = nil /* 1357 */
        label.text = nil /* 1357 */
        subtitleLabel.text = nil /* 1360 */
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) { /* 1357 */ /* 1363 change to ...SubtitleViewModel */
        label.text = viewModel.title /* 1357 */
        subtitleLabel.text = viewModel.subtitle /* 1364 */
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"), completed: nil) /* 1357 */
    }
}
 
