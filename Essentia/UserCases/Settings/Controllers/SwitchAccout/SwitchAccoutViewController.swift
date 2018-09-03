//
//  SwitchAccoutViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SwitchAccoutViewController: BaseViewController {
    @IBOutlet weak var accountsTableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var users: [User] = []
    var callBack: () -> Void
    
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var tableAdapter = TableAdapter(tableView: accountsTableview)
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    init(_ callBack: @escaping () -> Void) {
        self.callBack = callBack
        super.init()
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    
    private var state: [TableComponent] {
        let usersState = users.map({ (user) -> [TableComponent] in
            return [TableComponent.imageTitle(image: user.icon, title: user.dislayName, withArrow: true, action: {
                self.loginToUser(user)
            }),
                    .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0))]
        }).flatMap {
            return $0
        }
        return usersState + [.imageTitle(image: imageProvider.plusIcon,
                                                       title: LS("Settings.Accounts.CreateNew"),
                                                       withArrow: false,
                                                       action: createUserAction)]
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        storeCurrentUser()
        loadUsers()
        applyDesign()
        tableAdapter.reload(state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContentTopInset()
    }
    
    // MARK: - Actions
    @IBAction func cancelAction(_ sender: AnyObject) {
        callBack()
        dismiss(animated: true)
    }
    
    private func setContentTopInset() {
        let screenHeight: CGFloat = view.frame.height
        let defaultContentInsetHeight: CGFloat = 48.0
        let staticContentHeight: CGFloat = 120.0
        let singeCellHeight: CGFloat = 60.0
        let dynamicContentHeight = singeCellHeight * CGFloat(users.count)
        let allContentHeight = defaultContentInsetHeight + staticContentHeight + dynamicContentHeight
        let dynamicTopInset = screenHeight - allContentHeight
        let currentTopInset = dynamicTopInset > 24 ? dynamicTopInset : 24
        topConstraint.constant = currentTopInset
    }
    
    private func loadUsers() {
        let users = userService.get()
        self.users = users
    }
    
    private func applyDesign() {
        contentView.layer.cornerRadius = 10.0
        titleLabel.text = LS("Settings.Accounts.Title")
        titleLabel.font = AppFont.bold.withSize(21)
        cancelButton.setImage(imageProvider.cancelIcon, for: .normal)
    }
    
    // MARK: - SwitchAccountTableAdapterDelegate
    func loginToUser(_ user: User) {
        storeCurrentUser()
        EssentiaStore.currentUser = user
        callBack()
        dismiss(animated: true)
    }
    
    private lazy var createUserAction: () -> Void = { [weak self] in
        self?.generateNewUser()
        self?.callBack()
        self?.dismiss(animated: true)
    }
    
    private func storeCurrentUser() {
        let user = EssentiaStore.currentUser
        (inject() as UserStorageServiceInterface).store(user: user)
    }
    
    private func generateNewUser() {
        (inject() as LoaderInterface).show()
        (inject() as LoginInteractorInterface).generateNewUser {
            (inject() as LoaderInterface).hide()
            self.present(TabBarController(), animated: true)
        }
    }
}