//
//  TextLayerDefaultScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// `KineticTextLayer` on its own: added to a plain `UIView`'s layer, with the
/// three things it needs before it draws anything — a `text`, a `font` and a
/// `textColor`.
///
/// There is no `LAUTextView` here, so nothing keeps the layer's frame up to
/// date. The layer lays its path out against its own frame at the moment the
/// content is set, and a `CALayer` does not resize with the view it was added
/// to, so `viewDidLayoutSubviews` below is work a consumer writes for
/// themselves. It is spelled out rather than hidden in a helper because it is
/// the subject of this section.
final class TextLayerDefaultScenarioViewController: ScenarioViewController {

    /// A plain `UIView` — nothing from the kit. Its `layer` is the superlayer.
    private let canvas = UIView()

    private let textLayer = KineticTextLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("A KineticTextLayer added straight to a plain UIView's layer. The outline is that view's bounds.")

        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = UIColor.separator.cgColor
        canvas.layer.addSublayer(textLayer)

        add(canvas, height: 120)

        // Set here, while the canvas still has no bounds — which is the usual
        // order, and on its own the wrong one. The layout pass below is what
        // rescues it. "Frame Before Content" shows what it looks like without.
        textLayer.font = .systemFont(ofSize: 48, weight: .semibold)
        textLayer.textColor = .label
        textLayer.text = "2.8"

        addNote("Rotate the device, or open the scenario on a different size class: viewDidLayoutSubviews re-applies contentMode so the path is laid out again against the new frame.")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard textLayer.frame != canvas.bounds else {
            return
        }

        // Two steps, both needed: the frame, because the layer does not follow
        // its superlayer, and then a re-applied `contentMode`, because that is
        // what lays the path out again against the frame the layer now has.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = canvas.bounds
        textLayer.contentMode = textLayer.contentMode
        CATransaction.commit()
    }
}

#if DEBUG
#Preview("Default") {
    TextLayerDefaultScenarioViewController()
}
#endif
