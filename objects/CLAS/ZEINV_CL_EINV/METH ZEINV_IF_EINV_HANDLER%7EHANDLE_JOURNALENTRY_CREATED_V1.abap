  METHOD zeinv_if_einv_handler~handle_journalentry_created_v1.

    " Event Type: sap.s4.beh.journalentry.v1.JournalEntry.Created.v1
    DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY z_journalentry_created_v1.
*
*
    ls_business_data = io_event->get_business_data( ).

    SELECT *
    FROM i_journalentry WITH PRIVILEGED ACCESS
    WHERE companycode = @ls_business_data-companycode
      AND fiscalyear = @ls_business_data-fiscalyear
      AND accountingdocument = @ls_business_data-accountingdocument
    INTO TABLE @lt_journal_entry.
    IF sy-subrc = 0.
      "Build XML
      me->buildxml( IMPORTING ex_payload = DATA(ls_payload)
                              ex_string = DATA(lv_xml_string) ).

      me->callapi(
        EXPORTING
          ex_payload = ls_payload
          ex_xml     = lv_xml_string
        RECEIVING
          result     = DATA(lv_status)
      ).


    ENDIF.



  ENDMETHOD.