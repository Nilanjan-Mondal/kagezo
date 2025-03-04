package worker

import (
	"bufio"
	"fmt"
	"os"
	"time"
)

func RecoverUnfinishedTask() {
	logFile := expandPath(logFilePath)
	executingFile := expandPath(executingFilePath)

	firstLog, err := readFirstLog(logFile)
	if err != nil || firstLog == "" {
		return
	}

	executingLog, err := readFirstLog(executingFile)
	if err != nil || executingLog == "" {
		return
	}

	if firstLog == executingLog {
		fmt.Println("Detected unfinished task. Re-executing...")
		processLogEntry(firstLog)
		removeProcessedLog(logFile)
	}
}

func ProcessLogs() {
	logFile := expandPath(logFilePath)

	for {
		file, err := os.Open(logFile)
		if err != nil {
			fmt.Println("Error opening log file:", err)
			time.Sleep(checkInterval)
			continue
		}

		scanner := bufio.NewScanner(file)
		if !scanner.Scan() {
			file.Close()
			time.Sleep(checkInterval)
			continue
		}
		file.Close()

		logEntry := scanner.Text()
		processLogEntry(logEntry)
		removeProcessedLog(logFile)
		time.Sleep(1 * time.Second)
	}
}
