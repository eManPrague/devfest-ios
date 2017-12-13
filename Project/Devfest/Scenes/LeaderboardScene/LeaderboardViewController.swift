import UIKit
import RxSwift
import RxCocoa

class LeaderboardViewController: BaseViewController {
    
    private let bag = DisposeBag()
    
    // MARK: - Inputs
    
    private let modelsInput = ReplaySubject<[UserViewModel]>.create(bufferSize: 1)
    var modelsObserver: AnyObserver<[UserViewModel]> { return modelsInput.asObserver() }
    
    // MARK: - Outputs
    
    private let didLoadOutput = PublishSubject<Void>()
    var didLoadObservable: Observable<Void> { return didLoadOutput.asObservable() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = locs("leaderboard.text.header")
        
        // Make and add table view
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        tableView.em_register(LeaderboardCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // Bind models to table view
        modelsInput.bind(to: tableView.rx.items(cellIdentifier: LeaderboardCell.em_reuseIdentifier, cellType: LeaderboardCell.self)) { row, element, cell in
            cell.viewModel = element
        }.disposed(by: bag)

        didLoadOutput.onNext()
    }
}
