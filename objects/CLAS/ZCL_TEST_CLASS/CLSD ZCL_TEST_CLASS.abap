class-pool .
*"* class pool for class ZCL_TEST_CLASS

*"* local type definitions
include ZCL_TEST_CLASS================ccdef.

*"* class ZCL_TEST_CLASS definition
*"* public declarations
  include ZCL_TEST_CLASS================cu.
*"* protected declarations
  include ZCL_TEST_CLASS================co.
*"* private declarations
  include ZCL_TEST_CLASS================ci.
endclass. "ZCL_TEST_CLASS definition

*"* macro definitions
include ZCL_TEST_CLASS================ccmac.
*"* local class implementation
include ZCL_TEST_CLASS================ccimp.

*"* test class
include ZCL_TEST_CLASS================ccau.

class ZCL_TEST_CLASS implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_TEST_CLASS implementation
