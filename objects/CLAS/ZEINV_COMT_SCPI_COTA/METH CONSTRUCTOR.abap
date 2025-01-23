  method CONSTRUCTOR.
  SUPER->constructor(
    EXPORTING
      id = cid
      template_pathprefix = CTEMPLATE_PATHPREFIX
      SECKEY = CONV int8( '330406110924353071-' )
      created_by_cota = Ccreated_by_cota
      multiple_appdests = CMULTIPLE_APPDESTS
     ).
  endmethod.