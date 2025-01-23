CLASS zcl_test_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF http_status,
        code   TYPE i,
        reason TYPE string,
      END OF http_status .

    INTERFACES if_oo_adt_classrun .
