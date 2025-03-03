package tracker

import (
	"log"
	"os"
	"time"
)

var localpath string = ""

func StartTracker() {
	dirname, err := os.UserHomeDir()
	if err != nil {
		log.Fatal(err)
	}
	localpath = dirname + "/.local/share/kagezo/"
	loadDirectories(localpath + "track.txt")
	loadIgnoredExtensions(localpath + "ignore.txt")

	if len(directories) == 0 {
		logChange("No directories to track. Exiting...")
		return
	}
	logChange("---------------------------------")
	logChange("KAGEZO TRACKER JOURNAL RESTARTED")
	logChange("---------------------------------")
	logChange("[+] Directories found to track...")
	initializeTracker()
	logChange("[+] Tracker daemon initialized")
	logChange("[+] Auto-backup daemon activated")
	logChange("---------------------------------")

	for {
		time.Sleep(500 * time.Millisecond)
		updateTracker()
	}
}
