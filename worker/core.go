package worker

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
)

var logPattern = regexp.MustCompile(`^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] (\w+) - (.+)$`)

func processLogEntry(logEntry string) {
	matches := logPattern.FindStringSubmatch(logEntry)

	if len(matches) != 4 {
		fmt.Println("Invalid log format:", logEntry)
		return
	}

	timestamp := matches[1]
	event := matches[2]
	filePath := matches[3]
	fileName := filepath.Base(filePath)

	username, err := readUsername()
	if err != nil {
		fmt.Println("Error reading username:", err)
		return
	}

	fmt.Println("Processing log:")
	fmt.Println("  Timestamp:", timestamp)
	fmt.Println("  Event:", event)
	fmt.Println("  File Path:", filePath)
	fmt.Println("  File Name:", fileName)
	fmt.Println("  Username:", username)

	err = os.WriteFile(expandPath(executingFilePath), []byte(logEntry+"\n"), 0644)
	if err != nil {
		fmt.Println("Error writing to current_executing.txt:", err)
	}
}
