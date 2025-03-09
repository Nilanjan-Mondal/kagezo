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
  std::cout << "\33[2K\r" << BOLD BLUE "[" << "kagezoShell" << "] "
            << BOLD GREEN "$ " RESET << std::flush;
}

std::string Shell::readInput() {
  std::string input;
  char c;
  setRawMode(true);
  size_t tempIndex = history.size();
  size_t cursorPos = 0;

  auto moveCursorLeft = [](size_t &pos) {
    if (pos > 0) {
      pos--;
      std::cout << "\33[D"; // Move left
    }
  };

  auto moveCursorRight = [](size_t &pos, size_t len) {
    if (pos < len) {
      pos++;
      std::cout << "\33[C"; // Move right
    }
  };

  while (true) {
    c = getchar();

    if (c == '\n') {
      std::cout << std::endl;
      break;
    } else if (c == 127) { // Backspace
      if (cursorPos > 0) {
        input.erase(cursorPos - 1, 1);
        cursorPos--;
        std::cout << "\b \b";
        std::cout << "\33[s" << input.substr(cursorPos) << " \33[u"; // Redraw
      }
    } else if (c == 27) { // Arrow or special keys
      if (getchar() == '[') {
        char arrow = getchar();

        if (arrow == 'A') { // Up arrow
          if (!history.empty() && tempIndex > 0) {
            tempIndex--;
            input = history[tempIndex];
            cursorPos = input.length();
            clearLine();
            std::cout << input;
          }
        } else if (arrow == 'B') { // Down arrow
          if (tempIndex < history.size() - 1) {
            tempIndex++;
            input = history[tempIndex];
          } else {
            tempIndex = history.size();
            input.clear();
          }
          cursorPos = input.length();
          clearLine();
          std::cout << input;
        } else if (arrow == 'D') { // Left arrow
          moveCursorLeft(cursorPos);
        } else if (arrow == 'C') { // Right arrow
          moveCursorRight(cursorPos, input.length());
        } else if (arrow == '3' && getchar() == '~') { // Delete key
          if (cursorPos < input.length()) {
            input.erase(cursorPos, 1);
            std::cout << "\33[s" << input.substr(cursorPos)
                      << " \33[u"; // Redraw
          }
        } else if (arrow == '1' && getchar() == ';') { // Check for Ctrl
          if (getchar() == '5') {
            char ctrlArrow = getchar();
            if (ctrlArrow == 'D') { // Ctrl + Left
              if (cursorPos > 0) {
                do {
                  moveCursorLeft(cursorPos);
                } while (cursorPos > 0 && input[cursorPos - 1] != ' ');
                while (cursorPos > 0 && input[cursorPos - 1] == ' ') {
                  moveCursorLeft(cursorPos); // Skip spaces
                }
              }
            } else if (ctrlArrow == 'C') { // Ctrl + Right
              if (cursorPos < input.length()) {
                do {
                  moveCursorRight(cursorPos, input.length());
                } while (cursorPos < input.length() && input[cursorPos] != ' ');
                while (cursorPos < input.length() && input[cursorPos] == ' ') {
                  moveCursorRight(cursorPos, input.length()); // Skip spaces
                }
              }
            }
          }
        }
      }
    } else {
      input.insert(cursorPos, 1, c);
      cursorPos++;
      std::cout << "\33[s" << input.substr(cursorPos - 1)
                << "\33[u\33[C"; // Insert mode
    }
  }

  setRawMode(false);
  return input;
}

void Shell::showPrompt() {
  std::cout << BOLD BLUE "[" << "kagezoShell" << "] " << BOLD GREEN "$ " RESET;
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
