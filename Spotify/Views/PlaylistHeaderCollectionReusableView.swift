//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 01.05.2023.
//

import UIKit
import SDWebImage /* 843 */

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject { /* 906 */
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) /* 907 */
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView" /* 835 */
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate? /* 908 */
    
    private let nameLabel: UILabel = { /* 851 */
        let label = UILabel() /* 852 */
        label.font = .systemFont(ofSize: 22, weight: .semibold) /* 853 */
        return label /* 854 */
    }()
    
    private let descriptionlabel: UILabel = { /* 851 */
        let label = UILabel() /* 855 */
        label.textColor = .secondaryLabel /* 890 */
        label.font = .systemFont(ofSize: 18, weight: .regular) /* 856 */
        label.numberOfLines = 0 /* 889 */
        return label /* 857 */
    }()
    
    private let ownerLabel: UILabel = { /* 858 */
        let label = UILabel() /* 859 */
        label.textColor = .secondaryLabel /* 891 */
        label.font = .systemFont(ofSize: 18, weight: .light) /* 860 */
        return label /* 861 */
    }()
    
    private let imageView: UIImageView = { /* 862 */
        let imageView = UIImageView() /* 863 */
        imageView.contentMode = .scaleAspectFill /* 864 */
        imageView.image = UIImage(systemName: "photo") /* 865 */
        return imageView /* 866 */
    }()
    
    private let playAllButton: UIButton = { /* 892 */
       let button = UIButton() /* 893 */
        button.backgroundColor = .systemGreen /* 894 */
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)) /* 904 */
        button.setImage(image, for: .normal) /* 895 */ /* 905 add image */
        button.tintColor = .white /* 896 */
        button.layer.cornerRadius = 30 /* 897 */
        button.layer.masksToBounds = true /* 898 */
        return button /* 899 */
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 836 */
        super.init(frame: frame) /* 837 */
        backgroundColor = .systemBackground /* 838 */
        addSubview(imageView) /* 867 */
        addSubview(nameLabel) /* 868 */
        addSubview(descriptionlabel) /* 869 */
        addSubview(ownerLabel) /* 870 */
        addSubview(playAllButton) /* 900 */
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside) /* 901 */
    }
    
    required init?(coder: NSCoder) { /* 839 */
        fatalError() /* 840 */
    }
    
    @objc private func didTapPlayAll() { /* 902 */
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self) /* 909 */
    }
    
    override func layoutSubviews() { /* 841 */
        super.layoutSubviews() /* 842 */
        let imageSize: CGFloat = height/1.8 /* 884 */
        imageView.frame = CGRect(
            x: (width-imageSize)/2,
            y: 20,
            width: imageSize,
            height: imageSize
        ) /* 885 */
        
        nameLabel.frame = CGRect(
            x: 10,
            y: imageView.bottom,
            width: width-20,
            height: 44
        ) /* 886 */
        
        descriptionlabel.frame = CGRect(
            x: 10,
            y: nameLabel.bottom,
            width: width-20,
            height: 44
        ) /* 887 */
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: descriptionlabel.bottom,
            width: width-20,
            height: 44
        ) /* 888 */
        
        playAllButton.frame = CGRect(
            x: width-80,
            y: height-80,
            width: 60,
            height: 60
        )
    } /* 903 */
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) { /* 871 */ /* 877 change String*/
        nameLabel.text = viewModel.name /* 878 */
        ownerLabel.text = viewModel.ownerName /* 879 */
        descriptionlabel.text = viewModel.description /* 880 */
        imageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "photo"), completed: nil) /* 881 */ /* 1902 add placeholderImage */
    }
    
    
}
