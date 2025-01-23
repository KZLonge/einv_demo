  METHOD buildxml.
    DATA: lv_body TYPE string.
    DATA: lw_structure_line TYPE zeinv_st_payload.

    LOOP AT lt_journal_entry INTO DATA(lwa_journal_entry).
      lw_structure_line-eivheader = CORRESPONDING #( lwa_journal_entry ).

      lw_structure_line-eivitem = VALUE #( ( lineid = '1' descprodserv = 'Item 1' unitprice = '1.00' eivcurrency = 'MYR' taxamount = '0.06' )
                                           ( lineid = '2' descprodserv = 'Item 2' unitprice = '2.00' eivcurrency = 'MYR' taxamount = '0.12' ) ).

      APPEND lw_structure_line TO ex_payload.
    ENDLOOP.
    IF sy-subrc = 0.
      ex_string = 'No Table Entries'.
    ENDIF.

    CALL TRANSFORMATION ztrans_einv_xml
    SOURCE invoices = ex_payload
    RESULT XML lv_body
    OPTIONS xml_header     = 'no'
            value_handling = 'move'.
    IF sy-subrc = 0.
      ex_string = lv_body.
    ENDIF.

  ENDMETHOD.