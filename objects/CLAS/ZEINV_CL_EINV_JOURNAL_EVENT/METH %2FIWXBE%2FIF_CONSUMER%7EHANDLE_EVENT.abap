METHOD /IWXBE/IF_CONSUMER~HANDLE_EVENT.

  " This is a generated class, which might be overwritten in the future.
  " Go to ZEINV_CL_EINV to add custom code.

  CASE io_event->get_cloud_event_type( ).
    WHEN 'sap.s4.beh.journalentry.v1.JournalEntry.Created.v1'.
      me->ZEINV_IF_EINV_HANDLER~handle_journalentry_created_v1( NEW LCL_JOURNALENTRY_CREATED_V1( io_event ) ).
    WHEN OTHERS.
      RAISE EXCEPTION TYPE /iwxbe/cx_exception
        EXPORTING
          textid = /iwxbe/cx_exception=>not_supported.
  ENDCASE.

ENDMETHOD.