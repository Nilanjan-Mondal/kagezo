#include "../include/shell.hpp"
#include "../include/commands.hpp"
#include "../include/utils.hpp"
#include <csignal>
#include <cstdio>
#include <iostream>
#include <map>
#include <sstream>
#include <sys/wait.h>
#include <termios.h>
#include <unistd.h>
#include <vector>

std::vector<std::string> history;
int historyIndex = 0;
void signalHandler([[maybe_unused]] int signum) {
  std::cout << RED "\n[WARNING] Use 'exit' to quit KagezoShell." RESET
            << std::endl;
}

void Shell::setRawMode(bool enable) {
  static struct termios oldt, newt;
  if (enable) {
    tcgetattr(STDIN_FILENO, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
  } else {
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
  }
}

void clearLine() {
  std::cout << "\33[2K\r" << BOLD BLUE "[" << getTimestamp() << "] "
            << BOLD GREEN "$ " RESET << std::flush;
}

std::string Shell::readInput() {
  std::string input;
  char c;
  setRawMode(true);
  int tempIndex = history.size();

  while (true) {
    c = getchar();

    if (c == '\n') {
      std::cout << std::endl;
      break;
    } else if (c == 127) {
      if (!input.empty()) {
        std::cout << "\b \b";
        input.pop_back();
      }
    } else if (c == 27) {
      if (getchar() == '[') {
        char arrow = getchar();
        if (arrow == 'A') {
          if (!history.empty() && tempIndex > 0) {
            tempIndex--;
            input = history[tempIndex];
            clearLine();
            std::cout << input;
          }
        } else if (arrow == 'B') {
          if (tempIndex < history.size() - 1) {
            tempIndex++;
            input = history[tempIndex];
            clearLine();
            std::cout << input;
          } else {
            tempIndex = history.size();
            input.clear();
            clearLine();
          }
        }
      }
    } else {
      std::cout << c;
      input += c;
    }
  }

  setRawMode(false);
  return input;
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
    std::string input = readInput();
    if (input.empty()) {
      continue;
    }
    history.push_back(input);
    historyIndex = history.size();

    input = trim(input);
    if (!input.empty()) {
      handleCommand(input);
    }
  }
}
