/* Copyright 2017 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#include "plaidml/bridge/tensorflow/tests/codegen_test.h"

#include "plaidml/bridge/tensorflow/service/compiler.h"

namespace xla {
namespace plaidml {

::plaidml::Program PlaidMLCodegenTest::CompileToProgram(std::unique_ptr<HloModule> hlo_module) {
  return PlaidMLCompiler::ProgramFromHloModule(std::move(hlo_module)).ValueOrDie();
}

Status PlaidMLCodegenTest::CompileAndCheck(std::unique_ptr<HloComputation> entry_computation,
                                           const TestCases& testcases) {
  HloModuleConfig cfg;
  auto hlo_module = absl::make_unique<HloModule>("module", cfg);
  hlo_module->AddEntryComputation(std::move(entry_computation));
  return CompileAndCheck(std::move(hlo_module), testcases);
}

Status PlaidMLCodegenTest::CompileAndCheck(std::unique_ptr<HloModule> hlo_module, const TestCases& testcases) {
  auto program = CompileToProgram(std::move(hlo_module));

  VLOG(2) << "Evaluating results";

  for (const TestCaseIO& io : testcases) {
    checkClose(program, io.inputs, io.outputs);
  }

  return Status::OK();
}

}  // namespace plaidml
}  // namespace xla
