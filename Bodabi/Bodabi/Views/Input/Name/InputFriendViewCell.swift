//
//  InputFriendViewCell.swift
//  Bodabi
//
//  Created by jaehyeon lee on 15/02/2019.
//  Copyright © 2019 LeeHyeJin. All rights reserved.
//

import UIKit

class InputFriendViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstTagLabel: UILabel!
    @IBOutlet weak var secondTagLabel: UILabel!
    @IBOutlet weak var thirdTagLabel: UILabel!
    @IBOutlet weak var firstTagIcon: UIView!
    @IBOutlet weak var secondTagIcon: UIView!
    @IBOutlet weak var thirdTagIcon: UIView!
    
    // MARK: - Property
    
    public var friend: Friend? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clear()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clear()
    }
    
    // MARK: - Method
    
    private func clear() {
        firstTagIcon.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        secondTagIcon.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        thirdTagIcon.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        firstTagLabel.text = ""
        secondTagLabel.text = ""
        thirdTagLabel.text = ""
    }
    
    private func configure() {
        nameLabel.text = friend?.name
        guard let tags = friend?.tags else { return }
        if tags.count >= 1 {
            firstTagLabel.text = tags[0]
            firstTagIcon.backgroundColor = Tag.type(of: tags[0])?.color
        }
        if tags.count >= 2 {
            secondTagLabel.text = tags[1]
            secondTagIcon.backgroundColor = Tag.type(of: tags[1])?.color
        }
        if tags.count == 3 {
            thirdTagLabel.text = tags[2]
            thirdTagIcon.backgroundColor = Tag.type(of: tags[2])?.color
        }
    }
}

