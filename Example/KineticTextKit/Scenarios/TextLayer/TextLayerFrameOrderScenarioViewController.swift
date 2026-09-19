//
//  TextLayerFrameOrderScenarioViewController.swift
//  KineticTextKit
//

import UIKit
import KineticTextKit

/// Why the frame has to come first, shown rather than described.
///
/// `KineticTextLayer` lays its path out against its own frame at the moment
/// `text`, `font` or `contentMode` is set, and it does not lay it out again by
/// itself. Two layers here get the same text, the same font and the same frame;
/// they differ only in the order, and the top one never recovers.
final class TextLayerFrameOrderScenarioViewController: ScenarioViewController {

    private let contentFirstCanvas = UIView()

    private let contentFirstLayer = KineticTextLayer()

    private let frameFirstCanvas = UIView()

    private let frameFirstLayer = KineticTextLayer()

    private var hasSetFrameFirstContent = false

    override func viewDidLoad() {
        super.viewDidLoad()

        addNote("The same layer, the same text, the same font, the same frame. The only difference is the order.")

        outline(contentFirstCanvas, hosting: contentFirstLayer)
        add(contentFirstCanvas, height: 96)
        add(makeValueLabel("Content first — set here in viewDidLoad, while the layer's frame is still .zero. The path was laid out for a height of zero, so .center centres it on the top edge, and nothing lays it out again."))

        outline(frameFirstCanvas, hosting: frameFirstLayer)
        add(frameFirstCanvas, height: 96)
        add(makeValueLabel("Frame first — the content is set in viewDidLayoutSubviews, once the canvas has bounds and the layer has been given them. Centred, as asked for."))

        configure(contentFirstLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Both layers are given their frame here, because a CALayer added to a
        // view's layer does not resize with it. Only the second has its content
        // set afterwards, and neither is ever re-applied — so each one keeps
        // showing the order it was set in.
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        contentFirstLayer.frame = contentFirstCanvas.bounds
        frameFirstLayer.frame = frameFirstCanvas.bounds

        if !hasSetFrameFirstContent, !frameFirstCanvas.bounds.isEmpty {
            hasSetFrameFirstContent = true
            configure(frameFirstLayer)
        }

        CATransaction.commit()
    }

    /// Border and superlayer only — the frame work stays in the layout pass,
    /// where it can be read.
    private func outline(_ canvas: UIView, hosting textLayer: KineticTextLayer) {
        canvas.layer.borderWidth = 1
        canvas.layer.borderColor = UIColor.separator.cgColor
        canvas.layer.addSublayer(textLayer)
    }

    private func configure(_ textLayer: KineticTextLayer) {
        textLayer.font = .systemFont(ofSize: 32, weight: .semibold)
        textLayer.textColor = .label
        textLayer.text = "2.8"
    }
}

#if DEBUG
#Preview("Frame Before Content") {
    TextLayerFrameOrderScenarioViewController()
}
#endif
