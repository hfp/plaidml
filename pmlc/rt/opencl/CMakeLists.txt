pml_cc_library(
  NAME opencl
  HDRS register.h
  SRCS
    common_wrappers.cc
    opencl_device.cc
    opencl_device.h
    opencl_invocation.cc
    opencl_invocation.h
    opencl_runtime.cc
    opencl_wrappers.cc
    opencl_utils.h
    opencl_utils.cc
  DEPS
    pmlc::compiler
    pmlc::rt
    MLIRPass
    MLIRSPIRV
    mlir_runner_utils
    opencl_headers
    opencl_hpp_headers
    OpenCL
)
