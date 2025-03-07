package main

import worker "github.com/mintRaven-05/kagezo/worker"

func main() {
	worker.RecoverUnfinishedTask()
	worker.ProcessLogs()
}
