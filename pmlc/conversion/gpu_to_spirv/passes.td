#ifndef __PMLC_CONVERSION_GPU_TO_SPIRV_PASSES__
#define __PMLC_CONVERSION_GPU_TO_SPIRV_PASSES__

include "mlir/Pass/PassBase.td"

def GPUToSPIRVCustom : Pass<"gpu-to-spirv-custom", "mlir::ModuleOp"> {
  let summary = "Custom lowering from GPU to SPIRV including stdx dialect";
  let constructor = "pmlc::conversion::gpu_to_spirv::createGPUToSPIRVCustomPass()";
  let options = [
    Option<"nonUniformBroadcast", "non-uniform-broadcast", "bool", /*default=*/"true",
           "Support non-uniform broadcast operation">,
  ];
}

#endif // __PMLC_CONVERSION_GPU_TO_SPIRV_PASSES__
