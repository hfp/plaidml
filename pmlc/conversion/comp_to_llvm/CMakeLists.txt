pml_cc_library(
  NAME comp_to_llvm
  HDRS
    passes.h
  SRCS
    common.cc
    comp_to_llvm.cc
    utils.cc
  DEPS
    ::passes-gen
    pmlc::conversion::stdx_to_llvm
    pmlc::dialect::comp::ir
    pmlc::util
    MLIRLLVMIR
    MLIRSPIRV
    MLIRSPIRVSerialization
    MLIRStandard
    MLIRIR
    MLIRPass
    MLIRTransforms
    MLIRStandardOpsTransforms
    MLIRSupport
)

pml_tblgen_library(
  NAME passes-gen
  TD_FILE passes.td
  OUTS
    -gen-pass-decls passes.h.inc
)
