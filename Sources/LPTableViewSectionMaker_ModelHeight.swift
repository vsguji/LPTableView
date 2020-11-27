//
//  LPTableViewSectionMaker_ModelHeight.swift
//  swiftTemplate
//
//  Created by lipeng on 2018/3/13.
//  Copyright © 2018 lipeng. All rights reserved.
//

//#if os(iOS) || os(tvOS)
import Foundation
//#endif

extension LPTableViewSectionMaker {
    
    @discardableResult
   public func autoModelHeight() ->LPTableViewSectionMaker {
        self.section.autoModelHeight = true
        return self
    }
}
