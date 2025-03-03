package tracker

import (
	"maps"
	"os"
	"path/filepath"
	"strings"
	"time"
)

type FileInfo struct {
	Size    int64
	ModTime time.Time
}

var dirState = make(map[string]FileInfo)

func scanDirectory(dir string) (map[string]FileInfo, error) {
	files := make(map[string]FileInfo)

	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			ext := strings.ToLower(filepath.Ext(path))
			if !ignoredExtensions[ext] {
				files[path] = FileInfo{Size: info.Size(), ModTime: info.ModTime()}
			}
		}
		return nil
	})

	return files, err
}

func detectChanges(newState map[string]FileInfo) {
	for path, info := range newState {
		oldInfo, exists := dirState[path]
		if !exists {
			logChange("<CREATE> " + path)
		} else if oldInfo.ModTime != info.ModTime && oldInfo.Size != info.Size {
			logChange("<MODIFY> " + path)
		}
	}

	for path := range dirState {
		if _, exists := newState[path]; !exists {
			logChange("<PURGE> " + path)
		}
	}

	dirState = newState
}

func initializeTracker() {
	tempState := make(map[string]FileInfo)
	for _, dir := range directories {
		state, err := scanDirectory(dir)
		if err != nil {
			logChange("Error scanning " + dir + ": " + err.Error())
			continue
		}
		maps.Copy(tempState, state)
	}
	dirState = tempState
}

func updateTracker() {
	newState := make(map[string]FileInfo)
	for _, dir := range directories {
		state, err := scanDirectory(dir)
		if err != nil {
			logChange("Error scanning " + dir + ": " + err.Error())
			continue
		}
		maps.Copy(newState, state)
	}
	detectChanges(newState)
}
