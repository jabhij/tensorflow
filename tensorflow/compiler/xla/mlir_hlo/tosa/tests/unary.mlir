// RUN: mhlo-tosa-opt %s --tosa-legalize-mhlo | FileCheck %s

// CHECK-LABEL: @abs
func.func @abs(%arg : tensor<10xf32>) -> tensor<10xf32> {
  // CHECK: tosa.abs
  %0 = "mhlo.abs"(%arg) : (tensor<10xf32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @ceil
func.func @ceil(%arg : tensor<10xf32>) -> tensor<10xf32> {
  // CHECK: tosa.ceil
  %0 = "mhlo.ceil"(%arg) : (tensor<10xf32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @convert
func.func @convert(%arg : tensor<10xi32>) -> tensor<10xf32> {
  // CHECK: tosa.cast
  %0 = "mhlo.convert"(%arg) : (tensor<10xi32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @exponential
func.func @exponential(%arg : tensor<10xf32>) -> tensor<10xf32> {
  // CHECK: tosa.exp
  %0 = "mhlo.exponential"(%arg) : (tensor<10xf32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @floor
func.func @floor(%arg : tensor<10xf32>) -> tensor<10xf32> {
  // CHECK: tosa.floor
  %0 = "mhlo.floor"(%arg) : (tensor<10xf32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @is_finite
func.func @is_finite(%arg : tensor<10xf32>) -> tensor<10xi1> {
  // CHECK-DAG: %[[VAR0:.*]] = "tosa.const"() {value = dense<0x7F800000>
  // CHECK-DAG: %[[VAR1:.*]] = "tosa.abs"(%arg0)
  // CHECK-DAG: %[[VAR2:.*]] = "tosa.equal"(%[[VAR1]], %[[VAR0]])
  // CHECK-DAG: %[[VAR3:.*]] = "tosa.logical_not"(%[[VAR2]])
  %0 = "mhlo.is_finite"(%arg) : (tensor<10xf32>) -> tensor<10xi1>
  return %0 : tensor<10xi1>
}

// CHECK-LABEL: @log
func.func @log(%arg : tensor<10xf32>) -> tensor<10xf32> {
  // CHECK: tosa.log
  %0 = "mhlo.log"(%arg) : (tensor<10xf32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @negate
func.func @negate(%arg : tensor<10xf32>) -> tensor<10xf32> {
  // CHECK: tosa.negate
  %0 = "mhlo.negate"(%arg) : (tensor<10xf32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @slice
func.func @slice(%arg : tensor<4x3xf32>) -> tensor<2x2xf32> {
  // CHECK: "tosa.slice"(%arg0) {size = [2, 2], start = [2, 1]}
  %0 = "mhlo.slice"(%arg) {
    start_indices = dense<[2, 1]> : tensor<2xi64>,
    limit_indices = dense<[4, 3]> : tensor<2xi64>,
    strides = dense<1> : tensor<2xi64>
  } : (tensor<4x3xf32>) -> tensor<2x2xf32>
  return %0 : tensor<2x2xf32>
}

// CHECK-LABEL: @slice_stride_not_one
func.func @slice_stride_not_one(%arg : tensor<4x3xf32>) -> tensor<2x1xf32> {
  // tosa.slice only supports strides of 1, so this should not legalize.
  // CHECK: "mhlo.slice"
  %0 = "mhlo.slice"(%arg) {
    start_indices = dense<[2, 1]> : tensor<2xi64>,
    limit_indices = dense<[4, 3]> : tensor<2xi64>,
    strides = dense<[1, 2]> : tensor<2xi64>
  } : (tensor<4x3xf32>) -> tensor<2x1xf32>
  return %0 : tensor<2x1xf32>
}

// CHECK-LABEL: @slice_rank_seven
func.func @slice_rank_seven(%arg : tensor<2x3x4x5x6x7x8xf32>) -> tensor<1x2x3x4x5x6x7xf32> {
  // tosa.slice only supports 1D to 6D tensors, so this should not legalize.
  // CHECK: "mhlo.slice"
  %0 = "mhlo.slice"(%arg) {
    start_indices = dense<[1, 1, 1, 1, 1, 1, 1]> : tensor<7xi64>,
    limit_indices = dense<[2, 3, 4, 5, 6, 7, 8]> : tensor<7xi64>,
    strides = dense<[1, 1, 1, 1, 1, 1, 1]> : tensor<7xi64>
  } : (tensor<2x3x4x5x6x7x8xf32>) -> tensor<1x2x3x4x5x6x7xf32>
  return %0 : tensor<1x2x3x4x5x6x7xf32>
}

// CHECK-LABEL: @tanh
func.func @tanh(%arg : tensor<10xf32>) -> tensor<10xf32> {
  // CHECK: tosa.tanh
  %0 = "mhlo.tanh"(%arg) : (tensor<10xf32>) -> tensor<10xf32>
  return %0 : tensor<10xf32>
}

// CHECK-LABEL: @transpose
func.func @transpose(%arg0: tensor<1x2x3xf32>) -> tensor<3x2x1xf32> {
  // CHECK-DAG: %[[VAR0:.*]] = "tosa.const"() {value = dense<[2, 1, 0]> : tensor<3xi64>} : () -> tensor<3xi64>
  // CHECK-DAG: %[[VAR1:.*]] = "tosa.transpose"(%arg0, %[[VAR0]])
  %0 = "mhlo.transpose"(%arg0) {permutation = dense<[2, 1, 0]> : tensor<3xi64>} : (tensor<1x2x3xf32>) -> tensor<3x2x1xf32>
  return %0 : tensor<3x2x1xf32>
}
