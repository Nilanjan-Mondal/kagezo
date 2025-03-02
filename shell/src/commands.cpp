#include "../include/commands.hpp"
#include "../include/utils.hpp"
#include <chrono>
#include <iostream>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

void executeScript(const std::string &script,
                   const std::vector<std::string> &args) {
  std::string scriptPath = SCRIPT_DIR + script + ".sh";

  std::cout << YELLOW "Preparing to execute " << script << "..." RESET
            << std::endl;
  usleep(100000);
  auto start = std::chrono::high_resolution_clock::now();

  pid_t pid = fork();
  if (pid == 0) {
    std::vector<char *> execArgs;
    execArgs.push_back((char *)"/bin/sh");
    execArgs.push_back((char *)scriptPath.c_str());

    for (const auto &arg : args) {
      execArgs.push_back((char *)arg.c_str());
    }
    execArgs.push_back(nullptr);

    std::cout << BOLD GREEN "[INFO] Running: " << scriptPath << RESET
              << std::endl;
    execvp(execArgs[0], execArgs.data());

    perror(RED "Error executing script" RESET);
    exit(EXIT_FAILURE);
  } else if (pid > 0) {
    wait(nullptr);
    auto end = std::chrono::high_resolution_clock::now();
    double elapsed = std::chrono::duration<double>(end - start).count();
    std::cout << GREEN "[SUCCESS] Execution time: " << elapsed + 0.01 << "s"
              << RESET << std::endl;
  } else {
    perror(RED "Fork failed" RESET);
  }
}
