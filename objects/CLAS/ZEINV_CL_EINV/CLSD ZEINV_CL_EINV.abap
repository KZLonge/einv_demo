class-pool .
*"* class pool for class ZEINV_CL_EINV

*"* local type definitions
include ZEINV_CL_EINV=================ccdef.

*"* class ZEINV_CL_EINV definition
*"* public declarations
  include ZEINV_CL_EINV=================cu.
*"* protected declarations
  include ZEINV_CL_EINV=================co.
*"* private declarations
  include ZEINV_CL_EINV=================ci.
endclass. "ZEINV_CL_EINV definition

*"* macro definitions
include ZEINV_CL_EINV=================ccmac.
*"* local class implementation
include ZEINV_CL_EINV=================ccimp.

*"* test class
include ZEINV_CL_EINV=================ccau.

class ZEINV_CL_EINV implementation.
*"* method's implementations
  include methods.
endclass. "ZEINV_CL_EINV implementation
