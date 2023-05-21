//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 30.04.2023.
//

import UIKit
import SDWebImage /* 658 */

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell" /* 543 */
    
    private let albumCoverImageView: UIImageView = { /* 633 */
       let imageView = UIImageView() /* 634 */
        imageView.image = UIImage(systemName: "photo") /* 635 */
        imageView.contentMode = .scaleAspectFill /* 636 */
        return imageView /* 637 */
    }()
    
    private let albumNameLabel: UILabel = { /* 638 */
        let label = UILabel() /* 639 */
        label.numberOfLines = 0 /* 651 */
        label.font = .systemFont(ofSize: 20, weight: .semibold) /* 640 */
        return label /* 641 */
    }()
    
    private let numberOfTracksLabel: UILabel = { /* 642 */
        let label = UILabel() /* 643 */
        label.font = .systemFont(ofSize: 18, weight: .light) /* 644 */
        label.numberOfLines = 0 /* 650 */
        return label /* 645 */
    }()
    
    private let artistNameLabel: UILabel = { /* 646 */
        let label = UILabel() /* 647 */
        label.numberOfLines = 0 /* 652 */
        label.font = .systemFont(ofSize: 18, weight: .thin) /* 648 */
        return label /* 649 */
    }()
    
    override init(frame: CGRect) { /* 624 */
        super.init(frame: frame) /* 625 */
        contentView.backgroundColor = .secondarySystemBackground /* 653 */
        contentView.addSubview(albumCoverImageView) /* 654 */
        contentView.addSubview(albumNameLabel) /* 655 */
        contentView.addSubview(artistNameLabel) /* 656 */
        contentView.clipsToBounds = true /* 675 */
        contentView.addSubview(numberOfTracksLabel) /* 657 */
    }
    
    required init?(coder: NSCoder) { /* 626 */
        fatalError() /* 627 */
    }
    
    override func layoutSubviews() { /* 628 */
        super.layoutSubviews() /* 629 */
        let imageSize: CGFloat = contentView.height-10 /* 670 */
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width-imageSize-10,
                height: contentView.height-10
            )
        ) /* 676 */
        albumNameLabel.sizeToFit() /* 667 */
        artistNameLabel.sizeToFit() /* 668 */
        numberOfTracksLabel.sizeToFit() /* 669 */
        
        //Image
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize) /* 671 */
        
        //Album name Label
        let albumLabelHeight = min(60, albumLabelSize.height) /* 677 means: take 80, otherwise albumLabelSize.height */
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 5,
            width: albumLabelSize.width, /* 678 add albumLabelSize */
            height: albumLabelHeight /* 680 */
        ) /* 674 */
//        albumNameLabel.backgroundColor = .red /* 681 */
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: albumNameLabel.bottom,
            width: contentView.width - albumCoverImageView.right-10,
            height: 30
        ) /* 679 */
//        artistNameLabel.backgroundColor = .blue /* 682 */
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: contentView.bottom-44,
            width: numberOfTracksLabel.width,
            height: 44
        ) /* 673 */
    }
    
    override func prepareForReuse() { /* 630 */
        super.prepareForReuse() /* 631 */
        albumNameLabel.text = nil /* 663 */
        artistNameLabel.text = nil /* 664 */
        numberOfTracksLabel.text = nil /* 665 */
        albumCoverImageView.image = nil /* 666 */
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) { /* 632 */
        albumNameLabel.text = viewModel.name /* 659 */
        artistNameLabel.text = viewModel.artistName /* 660 */
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)" /* 661 */
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil) /* 662 */
    }
}
