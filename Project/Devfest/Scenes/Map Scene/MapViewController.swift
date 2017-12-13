import Foundation
import UIKit
import RxSwift
import GoogleMaps
import Firebase

class MapViewController: BaseViewController {
    
    private let bag = DisposeBag()
    
    // MARK: Public
    
    // MARK: Inputs
    
    // MARK: Outputs
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = UIView()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = locs("map.vc.title")
        tabBarItem.title = navigationItem.title
        tabBarItem.image = #imageLiteral(resourceName: "ic_map").withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = #imageLiteral(resourceName: "ic_map_active").withRenderingMode(.alwaysOriginal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        displaySessionButton(false)
        
        let l1 = (50.131874746778095 + 50.12830372401131) / 2
        let l2 = (14.37673319131136 + 14.372546598315239) / 2
        
        let camera = GMSCameraPosition.camera(withLatitude: l1, longitude: l2, zoom: 17)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.mapType = .normal
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)) }
        
        Notification.Name.KMLUpdated.mapVoid().startWith(Void()).map { _ in DataManager.sharedInstance.kmlURL }.filterNil().bind { url in
            
            let url = URL(fileURLWithPath: url.path)
            
            let kmlParser = GMUKMLParser(url: url)
            kmlParser.parse()
            let renderer = GMUGeometryRenderer(map: mapView, geometries: kmlParser.placemarks, styles: kmlParser.styles)
            renderer.render()
            
        }.disposed(by: bag)

        // Loading done
        didLoadOutput.onNext()
    }
    
    // MARK: Public funcs
    
    // MARK: Private funcs
}
