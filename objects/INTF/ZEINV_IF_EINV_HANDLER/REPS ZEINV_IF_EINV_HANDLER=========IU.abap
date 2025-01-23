interface ZEINV_IF_EINV_HANDLER
  public .


  methods HANDLE_JOURNALENTRY_CREATED_V1
    importing
      !IO_EVENT type ref to ZIF_JOURNALENTRY_CREATED_V1
    raising
      /IWXBE/CX_EXCEPTION .
endinterface.