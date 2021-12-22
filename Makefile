.PHONY : project clear

project:
	xcodegen generate
	pod install --repo-update

clear:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*

module:
	${PWD}/templates/create_module.swift

app_graph:
	xcodegen dump --type graphviz | dot -Tsvg > dep.svg