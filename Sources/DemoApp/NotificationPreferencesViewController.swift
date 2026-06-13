import UIKit
import UserNotifications

class NotificationPreferencesViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let notificationOptions = ["Receive News Updates", "Receive Promotional Offers", "Receive App Updates"]
    private var notificationSettings: [String: Bool] = [:]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchNotificationSettings()
    }

    // MARK: - Setup
    private func setupView() {
        title = "Notification Preferences"
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationPreferenceCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Data
    private func fetchNotificationSettings() {
        // Simulate fetching settings from persistent storage or server
        notificationSettings = [
            "Receive News Updates": true,
            "Receive Promotional Offers": false,
            "Receive App Updates": true
        ]
        tableView.reloadData()
    }

    private func updateNotificationSetting(for option: String, isEnabled: Bool) {
        notificationSettings[option] = isEnabled
        // Simulate saving settings to persistent storage or server
    }
}

// MARK: - UITableViewDataSource
extension NotificationPreferencesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationPreferenceCell", for: indexPath)
        let option = notificationOptions[indexPath.row]
        cell.textLabel?.text = option
        let isEnabled = notificationSettings[option] ?? false
        cell.accessoryView = UISwitch().apply {
            $0.isOn = isEnabled
            $0.tag = indexPath.row
            $0.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationPreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Actions
extension NotificationPreferencesViewController {
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let option = notificationOptions[sender.tag]
        updateNotificationSetting(for: option, isEnabled: sender.isOn)
    }
}

// MARK: - UISwitch Extension
private extension UISwitch {
    func apply(_ closure: (UISwitch) -> Void) -> UISwitch {
        closure(self)
        return self
    }
}