//
//  LPTableViewDataSource.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//
//#if os(iOS) || os(tvOS)
import UIKit
//#endif

extension UITableView {
    
    var lpTableViewDataSource:LPBaseTableViewDataSource? {
        get {
            let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "lpTableViewDataSource".hash)
            return objc_getAssociatedObject(self, key) as? LPBaseTableViewDataSource
        }
        set{
            let key:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "lpTableViewDataSource".hash)
            objc_setAssociatedObject(self, key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func getIdentifier() -> String? {
        let uuidRef = CFUUIDCreate(nil)
        let uuidStrRef = CFUUIDCreateString(nil, uuidRef)
        let retStr = uuidStrRef as? String
        return retStr
    }
    
    public func makeDataSource(_ maker: @escaping (_ :LPTableViewDataSourceMaker?) ->Void) {
         let make = LPTableViewDataSourceMaker(tableView: self)
         maker(make)
        var dataSourceClass = LPBaseTableViewDataSource.self
        var delegates = [AnyHashable:Any]()
        if (make.commitEditingBlock != nil) || (make.scrollViewDidScrollBlock != nil) {
            if let utf = getIdentifier() {
              let key:UnsafePointer<Int8>! = (utf as NSString).utf8String
                dataSourceClass = objc_allocateClassPair(LPBaseTableViewDataSource.self, key, 0) as! LPBaseTableViewDataSource.Type
              }
            if make.commitEditingBlock != nil {
                if let editing = commitEditingByTableView as? IMP {
                    class_addMethod(dataSourceClass, NSSelectorFromString("tableView:commitEditingStyle:forRowAtIndexPath:"), editing, "v@:@@@")
                }
                if let commitEditingBlock = make.commitEditingBlock {
                    delegates["tableView:commitEditingStyle:forRowAtIndexPath:"] = commitEditingBlock
                }
            }
            if make.scrollViewDidScrollBlock != nil {
                if let scroll = scrollViewDidScrollByTableView as? IMP {
                    class_addMethod(dataSourceClass, NSSelectorFromString("scrollViewDidScroll:"), scroll, "v@:@")
                }
                if let scrollViewDidScrollBlock = make.scrollViewDidScrollBlock {
                    delegates["scrollViewDidScroll:"] = scrollViewDidScrollBlock
                }
            }
        }
        if self.tableFooterView == nil {
            self.tableFooterView = UIView()
        }
        let delegateProtocol = dataSourceClass.init()
        delegateProtocol.sections = (make.sections)
        delegateProtocol.delegates = delegates
        self.lpTableViewDataSource = delegateProtocol
        self.dataSource = delegateProtocol
        self.delegate = delegateProtocol
    }
    
    public func makeSection(withData data:[[AnyHashable:Any]]?) {
        let delegates = [AnyHashable:Any]()
        let make = LPTableViewSectionMaker()
        make.data(data)
        make.cell(UITableViewCell.self)
        self.register(make.section.cell, forCellReuseIdentifier: make.section.identifier ?? "")
        make.section.tableViewCellStyle = UITableViewCell.CellStyle.default
        guard let item = data else { return }
        for itemDic in item {
            if itemDic["detail"] != nil {
                make.section.tableViewCellStyle = UITableViewCell.CellStyle.subtitle
                break
            }
            if itemDic["value"] != nil {
                make.section.tableViewCellStyle = UITableViewCell.CellStyle.value1
                break
            }
        }
        let delegateProtocol = LPSampleTableViewDataSource.init()
        if self.tableFooterView != nil {
            self.tableFooterView = UIView()
        }
        delegateProtocol.sections = [make.section]
        delegateProtocol.delegates = delegates
        self.lpTableViewDataSource = delegateProtocol
        self.dataSource = delegateProtocol
        self.delegate = delegateProtocol
    }
    
  public  func makeSection(withData data:[AnyHashable]?, cellClass:AnyClass) {
        makeDataSource { (make:LPTableViewDataSourceMaker?) in
            make?.makeSection({ (section:LPTableViewSectionMaker?) in
                section?.data(data)
                section?.cell(cellClass)
                section?.adapter({ (cell, rowObj, row,section) in
                    if cell != nil {
                        let cellObj = cell as! NSObjectProtocol
                        if cellObj.responds(to: NSSelectorFromString("configure:")) {
                            cellObj.perform(NSSelectorFromString("configure:"), with: rowObj)
                        }
                        else if cellObj.responds(to: NSSelectorFromString("configure:index:")){
                            cellObj.perform(NSSelectorFromString("configure:index:"), with: rowObj, with: row)
                        }
                    }
                })
                section?.autoHeight()
            })
        }
    }
    
    func commitEditingByTableView(_ selfObj:Any?,_ cmd:Selector,_ tableViewSelf:UITableView?, _ editingStyle:UITableViewCell.EditingStyle,_ indexPath:NSIndexPath?) {
        let delegateProtocol:LPBaseTableViewDataSourceProtocol = (selfObj as! LPBaseTableViewDataSourceProtocol)
        let block:((_ tableview:UITableView?,_ editingStyle:UITableViewCell.EditingStyle,_ indexpath:NSIndexPath?) ->Void)? = delegateProtocol.delegates![NSStringFromSelector(cmd)] as? ((UITableView?, UITableViewCell.EditingStyle, NSIndexPath?) -> Void)
        if block != nil {
            block!(tableViewSelf,editingStyle,indexPath)
        }
    }
    
    func scrollViewDidScrollByTableView(_ selfObj:Any? ,_ cmd:Selector, _ scrollView:UIScrollView?) {
         let delegateProtocol:LPBaseTableViewDataSourceProtocol = (selfObj as! LPBaseTableViewDataSourceProtocol)
        let block:((_ scrollView:UIScrollView?) ->Void)? = delegateProtocol.delegates?[NSStringFromSelector(cmd)] as? ((UIScrollView?) -> Void)
        if block != nil {
            block!(scrollView)
        }
    }
}
