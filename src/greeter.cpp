#include "greeter.h"

namespace test_clang {

auto BuildGreeting(const std::string &name) -> std::string {
  if (name.empty()) {
    return "Hello, CMake C++ Project!";
  }
  return "Hello, " + name + "!";
}

}  // namespace test_clang
