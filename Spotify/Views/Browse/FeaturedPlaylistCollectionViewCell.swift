//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 30.04.2023.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell" /* 544 */
    
    private let playlistCoverImageView: UIImageView = { /* 692 copy from NewReleaseCollectionViewCell class (633) and change */
       let imageView = UIImageView() /* 692 */
        imageView.layer.masksToBounds = true /* 703 */
        imageView.layer.cornerRadius = 4 /* 704 */
        imageView.image = UIImage(systemName: "photo") /* 692 */
        imageView.contentMode = .scaleAspectFill /* 692 */
        return imageView /* 692 */
    }()
    
    private let playlistNameLabel: UILabel = { /* 692 */
        let label = UILabel() /* 692 */
        label.numberOfLines = 0 /* 692 */
        label.textAlignment = .center /* 701 */
        label.font = .systemFont(ofSize: 18, weight: .regular) /* 692 */
        return label /* 692 */
    }()
    
    private let creatorNameLabel: UILabel = { /* 692 */
        let label = UILabel() /* 692 */
        label.numberOfLines = 0 /* 692 */
        label.textAlignment = .center /* 702 */
        label.font = .systemFont(ofSize: 15, weight: .thin) /* 692 */
        return label /* 692 */
    }()
    
    override init(frame: CGRect) { /* 692 */
        super.init(frame: frame) /* 692 */
//        contentView.backgroundColor = .red /* 692 */
        contentView.addSubview(playlistCoverImageView) /* 692 */
        contentView.addSubview(playlistNameLabel) /* 692 */
        contentView.addSubview(creatorNameLabel) /* 692 */
        contentView.clipsToBounds = true /* 692 */
    }
    
    required init?(coder: NSCoder) { /* 692 */
        fatalError() /* 692 */
    }
    
    override func layoutSubviews() { /* 692 */
        super.layoutSubviews() /* 692 */
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-30,
            width: contentView.width-6,
            height: 30
        ) /* 697 */
        
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-60,
            width: contentView.width-6,
            height: 30
        ) /* 698 */
        let imageSize = contentView.height-70 /* 699 */
        
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width-imageSize)/2,
            y: 3,
            width: imageSize,
            height: imageSize
        ) /* 700 */
    }
    
    override func prepareForReuse() { /* 692 */
        super.prepareForReuse() /* 692 */
        playlistNameLabel.text = nil /* 692 */
        playlistCoverImageView.image = nil /* 692 */
        creatorNameLabel.text = nil /* 692 */
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) { /* 692 */
        playlistNameLabel.text = viewModel.name /* 692 */
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil) /* 694 */
        creatorNameLabel.text = viewModel.creatorName /* 693 */
    }
    
}
