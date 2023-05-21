//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import Foundation
import UIKit /* 968 */

class AlbumTrackCollectionViewCell: UICollectionViewCell { 
    static let identifier = "AlbumTrackCollectionViewCell" /* 967 copy whole file from RecommendedTrackCollectionViewCell(545) and change */
    
    private let trackNameLabel: UILabel = { /* 967 */
        let label = UILabel() /* 967 */
        label.numberOfLines = 0 /* 967 */
        label.font = .systemFont(ofSize: 18, weight: .regular) /* 967 */
        return label /* 967 */
    }()
    
    private let artistNameLabel: UILabel = { /* 967 */
        let label = UILabel() /* 967 */
        label.numberOfLines = 0 /* 967 */
        label.font = .systemFont(ofSize: 15, weight: .thin) /* 967 */
        return label /* 967 */
    }()
    
    override init(frame: CGRect) { /* 967 */
        super.init(frame: frame) /* 967 */
        backgroundColor = .secondarySystemBackground /* 967 */
        contentView.backgroundColor = .secondarySystemBackground /* 967 */
        contentView.addSubview(trackNameLabel) /* 967 */
        contentView.addSubview(artistNameLabel) /* 967 */
        contentView.clipsToBounds = true /* 967 */
    }
    
    required init?(coder: NSCoder) { /* 967 */
        fatalError() /* 967 */
    }
    
    override func layoutSubviews() { /* 967 */
        super.layoutSubviews() /* 967 */
        
        trackNameLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width-15,
            height: contentView.height/2
        ) /* 967 */
        
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.height/2,
            width: contentView.width-15,
            height: contentView.height/2
        ) /* 967 */
    }
    
    override func prepareForReuse() { /* 967 */
        super.prepareForReuse() /* 967 */
        trackNameLabel.text = nil /* 967 */
        artistNameLabel.text = nil /* 967 */
    }
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel) { /* 967 */ /* 974 change RecommendedTrackCellViewModel */
        trackNameLabel.text = viewModel.name /* 967 */
        artistNameLabel.text = viewModel.artistName /* 967 */
    }
    
}
