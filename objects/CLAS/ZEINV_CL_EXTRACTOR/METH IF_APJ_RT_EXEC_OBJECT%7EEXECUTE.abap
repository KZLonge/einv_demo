  METHOD if_apj_rt_exec_object~execute.
    DATA: lt_invoice      TYPE TABLE OF zeinv_document,
          ls_invoice      TYPE zeinv_document,
          lt_rules        TYPE TABLE OF zeinv_rule,
          application_log TYPE REF TO cl_bali_log,
          lr_blart        TYPE RANGE OF i_journalentry-accountingdocumenttype,
          lr_belnr        TYPE RANGE OF i_journalentry-accountingdocument,
          lr_date         TYPE RANGE OF i_journalentry-postingdate.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_time) = cl_abap_context_info=>get_system_date( ).

    "Get Parameter
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_BLART'.
          INSERT CORRESPONDING #( ls_parameter ) INTO TABLE lr_blart.
        WHEN 'S_BELNR'.
          INSERT CORRESPONDING #( ls_parameter ) INTO TABLE lr_belnr.
        WHEN 'S_DATE'.
          INSERT CORRESPONDING #( ls_parameter ) INTO TABLE lr_date.
      ENDCASE.
    ENDLOOP.

    "Get Maintained Company Code + Document Type
    SELECT *
    FROM zeinv_rule
    WHERE validfromdate <= @lv_date
      AND validtodate >= @lv_time
        INTO TABLE @lt_rules.
    IF sy-subrc = 0.
      SELECT *
        FROM i_journalentry WITH PRIVILEGED ACCESS
        FOR ALL ENTRIES IN @lt_rules
        WHERE companycode = @lt_rules-companycode
        AND accountingdocumenttype = @lt_rules-accountingdocumenttype
        AND postingdate IN @lr_date
        AND accountingdocument IN @lr_belnr
        AND accountingdocumenttype IN @lr_blart
        INTO CORRESPONDING FIELDS OF TABLE @lt_invoice.
      IF sy-subrc = 0.
        IF lt_invoice[] IS NOT INITIAL.
          ls_invoice-status = 'Ready'.

          MODIFY lt_invoice FROM ls_invoice TRANSPORTING status WHERE uuid IS INITIAL.

          DATA(lv_count) = lines( lt_invoice ).
          MODIFY zeinv_document FROM TABLE @lt_invoice[].
          DATA(lv_message) = |{ 'No of records updated:' }{ lv_count }|.
          me->create_message_log(
            im_message = lv_message
            im_status  = 'S'
          ).
          COMMIT WORK.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.