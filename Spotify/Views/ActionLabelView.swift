//
//  ActionLabelView.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 02.05.2023.
//

import UIKit

struct ActionLabelViewViewModel { /* 1777 */
    let text: String /* 1778 */
    let actionTitle: String /* 1779 */
}

protocol ActionLabelViewDelegate: AnyObject { /* 1784 */
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) /* 1785 */
}

class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate? /* 1786 */
    
    private let label: UILabel = { /* 1768 */
        let label = UILabel() /* 1769 */
        label.textAlignment = .center /* 1770 */
        label.numberOfLines = 0 /* 1771 */
        label.textColor = .secondaryLabel /* 1803 */
        return label /* 1772 */
    }()
    
    private let button: UIButton = { /* 1773 */
        let button = UIButton() /* 1774 */
        button.setTitleColor(.link, for: .normal) /* 1775 */
        return button /* 1776 */
    }()
    
    override init(frame: CGRect) { /* 1761 */
        super.init(frame: frame) /* 1762 */
//        backgroundColor = .red /* 1801 */
        clipsToBounds = true /* 1763 */
        isHidden = true /* 1794 */
        addSubview(button) /* 1781 */
        addSubview(label) /* 1782 */
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside) /* 1783 */
    }
    
    required init?(coder: NSCoder) { /* 1764 */
        fatalError() /* 1765 */
    }
    
    @objc func didTapButton() { /* 1787 */
        delegate?.actionLabelViewDidTapButton(self) /* 1788 */
    }
    
    override func layoutSubviews() { /* 1766 */
        super.layoutSubviews() /* 1767 */
        button.frame = CGRect(x: 0, y: height-40, width: width, height: 40) /* 1791 */
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45) /* 1792 */
    }
    
    func configure(with viewModel: ActionLabelViewViewModel) { /* 1780 */
        label.text = viewModel.text /* 1789 */
        button.setTitle(viewModel.actionTitle, for: .normal) /* 1790 */
    }
}
