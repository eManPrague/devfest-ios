import UIKit
import RxSwift
import RxCocoa

class SentenceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    private let tableView = BaseTableView(frame: .zero, style: .grouped)
    
    private let headerLabel = BaseLabel()
    private let headerView = UIView()
    
    private let footerButton = BaseButton(title: locs("create_key.button.submit"))
    private let footerView = UIView()
    
    // MARK: - Inputs
    
    private let modelsInput = BehaviorSubject<[PrivateKeyPart]>(value: [])
    var modelsObserver: AnyObserver<[PrivateKeyPart]> { return modelsInput.asObserver() }
    
    private let wrongInput = PublishSubject<Void>()
    var wrongObserver: AnyObserver<Void> { return wrongInput.asObserver() }
    
    private let disconnectedInput = PublishSubject<Void>()
    var disconnectedObserver: AnyObserver<Void> { return disconnectedInput.asObserver() }
    
    // MARK: - Outputs
    
    private let submitOutput = PublishSubject<[PrivateKeyPart]>()
    var submitObservable: Observable<[PrivateKeyPart]> { return submitOutput.asObservable() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = locs("create_key.text.header")
        
        let popButton = UIBarButtonItem(image: UIImage(named: "ic_arrow_back"), style: .plain, target: self, action: nil)
        popButton.rx.tap.bind { [unowned self] in self.navigationController?.popViewController(animated: true) }.disposed(by: bag)
        navigationItem.leftBarButtonItem = popButton
        
        wrongInput.map { locs("create_key.text.header_wrong") }.bind(to: rx.title).disposed(by: bag)
        
        // Make and add table view
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 73
        tableView.delegate = self
        tableView.estimatedRowHeight = 73
        tableView.isEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.em_register(SentenceCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // Add header label
        headerLabel.text = locs("create_key.text.subheader")
        headerLabel.df_setup()
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        headerLabel.df_setup()
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)) }
        tableView.estimatedSectionHeaderHeight = 150
        
        // Add footer button
        footerButton.didTapObservable.subscribe(onNext: { [weak self] in self?.submitOutput.onNext(try! self?.modelsInput.value() ?? []) }).disposed(by: bag)
        footerView.addSubview(footerButton)
        footerButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 40, bottom: 40, right: 40))
        }
        
        wrongInput.map { locs("create_key.text.subheader_wrong") }.bind(to: headerLabel.rx.text).disposed(by: bag)
        wrongInput.subscribe(onNext: tableView.reloadData).disposed(by: bag)
        
        disconnectedInput.map { (locs("network.error.alert_title"), locs("network.error.no_connection_to_firebase")) }.subscribe(onNext: showAlert).disposed(by: bag)
    }

    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Fit table header view
        if let tableHeaderView = tableView.tableHeaderView {
            let size = tableHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            if tableHeaderView.frame.size.height != size.height {
                tableHeaderView.frame.size.height = size.height
            }
            
            tableView.tableHeaderView = tableHeaderView
            tableView.layoutIfNeeded()
        }
        
        // Fit table footer view
        footerView.frame.size = CGSize(width: view.bounds.width, height: 99)
        tableView.tableFooterView = footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return try! modelsInput.value().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.em_dequeue(SentenceCell.self, indexPath: indexPath)
        cell.model = try! modelsInput.value()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var models = try! modelsInput.value()
        let moved = models[sourceIndexPath.row]
        models.remove(at: sourceIndexPath.row)
        models.insert(moved, at: destinationIndexPath.row)
        modelsInput.onNext(models)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Make the reorder control invisible, but touchable
        // Unfortunately there's no more elegant ways to do this
        if let reorderControl = cell.subviews.first(where: { string(fromClass: $0.self).lowercased().contains("reordercon") } ) {
            (reorderControl.subviews.first(where: { $0 is UIImageView }) as? UIImageView)?.image = nil
        }
    }
}
