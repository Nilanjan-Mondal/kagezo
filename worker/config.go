package worker

import (
	"os"
	"strings"
	"time"
)

const (
	logFilePath       = "~/.local/share/kagezo/worker_log.txt"
	executingFilePath = "~/.local/share/kagezo/current_executing.txt"
	credentialPath    = "~/.local/share/kagezo/credential.txt"
	checkInterval     = 1 * time.Second
)

func expandPath(path string) string {
	home, err := os.UserHomeDir()
	if err != nil {
		panic("Error getting home directory: " + err.Error())
	}
	return strings.Replace(path, "~", home, 1)
}
