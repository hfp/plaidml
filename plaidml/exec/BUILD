# Copyright 2019 Intel Corporation.

load("@rules_python//python:defs.bzl", "py_library")
load("//bzl:plaidml.bzl", "plaidml_cc_library")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")

SDK_HDRS = [
    "exec.h",
    "ffi.h",
]

exports_files([
    "ffi.h",
])

filegroup(
    name = "docs",
    srcs = ["exec.h"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "sdk",
    srcs = SDK_HDRS,
    visibility = ["//visibility:public"],
)

pkg_tar(
    name = "sdk_tar",
    srcs = [":sdk"],
    package_dir = "include/plaidml/exec",
    visibility = ["//visibility:public"],
)

plaidml_cc_library(
    name = "exec",
    srcs = [
        "ffi.cc",
    ],
    hdrs = SDK_HDRS,
    visibility = ["//visibility:public"],
    deps = [
        "//plaidml/core",
        "//pmlc/compiler",
        "//pmlc/rt",
        "//pmlc/util",
    ],
    alwayslink = 1,
)

py_library(
    name = "py",
    srcs = [
        "__init__.py",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//plaidml:py",
    ],
)
