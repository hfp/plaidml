package(default_visibility = ["//visibility:public"])

py_binary(
    name = "demo",
    srcs = [
        "app.py",
        "core.py",
        "demo.py",
        "style/custom_html.py",
    ],
    data = [
        "edsl_demo.ipynb",
        "lowering_demo.ipynb",
    ],
    deps = [
        "//plaidml:py",
        "//plaidml/edsl:py",
        "//plaidml/exec:py",
        "//plaidml/op:py",
    ],
)

py_binary(
    name = "voila",
    srcs = glob([
        "*.py",
        "style/*.py",
    ]),
    args = [
        "--no-browser",
        "$(location :lowering_demo.ipynb)",
    ],
    data = glob([
        "*.ipynb",
    ]),
    deps = [
        "//plaidml:py",
        "//plaidml/edsl:py",
        "//plaidml/exec:py",
        "//plaidml/op:py",
    ],
)
