#ifndef UTILS_HPP
#define UTILS_HPP

#include <chrono>
#include <iostream>
#include <string>

#define RESET "\033[0m"
#define BOLD "\033[1m"
#define GRAY "\033[38;5;8m"
#define GREEN "\033[38;5;10m"
#define YELLOW "\033[38;5;11m"
#define CYAN "\033[38;5;14m"
#define RED "\033[38;5;9m"
#define BLUE "\033[38;5;12m"
#define MAGENTA "\033[38;5;13m"

#define __AUTHOR "mintRaven"
#define __VERSION "v1.0.0"
#define __LICENSE "BSD-3 Clause"
#define __URL "github.com/mintRaven-05/kagezo"

const std::string SCRIPT_DIR = "bin/";

void printBanner();
std::string getTimestamp();
std::string trim(const std::string &str);
void logError(const std::string &msg);

#endif
