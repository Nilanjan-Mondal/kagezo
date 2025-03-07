#ifndef SHELL_HPP
#define SHELL_HPP

#include <string>

class Shell {
public:
  void start();

private:
  void showPrompt();
  void setRawMode(bool enable);
  std::string readInput();
  void handleCommand(const std::string &input);
};

#endif
