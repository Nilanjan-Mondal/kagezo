#include "../include/utils.hpp"
#include <ctime>
#include <fstream>
#include <unistd.h>

void printBanner() {
  std::cout << GREEN R"(

    ██╗  ██╗ █████╗  ██████╗ ███████╗███████╗ ██████╗ 
    ██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝╚══███╔╝██╔═══██╗
    █████╔╝ ███████║██║  ███╗█████╗    ███╔╝ ██║   ██║
    ██╔═██╗ ██╔══██║██║   ██║██╔══╝   ███╔╝  ██║   ██║
    ██║  ██╗██║  ██║╚██████╔╝███████╗███████╗╚██████╔╝
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝   )" __VERSION "\n\n"
            << std::endl;
  std::cout
      << "    Interactive shell for managing backup\n    Automate and control "
         "you'r backup workflow\n    type 'help' to view all commands\n"
      << std::endl;
}

std::string getTimestamp() {
  time_t now = time(0);
  struct tm *ltm = localtime(&now);
  char buffer[20];
  strftime(buffer, sizeof(buffer), "%H:%M:%S", ltm);
  return std::string(buffer);
}

std::string trim(const std::string &str) {
  size_t first = str.find_first_not_of(" \t");
  if (first == std::string::npos)
    return "";
  size_t last = str.find_last_not_of(" \t");
  return str.substr(first, last - first + 1);
}

void logError(const std::string &msg) {
  std::ofstream logFile("error.log", std::ios::app);
  if (logFile) {
    logFile << "[" << getTimestamp() << "] ERROR: " << msg << std::endl;
  }
  logFile.close();
}
