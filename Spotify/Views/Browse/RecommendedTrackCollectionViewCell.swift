//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 30.04.2023.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell" /* 545 */
    
    private let albumCoverImageView: UIImageView = { /* 705 copy from FeaturedPlaylistCollectionViewCell class (692) and change */
       let imageView = UIImageView() /* 705 */
        imageView.image = UIImage(systemName: "photo") /* 705 */
        imageView.contentMode = .scaleAspectFill /* 705 */
        return imageView /* 705 */
    }()
    
    private let trackNameLabel: UILabel = { /* 705 */
        let label = UILabel() /* 705 */
        label.numberOfLines = 0 /* 705 */
        label.font = .systemFont(ofSize: 18, weight: .regular) /* 705 */
        return label /* 705 */
    }()
    
    private let artistNameLabel: UILabel = { /* 705 */
        let label = UILabel() /* 705 */
        label.numberOfLines = 0 /* 705 */
        label.font = .systemFont(ofSize: 15, weight: .thin) /* 705 */
        return label /* 705 */
    }()
    
    override init(frame: CGRect) { /* 705 */
        super.init(frame: frame) /* 705 */
        backgroundColor = .secondarySystemBackground /* 712 */
        contentView.backgroundColor = .secondarySystemBackground /* 711 */
        contentView.addSubview(albumCoverImageView) /* 705 */
        contentView.addSubview(trackNameLabel) /* 705 */
        contentView.addSubview(artistNameLabel) /* 705 */
        contentView.clipsToBounds = true /* 705 */
    }
    
    required init?(coder: NSCoder) { /* 705 */
        fatalError() /* 705 */
    }
    
    override func layoutSubviews() { /* 705 */
        super.layoutSubviews() /* 705 */
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 2,
            width: contentView.height-4,
            height: contentView.height-4
        ) /* 708 */
        
        trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 0,
            width: contentView.width-albumCoverImageView.right-15,
            height: contentView.height/2
        ) /* 709 */
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: contentView.height/2,
            width: contentView.width-albumCoverImageView.right-15,
            height: contentView.height/2
        ) /* 710 */
    }
    
    override func prepareForReuse() { /* 705 */
        super.prepareForReuse() /* 705 */
        trackNameLabel.text = nil /* 705 */
        albumCoverImageView.image = nil /* 705 */
        artistNameLabel.text = nil /* 705 */
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) { /* 705 */
        trackNameLabel.text = viewModel.name /* 705 */
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil) /* 705 */
        artistNameLabel.text = viewModel.artistName /* 706 */
    }
    
}
