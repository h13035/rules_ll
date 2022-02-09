LIBCXXABI_BUILD_FILE = """load("@rules_ll//ll:defs.bzl", "ll_bootstrap_library")

filegroup(
    name = "libcxxabi_headers",
    srcs = glob(["include/**"]),
    visibility = ["//visibility:public"],
)

ll_bootstrap_library(
    name = "libll_cxxabi",
    deps = ["//libcxxabi/src:src"],
    transitive_hdrs = [":libcxxabi_headers"],
    visibility = ["//visibility:public"],
)"""

LIBCXXABI_SRC_BUILD_FILE = """load("@rules_ll//ll:defs.bzl", "ll_bootstrap_library")

ll_bootstrap_library(
    name = "src",
    srcs = [
        # C++ABI files
        "cxa_aux_runtime.cpp",
        "cxa_default_handlers.cpp",
        "cxa_demangle.cpp",
        "cxa_exception_storage.cpp",
        "cxa_guard.cpp",
        "cxa_handlers.cpp",
        "cxa_vector.cpp",
        "cxa_virtual.cpp",

        # C++ STL files
        "stdlib_exception.cpp",
        "stdlib_stdexcept.cpp",
        "stdlib_typeinfo.cpp",

        # Internal files
        "abort_message.cpp",
        "fallback_malloc.cpp",
        "private_typeinfo.cpp",

        # New/Delete
        "stdlib_new_delete.cpp",

        # Exceptions
        "cxa_exception.cpp",
        "cxa_personality.cpp",
    ],
    hdrs = [
        # C++ABI files.
        "cxa_handlers.h",
        "cxa_guard_impl.h",

        # C++ STL files.
        "abort_message.h",
        "fallback_malloc.h",
        "private_typeinfo.h",

        # Exceptions.
        "cxa_exception.h",

        # Demangle
        "demangle/DemangleConfig.h",
        "demangle/ItaniumDemangle.h",
        "demangle/StringView.h",
        "demangle/Utility.h",

        # Other required headers.
        "//libcxx:libcxx_headers",
        "//libcxx/src:libcxx_src_headers",
        "//libcxxabi:libcxxabi_headers"
    ],
    # Libcxxabi requires some files from libc++.
    includes = ["external/llvm-project/libcxx/src"],
    defines = [
        "LIBCXX_BUILDING_LIBCXXABI",
        "HAVE___CXA_THREAD_ATEXIT_IMPL",  # 3 underscores.
        "LIBCXXABI_USE_LLVM_UNWINDER",
        "_LIBCPP_BUILDING_LIBRARY",
        "_LIBCPP_DISABLE_EXTERN_TEMPLATE",
        "_LIBCXXABI_BUILDING_LIBRARY",
        "_LIBCXXABI_LINK_PTHREAD_LIB",
        "__STDC_CONSTANT_MACROS",
        "__STDC_FORMAT_MACROS",
        "__STDC_LIMIT_MACROS",
        "CHAR_BIT=8",
        "INT_MAX=+2147483647",
    ],
    compile_flags = [
        "-nostdinc++",
        "-std=c++20",
        "-faligned-allocation",
        "-funwind-tables",
        "-fstrict-aliasing",
        "-fvisibility-inlines-hidden",
    ],
    visibility = ["//visibility:public"],
)"""