#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#include <windows.h>
#endif

#include "moonbit.h"

MOONBIT_FFI_EXPORT int
moonbit_sqlsentinel_run_git_diff(moonbit_bytes_t base,
                                 moonbit_bytes_t output_path) {
#ifdef _WIN32
  int base_size =
      MultiByteToWideChar(CP_UTF8, 0, (const char *)base, -1, NULL, 0);
  int output_size =
      MultiByteToWideChar(CP_UTF8, 0, (const char *)output_path, -1, NULL, 0);
  if (base_size <= 0 || output_size <= 0) {
    return 1;
  }

  wchar_t *wide_base = (wchar_t *)malloc(sizeof(wchar_t) * base_size);
  wchar_t *wide_output =
      (wchar_t *)malloc(sizeof(wchar_t) * output_size);
  wchar_t command[4096];
  if (wide_base == NULL || wide_output == NULL) {
    free(wide_base);
    free(wide_output);
    return 1;
  }
  MultiByteToWideChar(CP_UTF8, 0, (const char *)base, -1, wide_base,
                      base_size);
  MultiByteToWideChar(CP_UTF8, 0, (const char *)output_path, -1, wide_output,
                      output_size);
  int written = _snwprintf(
      command, 4096,
      L"git --no-pager -c core.quotePath=false diff --name-only -z "
      L"--diff-filter=ACMR \"%ls\" -- > \"%ls\" 2>nul",
      wide_base, wide_output);
  free(wide_base);
  free(wide_output);
  if (written < 0 || written >= 4096) {
    return 1;
  }
  return _wsystem(command) == 0 ? 0 : 1;
#else
  char command[4096];
  int written = snprintf(
      command, sizeof(command),
      "git --no-pager -c core.quotePath=false diff --name-only -z "
      "--diff-filter=ACMR \"%s\" -- > \"%s\" 2>/dev/null",
      (const char *)base, (const char *)output_path);
  if (written < 0 || (size_t)written >= sizeof(command)) {
    return 1;
  }
  return system(command) == 0 ? 0 : 1;
#endif
}

#ifdef __cplusplus
}
#endif
