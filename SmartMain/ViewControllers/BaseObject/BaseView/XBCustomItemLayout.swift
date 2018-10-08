//
//  XBCustomItemLayout.swift
//  XBShinkansen
//
//  Created by mac on 2018/3/6.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
let XBCustomItemMinimumLineSpacing:CGFloat =  20.0  // 每个item 之间的距离
let XBActiveDistance:CGFloat                = 80
class XBCustomItemLayout: UICollectionViewFlowLayout {
    private let ScaleFactor:CGFloat = 0.3  //缩放因子
    //MARK:--- 布局之前的准备工作 初始化  这个方法只会调用一次
    override func prepare() {
        scrollDirection = UICollectionViewScrollDirection.horizontal
        minimumLineSpacing = XBCustomItemMinimumLineSpacing
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        super.prepare()
    }
    //（该方法默认返回false） 返回true  frame发生改变就重新布局  内部会重新调用prepare 和layoutAttributesForElementsInRect
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //MARK:---用来计算出rect这个范围内所有cell的UICollectionViewLayoutAttributes，
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //根据当前滚动进行对每个cell进行缩放
        //首先获取 当前rect范围内的 attributes对象
        let array = super.layoutAttributesForElements(in: rect)
        var visibleRect = CGRect()
        visibleRect.origin = collectionView!.contentOffset
        visibleRect.size = collectionView!.bounds.size
        for attributes: UICollectionViewLayoutAttributes in array! {
               /// 不是当前中间item 且在 屏幕内， 则进行缩放和模糊处理
            if attributes.frame.intersects(rect) {
//                attributes.alpha = 0.7
//                let distance: CGFloat = visibleRect.midX - attributes.center.x
                //距离中点的距离
//                let normalizedDistance: CGFloat = distance / XBActiveDistance

            }
            
        }
        return array
    }
    
    ///
    /// - Parameter proposedContentOffset: 当手指滑动的时候 最终的停止的偏移量
    /// - Returns: 返回最后停止后的点
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let visibleX = proposedContentOffset.x
        let visibleY = proposedContentOffset.y
        let visibleW = collectionView?.bounds.size.width
        let visibleH = collectionView?.bounds.size.height
        //获取可视区域
        let targetRect = CGRect(x: visibleX, y: visibleY, width: visibleW!, height: visibleH!)
        
        //中心点的值
        let centerX = proposedContentOffset.x + (collectionView?.bounds.size.width)!/2
        
        //获取可视区域内的attributes对象
        let attrArr = super.layoutAttributesForElements(in: targetRect)!
        //如果第0个属性距离最小
        var min_attr = attrArr[0]
        for attributes in attrArr {
            if (abs(attributes.center.x-centerX) < abs(min_attr.center.x-centerX)) {
                min_attr = attributes
            }
        }
        //计算出距离中心点 最小的那个cell 和整体中心点的偏移
        let ofsetX = min_attr.center.x - centerX
        return CGPoint(x: proposedContentOffset.x+ofsetX, y: proposedContentOffset.y)
    }
}

