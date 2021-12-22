#!/usr/bin/swift
import Foundation

enum Template: Int, CaseIterable {
	case xcode_module
	var name: String {
		switch self {
			case .xcode_module: return "Xcode Module"
		}
	}

	var path: String {
		switch self {
			case .xcode_module: return "./XcodeModule"
		}
	}
}

// ====================== Function ===============================
let fileManager = FileManager.default
func createModule(module: Template, name: String) {
	print("Copy")
	var files: [URL] = []
	do {
		try fileManager.createDirectory(atPath: "../Submodules", withIntermediateDirectories: true,	attributes: nil)
		try fileManager.copyItem(at: .init(fileURLWithPath: module.path, isDirectory: true), to: .init(fileURLWithPath: "../Submodules/\(name)", isDirectory: true))
		if let enumerator = fileManager.enumerator(at: .init(fileURLWithPath: "../Submodules/\(name)"), includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
			for case let fileURL as URL in enumerator {
				do {
					let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
					if fileAttributes.isRegularFile! {
						files.append(fileURL)
					}
				} catch {
					print(error, fileURL)
				}
			}
		}
		for file in files {
			replaceModuleName(file: file)
		}
	} catch let err {
		print(err.localizedDescription)
	}
}

func replaceModuleName(file: URL) {
	let fileName = file.lastPathComponent
	do {
		let data = try Data(contentsOf: file)
		var string = String(data: data, encoding: .utf8)
		string = string?.replacingOccurrences(of: "__MODULE_NAME__", with: "\(moduleName)")
		try string?.write(to: file, atomically: true, encoding: .utf8)
		switch file.pathExtension {
			case "swift", "h":
				print(fileName.replacingOccurrences(of: "__MODULE_NAME__", with: "\(moduleName)"))
				let newName = fileName.replacingOccurrences(of: "__MODULE_NAME__", with: "\(moduleName)")
				var newFile = file				
				newFile.deleteLastPathComponent()
				newFile = newFile.appendingPathComponent(newName)
				try fileManager.moveItem(at: file, to: newFile)
			default:break
		}
	} catch let err {
		print(err.localizedDescription)
	}
}

var selectedTemplate: Template = .xcode_module
var moduleName: String = ""

func inputModuleName() {
	print("Enter Module Name:", terminator: " ")
	guard let readline = readLine(), !readline.isEmpty else {
		print("Invalid Module Name")
		inputModuleName()
		return
	}

	moduleName = readline
}

func main() {
	var selectedTitle = """
	Create Module by Templates:
	"""

	for module in Template.allCases {
		selectedTitle += "\n  - \(module.rawValue). \(module.name)"
	}
	print(selectedTitle + "\nInput:", terminator: " ")
	guard let readline = readLine() else {
		print("Empty, try again")
		main()
		return
	}
	let raw = Int(readline)
	if let raw = raw, let template = Template(rawValue: raw) {
		print("Create Module with \(template.name)")
		selectedTemplate = template
		inputModuleName()
		createModule(module: selectedTemplate, name: moduleName)
		print("============ CREATED ================")
	} else {
		print("Template not found")
		sleep(1)
		print("\n")
		main()
	}
}

main()