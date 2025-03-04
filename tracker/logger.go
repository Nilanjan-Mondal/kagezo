package tracker

import (
	"fmt"
	"os"
	"time"
)

func logChange(message string) {

	f, err := os.OpenFile(localpath+"output.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		fmt.Println("Error opening log file:", err)
		return
	}
	defer f.Close()

	logMessage := fmt.Sprintf("[%s] %s\n", time.Now().Format("2006-01-02 15:04:05"), message)
	f.WriteString(logMessage)
}
func logWorker(message string) {

	f, err := os.OpenFile(localpath+"worker_log.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		fmt.Println("Error opening log file:", err)
		return
	}
	defer f.Close()

	logMessage := fmt.Sprintf("[%s] %s\n", time.Now().Format("2006-01-02 15:04:05"), message)
	f.WriteString(logMessage)
}
