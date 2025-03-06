#include "../include/shell.hpp"
#include "../include/commands.hpp"
#include "../include/utils.hpp"
#include <csignal>
#include <iostream>
#include <map>
#include <sstream>
#include <sys/wait.h>
#include <vector>

void signalHandler([[maybe_unused]] int signum) {
  std::cout << RED "\n[WARNING] Use 'exit' to quit KagezoShell." RESET
            << std::endl;
}

void Shell::showPrompt() {
  std::cout << BOLD BLUE "[" << getTimestamp() << "] " << BOLD GREEN "$ " RESET;
}

void Shell::handleCommand(const std::string &input) {
  std::istringstream iss(input);
  std::vector<std::string> tokens;
  std::string word;

  while (iss >> word) {
    tokens.push_back(word);
  }

  if (tokens.empty())
    return;

  std::string command = tokens[0];
  tokens.erase(tokens.begin());

  static std::map<std::string, std::string> commands = {{"help", "help"},
                                                        {"list", "list"},
                                                        {"start", "start"},
                                                        {"stop", "stop"},
                                                        {"update", "update"}};

  if (command == "exit") {
    std::cout << BOLD GREEN "Exiting shell..." RESET << std::endl;
    exit(0);
  }

  auto it = commands.find(command);
  if (it != commands.end()) {
    executeScript(it->second, tokens);
  } else {
    std::cerr << RED "Unknown command: " << command << RESET << std::endl;
  }
}

void Shell::start() {
  signal(SIGINT, signalHandler);
  printBanner();

  std::string input;
  while (true) {
    showPrompt();
    std::getline(std::cin, input);
    input = trim(input);
    if (!input.empty()) {
      handleCommand(input);
    }
  }
}
