//
//  MyTableViewCell.swift
//  film
//
//  Created by Dev Trop-plus on 15/03/2022.
//

import SwiftUI

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    var tv : Tv?
    var parent : UIViewController?
    
    override var isSelected: Bool{
       didSet{
         if self.isSelected
         {
             let viewDetail : ViewDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "movieDetail")
             print("view")
             viewDetail.tv = self.tv!
             parent!.present(viewDetail, animated: true, completion: nil)
         }
       }
    }
}
