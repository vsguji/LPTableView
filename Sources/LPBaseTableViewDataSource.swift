//
//  LPBaseTableViewDataSource.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//#if os(iOS) || os(tvOS)
import UIKit
//#endif

protocol LPBaseTableViewDataSourceProtocol:UITableViewDataSource,UITableViewDelegate {
    var sections:[LPDataSourceSection]!{ get set }
    var delegates:[AnyHashable:Any]? {get set}
}

public typealias AdapterBlock = (Any?,Any?,Int,Int) -> Void
public typealias EventBlock = (Int,Any,Int) -> Void

public class LPBaseTableViewDataSource:NSObject {
       
    var scrollBlock:((UIScrollView) ->Void)?
    
    required override init() {
    
    }
}

extension LPBaseTableViewDataSource:LPBaseTableViewDataSourceProtocol {
   
   public func numberOfSections(in tableView: UITableView) -> Int {
           return self.sections?.count ?? 0;
    }
       
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.sections![section].data?.count ?? 0;
    }
       
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: self.sections![section].identifier ?? "", for: indexPath)
        guard let block  = self.sections[section].adapter else { return cell }
        let data = self.sections[section].data;
        block(cell,data,index,section)
        return cell
    }
    
   public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].headerTitle;
    }
    
   public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.sections[section].footerTitle;
    }
    
  public  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sections[section].headerView;
    }
    
  public  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.sections[section].footerView;
    }
    
   public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let itemHeaderView = self.sections[section].headerView else {
            guard let itemHeaderTitle = self.sections[section].headerTitle else { return 0 }
            print("header title" + itemHeaderTitle)
            return 40;
        }
        return itemHeaderView.frame.size.height;
    }
    
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let itemFooterView = self.sections[section].footerView else {
            guard let itemFooterTitle = self.sections[section].footerTitle else { return 0 }
            print("footer title" + itemFooterTitle)
            return 40
        }
        return itemFooterView.frame.size.height;
    }
    
   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        let identifier = self.sections[section].identifier ?? ""
        if self.sections[section].isAutoHeight {
            let adapterBlock = self.sections[section].adapter;
            let data = self.sections[section].data?[row]
            let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: identifier.hashValue)
            let numHeight = objc_getAssociatedObject(data as Any, key) as? NSNumber
            if numHeight == nil {
                if self.sections[section].autoModelHeight { // 获取模型高度
                    if data != nil {
                        let selector = NSSelectorFromString("modelHeight")
                        let  dataObj = (data as! NSObjectProtocol)
                        if dataObj.responds(to: selector) {
                          let height = (((data as! NSObjectProtocol).perform(selector))?.takeUnretainedValue()) as! NSNumber
                            if (self.sections[section].cacheModelHeight) { // 需要缓存
                               objc_setAssociatedObject(data as Any, key, height, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                            }
                          return CGFloat(height.floatValue)
                        }
                    }
                    return tableView.rowHeight
                }
                else {
                  let cell = cellForReuseIdentifier(identifier, tableView: tableView)
                  cell.prepareForReuse()
                  guard (adapterBlock != nil) else {
                     let height = systemFittingHeightForConfiguredCell(cell, tableView: tableView)
                     if (self.sections[section].cacheModelHeight) { // 需要缓存
                        objc_setAssociatedObject(data as Any, key, height, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                     }
                     return height
                   }
                  adapterBlock!(cell,data,row,section)
              }
            }
            else {
                return CGFloat(numHeight?.floatValue ?? 0)
            }
        }
        else if (self.sections[section].staticHeight > 0) {
            return self.sections[section].staticHeight
        }
        else {
            return tableView.rowHeight;
        }
        return 0
    }
    
   public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let event = sections[section].event
        if event == nil {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let index = indexPath.row
        let data = sections[section].data?[index]
        event?(index, data as Any,section)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollBlock?(scrollView)
    }
    
    func cellForReuseIdentifier(_ identifier:String,tableView:UITableView) -> UITableViewCell {
         let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: identifier.hashValue)
         var templateCellsByIdentifiers:[String:UITableViewCell]? = objc_getAssociatedObject(self, key) as? [String : UITableViewCell]
         if templateCellsByIdentifiers == nil {
            templateCellsByIdentifiers = [:]
            objc_setAssociatedObject(self, key, templateCellsByIdentifiers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
         }
        var templateCell = templateCellsByIdentifiers?[identifier]
        if templateCell == nil {
            templateCell = tableView.dequeueReusableCell(withIdentifier: identifier)
            templateCell?.contentView.translatesAutoresizingMaskIntoConstraints = false
        }
        return templateCell!
    }
    
    
    func systemFittingHeightForConfiguredCell(_ cell:UITableViewCell,tableView:UITableView) -> CGFloat {
        var contentViewWidth = tableView.frame.width
        if cell.accessoryView != nil {
            contentViewWidth -= 16 + cell.accessoryView!.frame.width
        }
        else {
            let systemAccessoryWidths = [UITableViewCell.AccessoryType.none:CGFloat(0),
                                         UITableViewCell.AccessoryType.disclosureIndicator:CGFloat(34),
                                         UITableViewCell.AccessoryType.detailDisclosureButton:CGFloat(68),
                                         UITableViewCell.AccessoryType.checkmark:CGFloat(40),
                                         UITableViewCell.AccessoryType.detailButton:CGFloat(48)]
            contentViewWidth -= systemAccessoryWidths[cell.accessoryType]!
        }
        var fittingHeight:CGFloat = 0.0
        if contentViewWidth > 0 {
            let widthFenceConstraint = NSLayoutConstraint(item: cell.contentView,
                                                          attribute: NSLayoutConstraint.Attribute.width,
                                                          relatedBy: NSLayoutConstraint.Relation.equal,
                                                          toItem: nil,
                                                          attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                          multiplier: 1.0,
                                                          constant: contentViewWidth)
            cell.contentView.addConstraint(widthFenceConstraint)
            fittingHeight = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            cell.contentView.removeConstraint(widthFenceConstraint)
        }
        if fittingHeight == 0 {
            #if DEBUG
            if cell.contentView.constraints.count > 0 {
                let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "systemFittingSizeing".hash)
                if objc_getAssociatedObject(self, key) != nil {
                    print("warning : Cannot get a proper cell height (now 0) form '- systemFittingSizeing:'(AutoLayout).You should check how constraints are built in cell,making it into self-sizing cell.")
                    objc_setAssociatedObject(self, key, true, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
            #endif
        }
        if fittingHeight == 0 {
            fittingHeight = 44
        }
        if tableView.separatorStyle != UITableViewCell.SeparatorStyle.none {
            fittingHeight += 1.0 / UIScreen.main.scale
        }
        return fittingHeight
    }
    
   public var delegates: [AnyHashable:Any]?  {
           get {
                let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "delegates".hash)
                return objc_getAssociatedObject(self, key) as? [AnyHashable:Any]
           }
           set {
                let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "delegates".hash)
                objc_setAssociatedObject(self, key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
       }
       var sections:[LPDataSourceSection]! {
          set{
              let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "sections".hash)
              objc_setAssociatedObject(self, key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
          }
          get{
              let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "sections".hash)
              return objc_getAssociatedObject(self, key) as? [LPDataSourceSection]
          }
       }
    
}

class LPSampleTableViewDataSource: LPBaseTableViewDataSource {
    
}

extension LPSampleTableViewDataSource {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell = tableView.dequeueReusableCell(withIdentifier: self.sections[section].identifier ?? "")
        if cell != nil {
            cell = UITableViewCell(style: self.sections[section].tableViewCellStyle, reuseIdentifier: self.sections[section].identifier ?? "")
        }
        let rowDic:NSDictionary? = self.sections[section].data![row] as? NSDictionary
        cell?.textLabel?.text = rowDic?["text"] as? String
        if rowDic?["detail"] != nil {
        cell?.detailTextLabel?.text = rowDic?["detail"] as? String
        }
        if rowDic?["value"] != nil {
            cell?.detailTextLabel?.text = rowDic?["value"] as? String
        }
        if rowDic?["image"] != nil {
            cell?.imageView?.image = UIImage(named: rowDic?["image"] as? String ?? "")
        }
        if rowDic?["accessoryType"] != nil {
            cell?.accessoryType = rowDic?["accessoryType"] as? UITableViewCell.AccessoryType ?? UITableViewCell.AccessoryType.none
        }
        return cell!
    }
}
