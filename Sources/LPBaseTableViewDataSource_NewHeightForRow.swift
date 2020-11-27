//
//  LPBaseTableViewDataSource_NewHeightForRow.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//import Foundation
//import UIKit

//extension LPBaseTableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let section = indexPath.section
//        let row = indexPath.row
//        let identifier = self.sections[section].identifier ?? ""
//        if self.sections[section].isAutoHeight {
//            let adapterBlock = self.sections[section].adapter;
//            let data = self.sections[section].data?[row]
//            let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: identifier.hashValue)
//            let numHeight = objc_getAssociatedObject(data as Any, key) as? NSNumber
//            if numHeight != nil {
//
//                // modelHeight
//
//
//                let cell = newCellForReuseIdentifier(identifier, tableView: tableView)
//                cell.prepareForReuse()
//                guard (adapterBlock != nil) else {
//                    let height = newSystemFittingHeightForConfiguredCell(cell, tableView: tableView)
//                    objc_setAssociatedObject(data as Any, key, height, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                    return height
//                }
//                adapterBlock!(cell,data,row)
//            }
//        }
//        else if (self.sections[section].staticHeight > 0) {
//            return self.sections[section].staticHeight
//        }
//        else {
//            return tableView.rowHeight;
//        }
//        return 0
//    }
//
//
//    func newCellForReuseIdentifier(_ identifier:String,tableView:UITableView) -> UITableViewCell {
//         let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: identifier.hashValue)
//         var templateCellsByIdentifiers:[String:UITableViewCell]? = objc_getAssociatedObject(self, key) as? [String : UITableViewCell]
//         if templateCellsByIdentifiers == nil {
//            templateCellsByIdentifiers = [:]
//            objc_setAssociatedObject(self, key, templateCellsByIdentifiers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//         }
//        var templateCell = templateCellsByIdentifiers?[identifier]
//        if templateCell == nil {
//            templateCell = tableView.dequeueReusableCell(withIdentifier: identifier)
//            templateCell?.contentView.translatesAutoresizingMaskIntoConstraints = false
//        }
//        return templateCell!
//    }
//
//
//    func newSystemFittingHeightForConfiguredCell(_ cell:UITableViewCell,tableView:UITableView) -> CGFloat {
//        var contentViewWidth = tableView.frame.width
//        if cell.accessoryView != nil {
//            contentViewWidth -= 16 + cell.accessoryView!.frame.width
//        }
//        else {
//            let systemAccessoryWidths = [UITableViewCell.AccessoryType.none:CGFloat(0),
//                                         UITableViewCell.AccessoryType.disclosureIndicator:CGFloat(34),
//                                         UITableViewCell.AccessoryType.detailDisclosureButton:CGFloat(68),
//                                         UITableViewCell.AccessoryType.checkmark:CGFloat(40),
//                                         UITableViewCell.AccessoryType.detailButton:CGFloat(48)]
//            contentViewWidth -= systemAccessoryWidths[cell.accessoryType]!
//        }
//        var fittingHeight:CGFloat = 0.0
//        if contentViewWidth > 0 {
//            let widthFenceConstraint = NSLayoutConstraint(item: cell.contentView,
//                                                          attribute: NSLayoutConstraint.Attribute.width,
//                                                          relatedBy: NSLayoutConstraint.Relation.equal,
//                                                          toItem: nil,
//                                                          attribute: NSLayoutConstraint.Attribute.notAnAttribute,
//                                                          multiplier: 1.0,
//                                                          constant: contentViewWidth)
//            cell.contentView.addConstraint(widthFenceConstraint)
//            fittingHeight = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//            cell.contentView.removeConstraint(widthFenceConstraint)
//        }
//        if fittingHeight == 0 {
//            #if DEBUG
//            if cell.contentView.constraints.count > 0 {
//                let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "systemFittingSizeing".hash)
//                if objc_getAssociatedObject(self, key) != nil {
//                    print("warning : Cannot get a proper cell height (now 0) form '- systemFittingSizeing:'(AutoLayout).You should check how constraints are built in cell,making it into self-sizing cell.")
//                    objc_setAssociatedObject(self, key, true, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                }
//            }
//            #endif
//        }
//        if fittingHeight == 0 {
//            fittingHeight = 44
//        }
//        if tableView.separatorStyle != UITableViewCell.SeparatorStyle.none {
//            fittingHeight += 1.0 / UIScreen.main.scale
//        }
//        return fittingHeight
//    }
//}
