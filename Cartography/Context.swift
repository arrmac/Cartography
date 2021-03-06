//
//  Context.swift
//  Cartography
//
//  Created by Robert Böhnke on 06/10/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

public class Context {
    internal var constraints: [Constraint] = []

    internal func addConstraint(from: Property, to: Property? = nil, coefficients: Coefficients = Coefficients(), relation: NSLayoutRelation = .Equal) -> NSLayoutConstraint {
        from.view.car_translatesAutoresizingMaskIntoConstraints = false

        let layoutConstraint = NSLayoutConstraint(item: from.view,
                                                  attribute: from.attribute,
                                                  relatedBy: relation,
                                                  toItem: to?.view,
                                                  attribute: to?.attribute ?? .NotAnAttribute,
                                                  multiplier: CGFloat(coefficients.multiplier),
                                                  constant: CGFloat(coefficients.constant))

        let targetView: View = to.map { to in
            let commonSuperivew = closestCommonAncestor(from.view, to.view)

            assert(commonSuperivew != .None, "No common superview found between \(from.view) and \(to.view)")

            return commonSuperivew!
        } ?? from.view

        constraints.append(Constraint(view: targetView, layoutConstraint: layoutConstraint))

        return layoutConstraint
    }

    internal func addConstraint(from: Compound, coefficients: [Coefficients]? = nil, to: Compound? = nil, relation: NSLayoutRelation = NSLayoutRelation.Equal) -> [NSLayoutConstraint] {
        var results: [NSLayoutConstraint] = []

        for i in 0..<from.properties.count {
            let n: Coefficients = coefficients?[i] ?? Coefficients()

            results.append(addConstraint(from.properties[i], coefficients: n, to: to?.properties[i], relation: relation))
        }

        return results
    }
}
