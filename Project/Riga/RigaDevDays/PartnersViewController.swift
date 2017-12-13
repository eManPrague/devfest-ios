//
//  PartnersViewController.swift
//  RigaDevDays
//
//  Created by Dmitry Beloborodov on 13/02/2017.
//  Copyright © 2017 RigaDevDays. All rights reserved.
//

import Foundation

import Firebase

class PartnersViewController: UIViewController  {

    @IBOutlet weak var partnersCollectionView: UICollectionView!
    
    fileprivate var isShadow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        partnersCollectionView.em_register(CompanyCell.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: .PartnerUpdated, object: nil)
        
        displaySessionButton(false)
    }

    func dataChanged() {
        partnersCollectionView.reloadData()
    }
}

extension PartnersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DataManager.sharedInstance.partnerGroups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.sharedInstance.partnerGroups[section].partners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return collectionView.em_dequeue(CompanyCell.self, indexPath: indexPath)
        }
        
        let cell: PartnerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerCell", for: indexPath) as! PartnerCell
        cell.partner = DataManager.sharedInstance.partnerGroups[indexPath.section].partners[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PartnerHeaderView", for: indexPath) as!  PartnerHeaderView
            let partnerGroup = DataManager.sharedInstance.partnerGroups[indexPath.section]
            cell.sectionTitle.text = partnerGroup.title?.replacingOccurrences(of: "-", with: " ").localizedCapitalized
            return cell
        } else {
            return UICollectionReusableView()
        }
    }
}

extension PartnersViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            (isShadow && scrollView.contentOffset.y < 100) ||
            (!isShadow && scrollView.contentOffset.y >= 100)
        else { return }
        
        let image = scrollView.contentOffset.y >= 100 ? nil : UIImage()
        isShadow = image == nil
        
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0.001, height: 0.001)
        }
        
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let partnerURL = URL.init(string: DataManager.sharedInstance.partnerGroups[indexPath.section].partners[indexPath.row].url!) {
            UIApplication.shared.openURL(partnerURL)
        }
    }
}

extension PartnersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        
        var cellHeight = 100.0
        cellHeight = Double(collectionView.frame.size.width - 30.0) / 2.0
        return CGSize(width: cellHeight, height: cellHeight / 5 * 2 )
    }
}

class PartnerHeaderView: UICollectionReusableView {
    @IBOutlet weak var sectionTitle: UILabel!
}
