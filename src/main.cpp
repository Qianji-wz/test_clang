#include <iostream>
#include <string>

#include "greeter.h"

auto main(int argc, char *argv[]) -> int {
  std::string name;
  if (argc > 1) {
    name = argv[1];
  }

  std::cout << test_clang::BuildGreeting(name) << '\n';
  return 0;
}
