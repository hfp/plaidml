// RUN: pmlc-opencl-runner %s | FileCheck %s

// CHECK: [3.3,  3.3,  3.3,  3.3,  3.3,  3.3,  3.3,  3.3]
module attributes {
  gpu.container_module,
  spv.target_env = #spv.target_env<
    #spv.vce<v1.0, [Kernel, Addresses], []>,
    {max_compute_workgroup_invocations = 128 : i32,
     max_compute_workgroup_size = dense<[128, 128, 64]> : vector<3xi32>}>
} {
  gpu.module @kernels {
    gpu.func @kernel_add(%arg0 : memref<8xf32>, %arg1 : memref<8xf32>, %arg2 : memref<8xf32>)
      attributes {gpu.kernel, spv.entry_point_abi = {local_size = dense<[1, 1, 1]>: vector<3xi32>}} {
      %0 = "gpu.block_id"() {dimension = "x"} : () -> index
      %1 = load %arg0[%0] : memref<8xf32>
      %2 = load %arg1[%0] : memref<8xf32>
      %3 = addf %1, %2 : f32
      store %3, %arg2[%0] : memref<8xf32>
      gpu.return
    }
  }

  func @main() {
    %arg0 = alloc() : memref<8xf32>
    %arg1 = alloc() : memref<8xf32>
    %arg2 = alloc() : memref<8xf32>
    %0 = constant 0 : i32
    %1 = constant 1 : i32
    %2 = constant 2 : i32
    %value0 = constant 0.0 : f32
    %value1 = constant 1.1 : f32
    %value2 = constant 2.2 : f32
    %arg3 = memref_cast %arg0 : memref<8xf32> to memref<*xf32>
    %arg4 = memref_cast %arg1 : memref<8xf32> to memref<*xf32>
    %arg5 = memref_cast %arg2 : memref<8xf32> to memref<*xf32>
    %size3 = constant 8 : i32
    %size4 = constant 8 : i32
    %size5 = constant 8 : i32

    call @fillResourceFloat32(%arg3, %size3, %value1) : (memref<*xf32>, i32, f32) -> ()
    call @fillResourceFloat32(%arg4, %size4, %value2) : (memref<*xf32>, i32, f32) -> ()
    call @fillResourceFloat32(%arg5, %size5, %value0) : (memref<*xf32>, i32, f32) -> ()

    %cst1 = constant 1 : index
    %cst8 = constant 8 : index
    "gpu.launch_func"(%cst8, %cst1, %cst1, %cst1, %cst1, %cst1, %arg0, %arg1, %arg2) { kernel = @kernels::@kernel_add }
        : (index, index, index, index, index, index, memref<8xf32>, memref<8xf32>, memref<8xf32>) -> ()
    call @print_memref_f32(%arg5) : (memref<*xf32>) -> ()
    return
  }
  func @fillResourceFloat32(%0 : memref<*xf32>, %1 : i32, %2 : f32)
  func @print_memref_f32(%ptr : memref<*xf32>)
}
