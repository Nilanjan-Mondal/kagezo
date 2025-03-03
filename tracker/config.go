package tracker

import (
	"bufio"
	"os"
	"strings"
)

var directories []string
var ignoredExtensions = make(map[string]bool)

func loadDirectories(filename string) {
	file, err := os.Open(filename)
	if err != nil {
		logChange("Error opening " + filename + ": " + err.Error())
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		dir := strings.TrimSpace(scanner.Text())
		if dir != "" {
			directories = append(directories, dir)
		}
	}
}

func loadIgnoredExtensions(filename string) {
	file, err := os.Open(filename)
	if err != nil {
		logChange("Error opening " + filename + ": " + err.Error())
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		ext := strings.ToLower(strings.TrimSpace(scanner.Text()))
		if ext != "" && strings.HasPrefix(ext, ".") {
			ignoredExtensions[ext] = true
		}
	}
}
