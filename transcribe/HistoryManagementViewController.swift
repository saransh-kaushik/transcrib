import UIKit

class HistoryManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "History Management"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.separatorStyle = .none // Remove separators
        return tableView
    }()

    let deleteHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete All History", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(HistoryManagementViewController.self, action: #selector(deleteHistoryTapped), for: .touchUpInside)
        return button
    }()

    var conversations: [AudioAction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupTableView()
        loadHistory()
    }

    private func setupUI() {
        view.addSubview(historyLabel)
        view.addSubview(historyTableView)
        view.addSubview(deleteHistoryButton)

        NSLayoutConstraint.activate([
            historyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            historyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            historyTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 20),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),

            deleteHistoryButton.topAnchor.constraint(equalTo: historyTableView.bottomAnchor, constant: 20),
            deleteHistoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteHistoryButton.widthAnchor.constraint(equalToConstant: 180),
            deleteHistoryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupTableView() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "ConversationCell")
    }

    private func loadHistory() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent("audioActions.json")

        do {
            let data = try Data(contentsOf: filePath)
            let audioActions = try JSONDecoder().decode([AudioAction].self, from: data)
            conversations = audioActions
            historyTableView.reloadData()
        } catch {
            print("Error loading history: \(error)")
        }
    }

    @objc func deleteHistoryTapped() {
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete all history?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.conversations.removeAll() // Clear the history
            self.historyTableView.reloadData() // Refresh the table view
            self.saveHistory() // Save empty history to file
        }))
        present(alert, animated: true, completion: nil)
    }

    private func saveHistory() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent("audioActions.json")

        do {
            let data = try JSONEncoder().encode(conversations)
            try data.write(to: filePath)
        } catch {
            print("Error saving history: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count // Return actual history count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
        let action = conversations[indexPath.row]
        
        cell.conversationImage.image = UIImage(systemName: action.playIcon)
        cell.conversationTitle.text = action.titleLabel
        cell.conversationSubtitle.text = action.subTitleLabel
        cell.conversationTime.text = action.timestampLabel
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65 // Set the cell height to 65 points
    }

    // Add spacing between cells
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Optional: Set the height of the header
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10)) // Creates a space above the first cell
    }
    
    // Reload audio actions and refresh the table when the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload the audio actions and refresh the table view
        loadHistory()
        historyTableView.reloadData()
    }
}
