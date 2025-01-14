  METHOD if_apj_dt_exec_object~get_parameters.
    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).

    et_parameter_def = VALUE #( datatype       = 'C'
                                  changeable_ind = abap_true
                                   ( selname    = 'S_BELNR'
                                    kind       = if_apj_dt_exec_object=>select_option
                                    param_text = 'Document Number'
                                    length     = 3 )
                                  ( selname       = 'S_DATE'
                                    kind          = if_apj_dt_exec_object=>select_option
                                    param_text    = 'Posting Date'
                                    mandatory_ind = abap_true
                                    length        = 10 )
*                                    lowercase_ind = abap_true
*                                    mandatory_ind = abap_true )
                                  ( selname    = 'S_BLART'
                                    kind       = if_apj_dt_exec_object=>select_option
                                    param_text = 'Document Type'
                                    length     = 3 )
                                  ( selname         = 'R_IND'
                                    kind            = if_apj_dt_exec_object=>parameter
                                    param_text      = 'Individual Invoice'
                                    length          = 1
                                    radio_group_ind = abap_true
                                    radio_group_id  = 'R1' )
                                  ( selname         = 'R_CON'
                                    kind            = if_apj_dt_exec_object=>parameter
                                    param_text      = 'Consol Invoice'
                                    length          = 1
                                    radio_group_ind = abap_true
                                    radio_group_id  = 'R1' )
                                  ( selname      = 'CB_TEST'
                                    kind         = if_apj_dt_exec_object=>parameter
                                    param_text   = 'Test Run'
                                    length       = 1
                                    checkbox_ind = abap_true ) ).

    et_parameter_val = VALUE #( sign   = 'I'
                                option = 'EQ'
                                ( selname = 'S_DATE' low = lv_date )
                                ( selname = 'CB_TEST' low = abap_true )
                                ( selname = 'R_IND' low = abap_true ) ).
  ENDMETHOD.