package worker

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func readUsername() (string, error) {
	file, err := os.Open(expandPath(credentialPath))
	if err != nil {
		return "", err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	if scanner.Scan() {
		return strings.TrimSpace(scanner.Text()), nil
	}
	return "", fmt.Errorf("credential.txt is empty")
}

func readFirstLog(filePath string) (string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return "", err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	if scanner.Scan() {
		return scanner.Text(), nil
	}
	return "", nil
}

func removeProcessedLog(logFile string) {
	file, err := os.Open(logFile)
	if err != nil {
		fmt.Println("Error opening log file for removal:", err)
		return
	}
	defer file.Close()

	var remainingLogs []string
	scanner := bufio.NewScanner(file)
	skipFirst := true
	for scanner.Scan() {
		if skipFirst {
			skipFirst = false
			continue
		}
		remainingLogs = append(remainingLogs, scanner.Text())
	}

	err = os.WriteFile(logFile, []byte(strings.Join(remainingLogs, "\n")), 0644)
	if err != nil {
		fmt.Println("Error updating log file:", err)
	}
}
