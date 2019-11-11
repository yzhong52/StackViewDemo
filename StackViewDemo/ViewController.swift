import UIKit

extension UIView {
    func addPinedSubview(_ otherView: UIView) {
        addSubview(otherView)
        otherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            otherView.topAnchor.constraint(equalTo: topAnchor),
            otherView.heightAnchor.constraint(equalTo: heightAnchor),
            otherView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }

    func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        drawHierarchy(
            in: CGRect(origin: .zero, size: frame.size),
            afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class StackView: UIStackView {
    lazy var backgroundView: UIView = {
        let otherView = UIView()
        addPinedSubview(otherView)
        return otherView
    }()
}

extension UIColor {
    func darker(ratio: CGFloat = 0.60) -> UIColor {

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r * ratio, 0.0), green: max(g * ratio, 0.0), blue: max(b * ratio, 0.0), alpha: a)
        }

        return UIColor()
    }
}
class DashedBorderView: UIView {
    var borderColor: UIColor = .black

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: 2)
        borderColor.setStroke()
        path.lineWidth = 1
        path.setLineDash([4 * scaleFactor, 4 * scaleFactor], count: 2, phase: 0)
        path.stroke()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}

class DummyBoxView: DashedBorderView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14 * scaleFactor)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    convenience init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.init(size: CGSize(width: width, height: height), color: color)
    }

    init(size: CGSize, color: UIColor) {
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let rect = CGRect(origin: .zero, size: scaledSize)
        super.init(frame: rect)
        addPinedSubview(label)
        label.text = "\(Int(size.width)/10)×\(Int(size.height)/10)"
        backgroundColor = color
        borderColor = color.darker()
        label.textColor = color.darker()
    }

    override var intrinsicContentSize: CGSize {
        return frame.size
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionViewCell: UICollectionViewCell {
    private let padding: CGFloat = 32

    lazy var stackView: UIStackView = {
        let stackView = StackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.padding),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.padding),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.padding * 1.5 + 20),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.padding),
        ])

        stackView.backgroundView.backgroundColor = stackViewBackgroundColor

        stackView.addArrangedSubview(DummyBoxView(width: 40, height: 40, color: #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
        stackView.addArrangedSubview(DummyBoxView(width: 80, height: 30, color: #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)))
        stackView.addArrangedSubview(DummyBoxView(width: 30, height: 80, color: #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)))

        return stackView
    }()

    lazy var title: UILabel = {
        let title = UILabel()
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.padding),
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: self.padding),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.padding),
        ])
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()

    static var reuseIdentifier: String {
        return String(describing: type(of: self))
    }
}

extension UIStackView.Alignment {
    static var allValues: [UIStackView.Alignment] {
        var allValues: [UIStackView.Alignment] = []
        switch UIStackView.Alignment.fill {
        case .fill:
            allValues.append(.fill)
            fallthrough
        case .leading, .top:
            // `leading` for vertical
            // `top` for horizontal
            allValues.append(.top)
            fallthrough
        case .firstBaseline: // Valid for horizontal axis only
            allValues.append(.firstBaseline)
            fallthrough
        case .center:
            allValues.append(.center)
            fallthrough
        case .trailing, .bottom:
            // `trailing` for vertical
            // `bottom` for horizontal
            allValues.append(.trailing)
            fallthrough
        case .lastBaseline:
            allValues.append(.lastBaseline)
            fallthrough
        @unknown default:
            break
        }
        return allValues
    }
}

extension UIStackView.Distribution {
    static var allValues: [UIStackView.Distribution] {
        var allValues: [UIStackView.Distribution] = []
        switch UIStackView.Distribution.fill {
        case .fill:
            allValues.append(.fill)
            fallthrough
        case .fillEqually:
            allValues.append(.fillEqually)
            fallthrough
        case .fillProportionally:
            allValues.append(.fillProportionally)
            fallthrough
        case .equalSpacing:
            allValues.append(.equalSpacing)
            fallthrough
        case .equalCentering:
            allValues.append(.equalCentering)
            fallthrough
        @unknown default:
            break
        }
        return allValues
    }
}

extension UIStackView {
    private var distributionDesc: String {
        switch distribution {
        case .fill:
            return "Fill"
        case .fillEqually:
            return "Fill Equally"
        case .fillProportionally:
            return "Fill Proportionally"
        case .equalSpacing:
            return "Equal Spacing"
        case .equalCentering:
            return "Equal Centering"
        @unknown default:
            return "Unknown"
        }
    }

    private var alignmentDesc: String {
        switch alignment {
        case .fill:
            return "Fill"
        case .leading: // same for top
            switch axis {
            case .vertical: return "Leading"
            case .horizontal: return "Top"
            @unknown default:
                fatalError()
            }
        case .firstBaseline:
            return "First baseline"
        case .center:
            return "Center"
        case .trailing: // same as bottom
            switch axis {
            case .vertical: return "Trailing"
            case .horizontal: return "Bottom"
            @unknown default:
                fatalError()
            }
        case .lastBaseline:
            return "Last Baseline"
        @unknown default:
            return "Unknonw"
        }
    }

    var settingsDesc: String {
        return "\(distributionDesc), \(alignmentDesc)"
    }
}


private let scaleFactor: CGFloat = 2.0
private let cellItemWidth: CGFloat = 350 * scaleFactor
private let cellItemHeight: CGFloat = 200 * scaleFactor
private let outpubFolder = "/Users/yuchen/Desktop/StackViewOutputs"
// private let stackViewBackgroundColor: UIColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
private let stackViewBackgroundColor: UIColor = .white


class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .white
        view.delaysContentTouches = true
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.gray
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private let distributions = UIStackView.Distribution.allValues
    private let alignments = UIStackView.Alignment.allValues
    private let snapshots = Set<IndexPath>()

    private lazy var sectionCount: Int = {
        return self.distributions.count
    }()

    private lazy var rowCount: Int = {
        return self.alignments.count
    }()

    private lazy var contentSize: CGSize = {
        return CGSize(
            width: CGFloat(sectionCount) * cellItemWidth,
            height: self.view.frame.height)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addPinedSubview(scrollView)

        scrollView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: contentSize.width),
            collectionView.heightAnchor.constraint(equalToConstant: contentSize.height)
        ])
        scrollView.contentSize = contentSize

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false

        collectionViewLayout.itemSize = CGSize(width: cellItemWidth, height: cellItemHeight)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)

        do {
            try FileManager.default.createDirectory(atPath: outpubFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Unable to create outpubFolder \(error)")
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return alignments.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return distributions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.stackView.alignment = alignments[indexPath.section]
        cell.stackView.distribution = distributions[indexPath.row]
        cell.title.text = cell.stackView.settingsDesc

        if !self.snapshots.contains(indexPath) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let data = cell.stackView.takeSnapshot()?.jpegData(compressionQuality: 1.0)
                let path = "\(outpubFolder)/\(cell.stackView.settingsDesc).jpg"
                FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
            }
        }
        return cell
    }
}

