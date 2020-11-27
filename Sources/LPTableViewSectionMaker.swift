//
//  LPTableViewSectionMaker.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//#if os(iOS) || os(tvOS)
import Foundation
import CoreGraphics
import UIKit
//#end

open class LPTableViewSectionMaker {
    
   lazy var section = LPDataSourceSection()
    
    @discardableResult
  public  func cell(_ cell:AnyClass) -> LPTableViewSectionMaker {
        self.section.cell = cell
        if self.section.identifier == nil {
            self.section.identifier = getIdentifier()
        }
        return self
    }
    
    @discardableResult
   public  func data(_ data:[Any]?) -> LPTableViewSectionMaker {
         if let data = data {
              self.section.data = data
          }
        return self
    }
    
    @discardableResult
   public func adapter(_ adapterBlock:@escaping AdapterBlock) ->LPTableViewSectionMaker {
        self.section.adapter = adapterBlock
        return self
    }
    
    @discardableResult
   public func height(_ height:CGFloat)  ->LPTableViewSectionMaker {
         self.section.staticHeight = height
         return self
    }
    
    @discardableResult
    public func autoHeight()  ->LPTableViewSectionMaker {
        self.section.isAutoHeight = true
        return self
    }
    
    @discardableResult
    public func cacheModelHeight(_ cache:Bool)  ->LPTableViewSectionMaker {
        self.section.cacheModelHeight = cache
        return self
    }
    
    @discardableResult
   public func event(_ eventBlock:@escaping EventBlock) ->LPTableViewSectionMaker {
        self.section.event = eventBlock
        return self
    }
    
    @discardableResult
   public func headerTitle(_ headerTitle:String) ->LPTableViewSectionMaker {
        self.section.headerTitle = headerTitle
        return self
    }
    
    @discardableResult
   public func footerTitle(_ footerTitle:String) ->LPTableViewSectionMaker {
        self.section.footerTitle = footerTitle
        return self
    }
    
    @discardableResult
   public func headerView(_ headerView:UIView) ->LPTableViewSectionMaker {
        self.section.headerView = headerView
        return self
    }
    
    @discardableResult
   public func footerView(_ footerView:UIView) ->LPTableViewSectionMaker {
       self.section.footerView = footerView
        return self
    }
    
    func getIdentifier() ->String {
        let uuidRef = CFUUIDCreate(nil)
        let uuidStrRef = CFUUIDCreateString(nil, uuidRef)
        let reStr = uuidStrRef! as String
        return reStr
    }
}
