class ZEINV_CL_EINV_JOURNAL_EVENT definition
  public
  abstract
  create public .

public section.

  interfaces /IWXBE/IF_CONSUMER .
  interfaces ZEINV_IF_EINV_HANDLER
      all methods abstract .