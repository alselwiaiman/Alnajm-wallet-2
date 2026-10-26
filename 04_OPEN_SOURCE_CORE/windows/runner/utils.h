#ifndef RUNNER_UTILS_H_
#define RUNNER_UTILS_H_

#include <string>
#include <vector>

// Creates a console for the process, and redirects stdout and stderr to
// the console.
void CreateAndAttachConsole();

// Takes a null-terminated wchar_t* encoded in UTF-16 and returns a std::string
// encoded in UTF-8. Returns an empty std::string on failure.
std::string Utf8FromUtf16(const wchar_t* utf16_string);

// Takes a null-terminated char* encoded in UTF-8 and returns a std::wstring
// encoded in UTF-16. Returns an empty std::wstring on failure.
std::wstring Utf16FromUtf8(const char* utf8_string);

// Gets the command line arguments passed in as a std::vector<std::string>,
// encoded in UTF-8.
std::vector<std::string> GetCommandLineArguments();

#endif  // RUNNER_UTILS_H_
